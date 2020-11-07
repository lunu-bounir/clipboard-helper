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
    usleep(5e5);
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
  [app activateWithOptions:NSApplicationActivateIgnoringOtherApps];
}
