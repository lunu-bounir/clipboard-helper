#include <Cocoa/Cocoa.h>
#include <unistd.h>
#include <iostream>

void ClipboardWait() {
  NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
  const int old = pasteboard.changeCount;

  while(pasteboard.changeCount == old && std::cin.good()) {
    usleep(5e5);
  }
}
