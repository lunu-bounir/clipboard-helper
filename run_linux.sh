#!/bin/bash
cd "$(dirname "$0")"

# json.hpp is vendored in the "vendor" directory (no network access needed at build time)
cp helper.mm helper.cpp

g++ helper.cpp extra/linux.cpp \
  -std=gnu++11 \
  -lX11 -lXfixes \
  -I vendor \
  -o helper

zip -j -9 linux.zip helper installer/linux/install.sh installer/linux/uninstall.sh
