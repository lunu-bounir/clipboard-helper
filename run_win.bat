@echo off

rem Locate Visual Studio through vswhere (works for any installed VS year)
FOR /f "usebackq tokens=*" %%i in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do SET VSPATH=%%i

IF "%VSPATH%"=="" (
  ECHO Visual Studio with C++ tools not found
  exit /b 1
)

call "%VSPATH%\Common7\Tools\VsDevCmd.bat" -arch=amd64

IF errorlevel 1 (
  ECHO VsDevCmd.bat failed
  exit /b 1
)

rem json.hpp is vendored in the "vendor" directory (no network access needed at build time)
copy /Y helper.mm helper.cpp >nul

rem Windows icon-only resource: version information (missing version info is a
rem known source of antivirus false positives)
rc.exe /fo helper.res helper.rc
IF errorlevel 1 exit /b 1

cl.exe /D NDEBUG /c /W3 /WX- /EHsc /MT /I vendor helper.cpp
IF errorlevel 1 exit /b 1
cl.exe /D NDEBUG /c /W3 /WX- /EHsc /MT extra\win.cpp
IF errorlevel 1 exit /b 1

link.exe /OUT:"clipboard-history-helper.exe" helper.obj win.obj helper.res user32.lib /SUBSYSTEM:CONSOLE /MACHINE:X64 /DEBUG:NONE
IF errorlevel 1 exit /b 1

rem 7z when available, otherwise the Windows tar (bsdtar) writes zip archives with -a
where 7z >nul 2>&1
IF %errorlevel%==0 (
  7z a -tzip windows.zip clipboard-history-helper.exe .\installer\win\install.bat .\installer\win\uninstall.bat
) ELSE (
  tar.exe -a -c -f windows.zip clipboard-history-helper.exe installer\win\install.bat installer\win\uninstall.bat
)
