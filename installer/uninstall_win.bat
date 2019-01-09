@echo off

pushd "%~dp0"

SET ID="desktop.clipboard.manager"
SET FILE=helper_win.exe

ECHO .. Deleting Chrome Registry
REG DELETE "HKCU\Software\Google\Chrome\NativeMessagingHosts\%ID%" /f

ECHO .. Deleting Firefox Registry
for %%f in ("%LocalAPPData%") do SET SHORT_PATH=%%~sf
REG DELETE "HKCU\SOFTWARE\Mozilla\NativeMessagingHosts\%ID%" /f

ECHO .. Kill already running instances
taskkill /im %FILE% /f >nul 2>&1

ECHO .. Deleting %ID% directory
RMDIR /Q /S "%LocalAPPData%\%ID%"

ECHO .. Clean-up
IF EXIST wget.js DEL /F wget.js
IF EXIST helper_win.exe DEL /F %FILE%

ECHO.
ECHO .. Done!
pause

