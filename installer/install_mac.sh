#!/usr/bin/env bash

cd "$(dirname "$0")"

FILE=helper_osx
VERSION=0.1.1
ID=desktop.clipboard.manager


URL=https://github.com/lunu-bounir/clipboard-helper/releases/download/$VERSION/$FILE

echo ".. Downloading $FILE from github releases"
echo "$URL"

wget -q URL $URL -O $FILE
chmod +x $FILE
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

echo ".. Supporting Chrome Browser"
echo $HOME/Library/Application Support/Google/Chrome/NativeMessagingHosts
cp $ID.json "$HOME/Library/Application Support/Google/Chrome/NativeMessagingHosts/"

echo ".. Supporting Chromium Browser"
echo $HOME/Library/Application Support/Chromium/NativeMessagingHosts
cp $ID.json "$HOME/Library/Application Support/Chromium/NativeMessagingHosts/"

echo ".. Supporting Vivaldi Browser"
echo $HOME/Library/Application Support/Vivaldi/NativeMessagingHosts
cp $ID.json "$HOME/Library/Application Support/Vivaldi/NativeMessagingHosts/"

echo ".. Supporting Vivaldi Browser"
echo $HOME/Library/Application Support/Mozilla/NativeMessagingHosts
cp $ID.json "$HOME/Library/Application Support/Mozilla/NativeMessagingHosts/"

echo ".. Clean-up"
rm $ID.json
rm $FILE

echo ".. Done!"
read -p "Press enter to continue"
