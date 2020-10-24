call "C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\Common7\Tools\VsDevCmd.bat"

git clone --branch "v1.2" https://github.com/dacap/clip

cd clip
cmake -DCMAKE_C_FLAGS:STRING="-MV -D NDEBUG" -DCMAKE_CXX_FLAGS:STRING="-MT -D NDEBUG" -DCMAKE_BUILD_TYPE=Release .





  cmake -D "CMAKE_C_FLAGS_DEBUG_INIT=/D_DEBUG /MTd /Zi /Ob0 /Od /RTC1"\
        -D "CMAKE_C_FLAGS_MINSIZEREL_INIT=/MT /O1 /Ob1 /D NDEBUG"\
        -D "CMAKE_C_FLAGS_RELEASE_INIT=/MT /O2 /Ob2 /D NDEBUG"\
        -D "CMAKE_C_FLAGS_RELWITHDEBINFO_INIT=/MT /Zi /O2 /Ob1 /D NDEBUG"\
        -D "CMAKE_CXX_FLAGS_DEBUG_INIT=/D_DEBUG /MTd /Zi /Ob0 /Od /RTC1"\
        -D "CMAKE_CXX_FLAGS_MINSIZEREL_INIT=/MT /O1 /Ob1 /D NDEBUG"\
        -D "CMAKE_CXX_FLAGS_RELEASE_INIT=/MT /O2 /Ob2 /D NDEBUG"\
        -D "CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT=/MT /Zi /O2 /Ob1 /D NDEBUG" --build . --target clip --config Release
cd ..

wget https://github.com/nlohmann/json/releases/download/v3.9.1/json.hpp

copy helper.mm helper.cpp
cl.exe /D NDEBUG /c /W3 /WX- /EHsc /MT helper.cpp
cl.exe /D NDEBUG /c /W3 /WX- /EHsc /MT extra/win.cpp

link.exe /OUT:"helper.exe" .\clip\Release\clip.lib user32.lib gdi32.lib /SUBSYSTEM:CONSOLE /DEBUG:NONE /machine:X86 win.obj helper.obj

7z a -tzip windows.zip helper.exe .\installer\win\install.bat .\installer\win\uninstall.bat
