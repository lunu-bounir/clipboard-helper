#!/bin/bash

git clone --branch "v1.2" https://github.com/dacap/clip
pushd clip
cmake .
cmake --build . --target clip --config Release
popd
wget https://github.com/nlohmann/json/releases/download/v3.9.1/json.hpp -c

g++ helper.mm extra/osx.mm ./clip/libclip.a \
  -stdlib=libc++ \
  -std=gnu++11 \
  -fobjc-arc \
  -framework AppKit \
  -I ./clip \
  -o helper

zip  -j -9 mac.zip helper installer/mac/install.sh installer/mac/uninstall.sh
