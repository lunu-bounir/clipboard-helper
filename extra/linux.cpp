// X11 backend for the Clipboard History Manager helper.
//
// Clipboard changes are detected with the XFixes "selection owner notify" event
// instead of polling, and content is requested as UTF8_STRING using the standard
// X selection protocol (including INCR transfers for large payloads).
//
// Works under X11 and under Wayland compositors that bridge the clipboard to
// XWayland (Mutter/GNOME, KWin/KDE, and Sway with an XWayland-compatible bridge).

#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <X11/extensions/Xfixes.h>
#include <cstdlib>
#include <iostream>
#include <string>
#include <sys/select.h>
#include <sys/time.h>
#include <unistd.h>

namespace {

Display* display() {
  static Display* dpy = XOpenDisplay(nullptr);
  return dpy;
}

Atom utf8_string_atom(Display* dpy) {
  return XInternAtom(dpy, "UTF8_STRING", False);
}

Atom incr_atom(Display* dpy) {
  return XInternAtom(dpy, "INCR", False);
}

Atom property_atom(Display* dpy) {
  return XInternAtom(dpy, "CH_HELPER_PROPERTY", False);
}

Atom clipboard_atom(Display* dpy) {
  // CLIPBOARD is not among the predefined atoms (unlike PRIMARY)
  return XInternAtom(dpy, "CLIPBOARD", False);
}

// XNextEvent with a timeout in milliseconds; a negative timeout waits forever.
// Prevents the helper from hanging forever when a selection owner never answers.
bool next_event(Display* dpy, XEvent* ev, long timeout_ms) {
  int fd = ConnectionNumber(dpy);

  while (XPending(dpy) == 0) {
    fd_set fds;
    FD_ZERO(&fds);
    FD_SET(fd, &fds);
    struct timeval* tvp = nullptr;
    struct timeval tv;
    if (timeout_ms >= 0) {
      tv.tv_sec = timeout_ms / 1000;
      tv.tv_usec = (timeout_ms % 1000) * 1000;
      tvp = &tv;
    }
    if (select(fd + 1, &fds, nullptr, nullptr, tvp) <= 0) {
      return false; // timed out or interrupted
    }
  }

  XNextEvent(dpy, ev);
  return true;
}

// Read the complete content of a window property into "text".
bool read_property(Display* dpy, Window win, Atom property, std::string* text) {
  text->clear();

  unsigned long offset = 0; // long units (4 bytes for 8-bit properties)
  while (true) {
    Atom type = None;
    int format = 0;
    unsigned long items = 0;
    unsigned long left = 0;
    unsigned char* data = nullptr;

    if (XGetWindowProperty(dpy, win, property, offset, 0x1fff, False,
                           AnyPropertyType, &type, &format,
                           &items, &left, &data) != Success) {
      return false;
    }

    if (format != 8) { // selection is expected to be provided in 8-bit chunks
      if (data != nullptr) {
        XFree(data);
      }
      return false;
    }

    if (items > 0 && data != nullptr) {
      text->append(reinterpret_cast<char*>(data), items);
    }

    const bool more = left > 0;
    if (data != nullptr) {
      XFree(data);
    }
    if (!more) {
      break;
    }
    // Every full chunk except the last one is a multiple of 4 bytes
    offset = text->size() / 4;
  }

  return true;
}

} // namespace

// debug tracing (enabled with CH_HELPER_DEBUG=1) goes to stderr
static void trace(const std::string& message) {
  if (getenv("CH_HELPER_DEBUG") != nullptr) {
    struct timeval now;
    gettimeofday(&now, nullptr);
    std::cerr << "[" << (now.tv_sec % 1000) << "." << now.tv_usec / 1000 << "] " << message << "\n";
  }
}

std::string paste() {
  Display* dpy = display();
  if (dpy == nullptr) {
    return "";
  }

  Window owner = XGetSelectionOwner(dpy, clipboard_atom(dpy));
  if (owner == None) { // nothing copied
    trace("paste: no CLIPBOARD owner");
    return "";
  }
  trace("paste: owner=" + std::to_string(owner));

  Window win = XCreateSimpleWindow(dpy, DefaultRootWindow(dpy), 0, 0, 1, 1, 0, 0, 0);
  XSelectInput(dpy, win, PropertyChangeMask);
  XFlush(dpy);
  XSync(dpy, False);

  Atom utf8 = utf8_string_atom(dpy);
  Atom incr = incr_atom(dpy);
  Atom property = property_atom(dpy);

  XDeleteProperty(dpy, win, property);
  XConvertSelection(dpy, clipboard_atom(dpy), utf8, property, win, CurrentTime);
  XFlush(dpy);

  std::string text;
  bool incremental = false;
  long transfer_size = 0;
  XEvent ev;

  while (next_event(dpy, &ev, 5000)) {
    if (ev.type == SelectionNotify) {
      if (ev.xselection.property == None) { // owner failed to convert
        break;
      }

      Atom type = None;
      int format = 0;
      unsigned long items = 0;
      unsigned long left = 0;
      unsigned char* data = nullptr;

      // one long item is read: for INCR announcements it carries the pending size
      XGetWindowProperty(dpy, win, ev.xselection.property, 0, 1, False,
                         AnyPropertyType, &type, &format, &items, &left, &data);

      if (type == incr) {
        // Incremental transfer: the owner will write chunks to the property and
        // wait for us to delete it after each chunk. The announce property
        // carries the total pending size (one 32-bit item).
        incremental = true;
        if (data != nullptr && items == 1 && format == 32) {
          transfer_size = *reinterpret_cast<long*>(data);
        }
        trace("paste: INCR transfer started, pending " + std::to_string(transfer_size) + " bytes");
        if (data != nullptr) {
          XFree(data);
          data = nullptr;
        }
        XDeleteProperty(dpy, win, ev.xselection.property);
        XFlush(dpy);
        continue;
      }

      read_property(dpy, win, ev.xselection.property, &text);
      XDeleteProperty(dpy, win, ev.xselection.property);
      trace("paste: read " + std::to_string(text.size()) + " bytes");
      break;
    }

    if (incremental && ev.type == PropertyNotify && ev.xproperty.state == PropertyNewValue) {
      std::string chunk;
      read_property(dpy, win, ev.xproperty.atom, &chunk);
      text += chunk;

      XDeleteProperty(dpy, win, ev.xproperty.atom);
      XFlush(dpy);

      trace("paste: INCR chunk of " + std::to_string(chunk.size()) + " bytes, total " +
            std::to_string(text.size()));

      // A fast/misbehaving owner may already have overwritten the property with
      // the zero-size terminator before we read the previous chunk, so the
      // announced total decides completion (items == 0 is not reliable on its own).
      if (chunk.size() == 0 && (transfer_size <= 0 || text.size() >= (unsigned long)transfer_size)) {
        break;
      }
    }
  }

  XDestroyWindow(dpy, win);
  XFlush(dpy);

  return text;
}

void ClipboardWait() {
  Display* dpy = display();
  if (dpy == nullptr) {
    return;
  }

  int event_base = 0;
  int error_base = 0;
  if (XFixesQueryExtension(dpy, &event_base, &error_base) == False) {
    // No XFixes available (rare): fall back to polling the selection owner
    Window old = XGetSelectionOwner(dpy, clipboard_atom(dpy));
    while (XGetSelectionOwner(dpy, clipboard_atom(dpy)) == old) {
      usleep(500000);
    }
    return;
  }

  Window win = XCreateSimpleWindow(dpy, DefaultRootWindow(dpy), 0, 0, 1, 1, 0, 0, 0);
  XFixesSelectSelectionInput(dpy, win, clipboard_atom(dpy), XFixesSetSelectionOwnerNotifyMask);
  XFlush(dpy);

  XEvent ev;
  // Wait for an actual selection-owner change. Events of other types
  // (leftover PropertyNotify from previous reads, etc.) are skipped.
  while (next_event(dpy, &ev, -1)) {
    if (ev.type == event_base + XFixesSelectionNotify) {
      trace("wait: clipboard change confirmed (type " + std::to_string(ev.type) + ")");
      break;
    }
    trace("wait: skipping stray event of type " + std::to_string(ev.type));
  }

  XDestroyWindow(dpy, win);
  XFlush(dpy);
}

int pid() {
  return -1;
}

void focus(int pid) {}
