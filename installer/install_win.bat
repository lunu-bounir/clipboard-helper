@echo off

pushd "%~dp0"

SET FILE=helper_win.exe
SET VERSION=0.1.1
SET ID=desktop.clipboard.manager

SET PATH=C:\Windows\System32;%PATH%
SET URL="https://github.com/lunu-bounir/clipboard-helper/releases/download/%VERSION%/%FILE%"

IF EXIST %FILE% DEL /F %FILE%
IF EXIST wget.js DEL /F wget.js

ECHO .. Downloading %FILE% from github releases
ECHO %URL%

echo var WinHttpReq = new ActiveXObject('WinHttp.WinHttpRequest.5.1'); > wget.js
echo WinHttpReq.Open('GET', WScript.Arguments(0), false); >> wget.js
echo WinHttpReq.Send(); >> wget.js
echo BinStream = new ActiveXObject('ADODB.Stream'); >> wget.js
echo BinStream.Type = 1; >> wget.js
echo BinStream.Open(); >> wget.js
echo BinStream.Write(WinHttpReq.ResponseBody); >> wget.js
echo BinStream.SaveToFile(WScript.Arguments(1)); >> wget.js
cscript wget.js %URL% %FILE%
copy /Y %FILE% %LocalAPPData%\%ID%\

ECHO.
ECHO .. Writting to Chrome Registry
ECHO .. Key: HKCU\Software\Google\Chrome\NativeMessagingHosts\%ID%
REG ADD "HKCU\Software\Google\Chrome\NativeMessagingHosts\%ID%" /ve /t REG_SZ /d "%LocalAPPData%\%ID%\manifest-chrome.json" /f

ECHO.
ECHO .. Writting to Firefox Registry
ECHO .. Key: HKCU\SOFTWARE\Mozilla\NativeMessagingHosts\%ID%
FOR %%f in ("%LocalAPPData%") do SET SHORT_PATH=%%~sf
REG ADD "HKCU\SOFTWARE\Mozilla\NativeMessagingHosts\%ID%" /ve /t REG_SZ /d "%SHORT_PATH%\%ID%\manifest-firefox.json" /f

ECHO .. Kill already running instances
taskkill /im %FILE% /f >nul 2>&1

ECHO.
ECHO .. Copy Files
mkdir %LocalAPPData%\%ID%
(
  ECHO {
  ECHO   "name": "desktop.clipboard.manager",
  ECHO   "description": "native part of the Desktop Clipboard Manager extension",
  ECHO   "path": "helper_win.exe",
  ECHO   "type": "stdio",
  ECHO   "allowed_extensions": ["4948871b49c16729cf376bc1328243311ebd5f3f@temporary-addon"]
  ECHO }
) > %LocalAPPData%\%ID%\manifest-firefox.json
(
  ECHO {
  ECHO   "name": "desktop.clipboard.manager",
  ECHO   "description": "native part of the Desktop Clipboard Manager extension",
  ECHO   "path": "helper_win.exe",
  ECHO   "type": "stdio",
  ECHO   "allowed_origins": ["chrome-extension://flobepdpiekfpcbajhbkppndnoiiaipa/"]
  ECHO }
) > %LocalAPPData%\%ID%\manifest-chrome.json

ECHO.
ECHO .. Clean-up
IF EXIST %FILE% DEL /F %FILE%
IF EXIST wget.js DEL /F wget.js

echo .. Done!
pause
