#include <Cocoa/Cocoa.h>
#include <unistd.h>
#include <iostream>

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
