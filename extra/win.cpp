#include <iostream>
#include <windows.h>
#include <string>

LRESULT CALLBACK WndProc(HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam);

// UTF-8 clipboard text (unlike CF_TEXT, this preserves non-ASCII characters).
std::string paste() {
  if (!OpenClipboard(nullptr))
    throw 20;

  std::string text;

  HANDLE hData = GetClipboardData(CF_UNICODETEXT);
  if (hData != nullptr) {
    wchar_t *wtext = static_cast<wchar_t*>(GlobalLock(hData));
    if (wtext == nullptr)
      throw 22;

    // WideCharToMultiByte(-1) returns the byte count including the terminating null
    int len = WideCharToMultiByte(CP_UTF8, 0, wtext, -1, nullptr, 0, nullptr, nullptr);
    if (len > 1) {
      text.resize(len - 1);
      WideCharToMultiByte(CP_UTF8, 0, wtext, -1, &text[0], len - 1, nullptr, nullptr);
    }

    GlobalUnlock(hData);
  }
  // No CF_UNICODETEXT on the clipboard (image, file list, empty): report empty
  // text like the macOS implementation does instead of aborting the process.

  CloseClipboard();

  return text;
}

void ClipboardWait() {
  const char szClassName[] = "Clipboard Manager";
  WNDCLASS windowClass = {0};
  windowClass.hCursor = LoadCursor(NULL, IDC_ARROW);
  windowClass.hInstance = NULL;
  windowClass.lpfnWndProc = WndProc;
  windowClass.lpszClassName = szClassName;
  windowClass.style = CS_HREDRAW | CS_VREDRAW;
  if (!RegisterClass(&windowClass)) {
    throw ("cannot register");
  }
  HWND windowHandle=CreateWindow(szClassName, NULL, WS_POPUP, 0, 0, 50, 50, NULL, NULL, NULL, NULL);

  MSG messages;
  while(GetMessage(&messages, NULL, 0, 0)) {
    TranslateMessage(&messages);
    DispatchMessage(&messages);
  }
}

LRESULT CALLBACK WndProc(HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam) {
  switch (message) {
  case WM_CREATE:
    AddClipboardFormatListener(hwnd);
    break;
  case WM_CLIPBOARDUPDATE:
    RemoveClipboardFormatListener(hwnd);
    DestroyWindow(hwnd);
    break;
  case WM_CHAR: //this is just for a program exit besides window's borders/task bar
    if (wparam==VK_ESCAPE) {
      DestroyWindow(hwnd);
    }
  case WM_DESTROY:
    PostQuitMessage(0);
    break;
  default:
    return DefWindowProc(hwnd, message, wparam, lparam);
  }
  return 0;
}

int pid() {
  return -1;
}

void focus(int pid) {}
