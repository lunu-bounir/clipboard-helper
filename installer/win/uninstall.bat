@echo off

pushd "%~dp0"

SET ID="desktop.clipboard.manager"
SET FILE=helper.exe

ECHO .. Deleting Chrome Registry
REG DELETE "HKCU\Software\Google\Chrome\NativeMessagingHosts\%ID%" /f
ECHO .. Deleting Chromium Registry
REG DELETE "HKCU\Software\Chromium\NativeMessagingHosts\%ID%" /f
ECHO .. Deleting Edge Registry
REG DELETE "HKCU\Software\Microsoft\Edge\NativeMessagingHosts\%ID%" /f

ECHO .. Deleting Firefox Registry
REG DELETE "HKCU\SOFTWARE\Mozilla\NativeMessagingHosts\%ID%" /f
ECHO .. Deleting Waterfox Registry
REG DELETE "HKCU\SOFTWARE\Waterfox\NativeMessagingHosts\%ID%" /f
ECHO .. Deleting Thunderbird Registry
REG DELETE "HKCU\SOFTWARE\Thunderbird\NativeMessagingHosts\%ID%" /f

ECHO .. Kill already running instances
taskkill /im %FILE% /f >nul 2>&1

ECHO .. Deleting %ID% directory
RMDIR /Q /S "%LocalAPPData%\%ID%"

ECHO.
ECHO .. Done!
pause

