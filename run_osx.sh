#!/bin/bash
set -e -o pipefail
cd "$(dirname "$0")"

# stale binary would mask a failed build below
rm -f helper helper.dSYM

# Universal binary (arm64 + x86_64) so one build covers Apple Silicon and Intel
g++ helper.mm extra/osx.mm \
  -stdlib=libc++ \
  -std=gnu++11 \
  -arch arm64 -arch x86_64 \
  -fobjc-arc \
  -framework AppKit \
  -I vendor \
  -o helper

if [ ! -f helper ]; then
  echo "compilation did not produce 'helper'" >&2
  exit 1
fi

zip  -j -9 mac.zip helper installer/mac/install.sh installer/mac/uninstall.sh
