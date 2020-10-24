#!/bin/bash

wget https://github.com/nlohmann/json/releases/download/v3.9.1/json.hpp

g++ helper.mm extra/osx.mm \
  -stdlib=libc++ \
  -std=gnu++11 \
  -fobjc-arc \
  -framework AppKit \
  -o helper

zip  -j -9 mac.zip helper installer/mac/install.sh installer/mac/uninstall.sh
