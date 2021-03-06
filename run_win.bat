call "C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\Common7\Tools\VsDevCmd.bat"

wget https://github.com/nlohmann/json/releases/download/v3.9.1/json.hpp

copy helper.mm helper.cpp
cl.exe /D NDEBUG /c /W3 /WX- /EHsc /MT helper.cpp
cl.exe /D NDEBUG /c /W3 /WX- /EHsc /MT extra/win.cpp

link.exe /OUT:"helper.exe" user32.lib gdi32.lib /SUBSYSTEM:CONSOLE /DEBUG:NONE /machine:X86 win.obj helper.obj

7z a -tzip windows.zip helper.exe .\installer\win\install.bat .\installer\win\uninstall.bat
