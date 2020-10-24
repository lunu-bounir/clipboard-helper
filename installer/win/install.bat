@echo off

pushd "%~dp0"

SET FILE=helper.exe
SET ID=desktop.clipboard.manager

SET PATH=C:\Windows\System32;%PATH%

ECHO .. Kill already running instances
taskkill /im %FILE% /f >nul 2>&1

ECHO.
ECHO .. Copy %FILE% to %LocalAPPData%\%ID%\
mkdir %LocalAPPData%\%ID%
copy /Y %FILE% %LocalAPPData%\%ID%\

ECHO .. Copy Firefox manifest to %LocalAPPData%\%ID%\manifest-firefox.json
(
  ECHO {
  ECHO   "name": "desktop.clipboard.manager",
  ECHO   "description": "native part of the Clipboard History Manager extension",
  ECHO   "path": "%FILE%",
  ECHO   "type": "stdio",
  ECHO   "allowed_extensions": ["{82b3a366-18e0-4400-aa21-36a966d0a42e}"]
  ECHO }
) > %LocalAPPData%\%ID%\manifest-firefox.json
ECHO .. Copy Chrome manifest to %LocalAPPData%\%ID%\manifest-chrome.json
(
  ECHO {
  ECHO   "name": "desktop.clipboard.manager",
  ECHO   "description": "native part of the Clipboard History Manager extension",
  ECHO   "path": "%FILE%",
  ECHO   "type": "stdio",
  ECHO   "allowed_origins": ["chrome-extension://dcpgnicohhclhnjfchhbjaonpnedimig/", "chrome-extension://pkigjgihlaonoomgjgannieikjecdhil/", "chrome-extension://empcclfpdmhckpdfpgljnbbkcakfnbho/"]
  ECHO }
) > %LocalAPPData%\%ID%\manifest-chrome.json

ECHO.
ECHO .. Writting to Chrome Registry
ECHO .. Key: HKCU\Software\Google\Chrome\NativeMessagingHosts\%ID%
REG ADD "HKCU\Software\Google\Chrome\NativeMessagingHosts\%ID%" /ve /t REG_SZ /d "%LocalAPPData%\%ID%\manifest-chrome.json" /f
ECHO .. Writting to Chromium Registry
ECHO .. Key: HKCU\Software\Chromium\NativeMessagingHosts\%ID%
REG ADD "HKCU\Software\Chromium\NativeMessagingHosts\%ID%" /ve /t REG_SZ /d "%LocalAPPData%\%ID%\manifest-chrome.json" /f
ECHO .. Writting to Edge Registry
ECHO .. Key: HKCU\Software\Microsoft\Edge\NativeMessagingHosts\%ID%
REG ADD "HKCU\Software\Microsoft\Edge\NativeMessagingHosts\%ID%" /ve /t REG_SZ /d "%LocalAPPData%\%ID%\manifest-chrome.json" /f

FOR %%f in ("%LocalAPPData%") do SET SHORT_PATH=%%~sf
ECHO.
ECHO .. Writting to Firefox Registry
ECHO .. Key: HKCU\SOFTWARE\Mozilla\NativeMessagingHosts\%ID%
REG ADD "HKCU\SOFTWARE\Mozilla\NativeMessagingHosts\%ID%" /ve /t REG_SZ /d "%SHORT_PATH%\%ID%\manifest-firefox.json" /f
ECHO .. Writting to Waterfox Registry
ECHO .. Key: HKCU\SOFTWARE\Waterfox\NativeMessagingHosts\%ID%
REG ADD "HKCU\SOFTWARE\Waterfox\NativeMessagingHosts\%ID%" /ve /t REG_SZ /d "%SHORT_PATH%\%ID%\manifest-firefox.json" /f
ECHO .. Writting to Thunderbird Registry
ECHO .. Key: HKCU\SOFTWARE\Thunderbird\NativeMessagingHosts\%ID%
REG ADD "HKCU\SOFTWARE\Thunderbird\NativeMessagingHosts\%ID%" /ve /t REG_SZ /d "%SHORT_PATH%\%ID%\manifest-firefox.json" /f

echo .. Done!
pause
