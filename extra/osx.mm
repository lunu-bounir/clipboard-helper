#include <Cocoa/Cocoa.h>
#include <string>

std::string paste() {
  NSPasteboard* pasteboard = [NSPasteboard generalPasteboard];
  NSString* contents = [pasteboard stringForType:NSPasteboardTypeString];

  if ([contents length] == 0) { //string is empty or nil
    return "";
  }

  return std::string([contents UTF8String]);
}

void ClipboardWait() {
  NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
  const int old = pasteboard.changeCount;

  while(pasteboard.changeCount == old) {
    usleep(500000);
  }
}

int pid() {
  //return NSWorkspace.sharedWorkspace.frontmostApplication.processIdentifier;
  for (NSRunningApplication *currApp in [[NSWorkspace sharedWorkspace] runningApplications]) {
    if ([currApp isActive]) {
      return currApp.processIdentifier;
    }
  }
  return -1;
}

void focus(int pid) {
  NSRunningApplication *app = [NSRunningApplication runningApplicationWithProcessIdentifier:pid];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
  // activate(options:) is the documented NSRunningApplication API (there is no
  // zero-argument activate selector on this class). The flag it takes is ignored
  // by the macOS 14+ cooperative activation, but the call itself is kept for
  // older systems and marked deprecated-but-present through current SDKs.
  [app activateWithOptions:NSApplicationActivateIgnoringOtherApps];
#pragma clang diagnostic pop
}
