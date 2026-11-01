#!/bin/bash
set -e -o pipefail
cd "$(dirname "$0")"

# json.hpp is vendored in the "vendor" directory (no network access needed at build time)
cp helper.mm helper.cpp

# stale binary would mask a failed build below
rm -f helper

g++ helper.cpp extra/linux.cpp \
  -std=gnu++11 \
  -lX11 -lXfixes \
  -I vendor \
  -o helper

if [ ! -f helper ]; then
  echo "compilation did not produce 'helper'" >&2
  exit 1
fi

zip -j -9 linux.zip helper installer/linux/install.sh installer/linux/uninstall.sh installer/linux/README.txt
