#!/bin/bash

git clone https://github.com/dacap/clip
pushd clip
cmake .
make
popd
wget https://github.com/nlohmann/json/releases/download/v3.5.0/json.hpp -c

g++ helper.mm wait_osx.mm ./clip/libclip.a \
  -stdlib=libc++ \
  -std=gnu++11 \
  -fobjc-arc \
  -framework AppKit \
  -I ./clip \
  -o helper

zip  -j -9 mac.zip helper installer/mac/install.sh installer/mac/uninstall.sh
