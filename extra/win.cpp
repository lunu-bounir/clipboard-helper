#include <iostream>
#include <windows.h>
#include <string>

LRESULT CALLBACK WndProc(HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam);

std::string paste() {
  if (! OpenClipboard(nullptr))
    throw 20;

  HANDLE hData = GetClipboardData(CF_TEXT);
  if (hData == nullptr)
    throw 21;

  char * pszText = static_cast<char*>(GlobalLock(hData));
  if (pszText == nullptr)
    throw 22;

  std::string text(pszText);

  GlobalUnlock(hData);

  CloseClipboard();

  return text;
}

void ClipboardWait() {
  const char szClassName[] = "Clipboard Manager";
  WNDCLASS windowClass = {0};
  windowClass.hbrBackground = (HBRUSH)GetStockObject(WHITE_BRUSH);
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
