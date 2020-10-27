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
  "description": "native part of the Clipboard History Manager extension",
  "path": "$HOME/.config/$ID/$FILE",
  "type": "stdio",
  "allowed_origins": [
    "chrome-extension://dcpgnicohhclhnjfchhbjaonpnedimig/",
    "chrome-extension://pkigjgihlaonoomgjgannieikjecdhil/",
    "chrome-extension://empcclfpdmhckpdfpgljnbbkcakfnbho/"
  ]
}
EOM

echo ".. Copy Google Chrome manifest to $HOME/Library/Application Support/Google/Chrome/NativeMessagingHosts"
mkdir -p "$HOME/Library/Application Support/Google/Chrome/NativeMessagingHosts/"
cp $ID.json "$HOME/Library/Application Support/Google/Chrome/NativeMessagingHosts/"

echo ".. Copy Chromium manifest to $HOME/Library/Application Support/Chromium/NativeMessagingHosts"
mkdir -p "$HOME/Library/Application Support/Chromium/NativeMessagingHosts/"
cp $ID.json "$HOME/Library/Application Support/Chromium/NativeMessagingHosts/"

echo ".. Copy Vivaldi manifest to $HOME/Library/Application Support/Vivaldi/NativeMessagingHosts"
mkdir -p "$HOME/Library/Application Support/Vivaldi/NativeMessagingHosts/"
cp $ID.json "$HOME/Library/Application Support/Vivaldi/NativeMessagingHosts/"

echo ".. Copy BraveSoftware manifest to $HOME/Library/Application Support/BraveSoftware/Brave-Browser/NativeMessagingHosts"
mkdir -p "$HOME/Library/Application Support/BraveSoftware/Brave-Browser/NativeMessagingHosts/"
cp $ID.json "$HOME/Library/Application Support/BraveSoftware/Brave-Browser/NativeMessagingHosts/"

echo ".. Copy Edge manifest to $HOME/Library/Application Support/Microsoft Edge/NativeMessagingHosts"
mkdir -p "$HOME/Library/Application Support/Microsoft Edge/NativeMessagingHosts/"
cp $ID.json "$HOME/Library/Application Support/Microsoft Edge/NativeMessagingHosts/"

echo ".. Copy Mozilla Firefox manifest to $HOME/Library/Application Support/Mozilla/NativeMessagingHosts"
mkdir -p "$HOME/Library/Application Support/Mozilla/NativeMessagingHosts/"
cat > "$HOME/Library/Application Support/Mozilla/NativeMessagingHosts/$ID.json" <<- EOM
{
  "name": "$ID",
  "description": "native part of the Clipboard History Manager extension",
  "path": "$HOME/.config/$ID/$FILE",
  "type": "stdio",
  "allowed_extensions": ["{82b3a366-18e0-4400-aa21-36a966d0a42e}"]
}
EOM

echo ".. Copy Waterfox manifest to $HOME/Library/Application Support/Waterfox/NativeMessagingHosts"
mkdir -p "$HOME/Library/Application Support/Waterfox/NativeMessagingHosts/"
cat > "$HOME/Library/Application Support/Waterfox/NativeMessagingHosts/$ID.json" <<- EOM
{
  "name": "$ID",
  "description": "native part of the Clipboard History Manager extension",
  "path": "$HOME/.config/$ID/$FILE",
  "type": "stdio",
  "allowed_extensions": ["{82b3a366-18e0-4400-aa21-36a966d0a42e}"]
}
EOM

echo ".. Copy TorBrowser manifest to $HOME/Library/Application Support/TorBrowser-Data/Browser/Mozilla/NativeMessagingHosts"
mkdir -p "$HOME/Library/Application Support/TorBrowser-Data/Browser/Mozilla/NativeMessagingHosts/"
cat > "$HOME/Library/Application Support/TorBrowser-Data/Browser/Mozilla/NativeMessagingHosts/$ID.json" <<- EOM
{
  "name": "$ID",
  "description": "native part of the Clipboard History Manager extension",
  "path": "$HOME/.config/$ID/$FILE",
  "type": "stdio",
  "allowed_extensions": ["{82b3a366-18e0-4400-aa21-36a966d0a42e}"]
}
EOM

echo ".. Copy Thunderbird manifest to $HOME/Library/Application Support/Thunderbird/NativeMessagingHosts"
mkdir -p "$HOME/Library/Application Support/Thunderbird/NativeMessagingHosts"
cat > "$HOME/Library/Application Support/Thunderbird/NativeMessagingHosts/$ID.json" <<- EOM
{
  "name": "$ID",
  "description": "native part of the Clipboard History Manager extension",
  "path": "$HOME/.config/$ID/$FILE",
  "type": "stdio",
  "allowed_extensions": ["{82b3a366-18e0-4400-aa21-36a966d0a42e}"]
}
EOM

echo ".. Clean-up"
rm $ID.json

printf "\033[0;31mIMPORTANT\033[0m\n"
printf "\033[0;34mFor the extension to use this helper, right-click on the helper executable, and press the \"Open\" context menu item once for your operating system to whitelist this executable.\033[0m\n"
read -p "Press enter to open directory"
open ~/.config/desktop.clipboard.manager

read -p ".. Done!"
