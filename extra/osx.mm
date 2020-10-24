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

void insert() {
  CGEventSourceRef eventSource = CGEventSourceCreate(kCGEventSourceStateHIDSystemState);
  CGEventRef keyEventDown = CGEventCreateKeyboardEvent(eventSource, 0, true);
  NSString * characters = @"this is a sample text";
  UniChar buffer;
  for (int i = 0; i < [characters length]; i++) {
    [characters getCharacters:&buffer range:NSMakeRange(i, 1)];
    keyEventDown = CGEventCreateKeyboardEvent(eventSource, 1, true);
    CGEventKeyboardSetUnicodeString(keyEventDown, 1, &buffer);
    CGEventPost(kCGHIDEventTap, keyEventDown);
    CFRelease(keyEventDown);
  }
  CFRelease(eventSource);
}
