#!/usr/bin/env bash

cd "$(dirname "$0")"

FILE=helper
ID=desktop.clipboard.manager

echo ".. Copy $FILE to $HOME/.config/desktop.clipboard.manager/"
mkdir -p $HOME/.config/desktop.clipboard.manager/
cp $FILE $HOME/.config/desktop.clipboard.manager/

cat > $ID.json <<- EOM
{
  "name": "$ID",
  "description": "native part of the Desktop Clipboard Manager extension",
  "path": "$HOME/.config/$ID/$FILE",
  "type": "stdio",
  "allowed_origins": [
    "chrome-extension://fkjpmllcngkflcffmimkfbjaikkmglfd/"
  ]
}
EOM

echo ".. Copy Google Chrome manifest to $HOME/Library/Application Support/Google/Chrome/NativeMessagingHosts"
cp $ID.json "$HOME/Library/Application Support/Google/Chrome/NativeMessagingHosts/"

echo ".. Copy Chromium manifest to $HOME/Library/Application Support/Chromium/NativeMessagingHosts"
cp $ID.json "$HOME/Library/Application Support/Chromium/NativeMessagingHosts/"

echo ".. Copy Vivaldi manifest to $HOME/Library/Application Support/Vivaldi/NativeMessagingHosts"
cp $ID.json "$HOME/Library/Application Support/Vivaldi/NativeMessagingHosts/"

echo ".. Copy Mozilla Firefox manifest to $HOME/Library/Application Support/Mozilla/NativeMessagingHosts"
cp $ID.json "$HOME/Library/Application Support/Mozilla/NativeMessagingHosts/"

echo ".. Clean-up"
rm $ID.json

echo ".. Done!"
read -p "Press enter to continue"
