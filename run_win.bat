call "C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\Common7\Tools\VsDevCmd.bat"

git clone https://github.com/dacap/clip
cd clip
cmake .
msbuild.exe clip.sln
cd ..

wget https://github.com/nlohmann/json/releases/download/v3.5.0/json.hpp

cl.exe /c /Zi /nologo /W3 /WX- /diagnostics:classic /Od /Ob0 /Oy- /D WIN32 /D _WINDOWS /D _SCL_SECURE_NO_WARNINGS /D _MBCS /Gm- /EHsc /RTC1 /MDd /GS /fp:precise /Zc:wchar_t /Zc:forScope /Zc:inline /GR /Gd /TP /analyze- /errorReport:queue wait_win.cpp
cl.exe /c /Zi /nologo /W3 /WX- /diagnostics:classic /Od /Ob0 /Oy- /D WIN32 /D _WINDOWS /D _SCL_SECURE_NO_WARNINGS /D _MBCS /Gm- /EHsc /RTC1 /MDd /GS /fp:precise /Zc:wchar_t /Zc:forScope /Zc:inline /GR /Gd /TP /analyze- /errorReport:queue helper.mm

link.exe /ERRORREPORT:QUEUE /OUT:"helper.exe" /INCREMENTAL /NOLOGO .\clip\Debug\clip.lib kernel32.lib user32.lib gdi32.lib winspool.lib shell32.lib ole32.lib oleaut32.lib uuid.lib comdlg32.lib advapi32.lib /MANIFEST /MANIFESTUAC:"level='asInvoker' uiAccess='false'" /manifest:embed /SUBSYSTEM:CONSOLE /TLBID:1 /DYNAMICBASE /NXCOMPAT /MACHINE:X86 /SAFESEH /machine:X86 wait_win.obj helper.obj

zip windows.zip -9 helper.exe installer\win\install.bat installer\win\uninstall.bat
