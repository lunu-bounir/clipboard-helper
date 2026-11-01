#!/usr/bin/env bash

FILE=helper
ID=desktop.clipboard.manager

remove_chrome_manifest () {
  if [ -f "$1/$ID.json" ]; then
    rm -f "$1/$ID.json"
  fi
}

echo " .. Removing manifest file for Google Chrome"
remove_chrome_manifest "$HOME/.config/google-chrome/NativeMessagingHosts"
echo " .. Removing manifest file for Chromium"
remove_chrome_manifest "$HOME/.config/chromium/NativeMessagingHosts"
echo " .. Removing manifest file for Vivaldi"
remove_chrome_manifest "$HOME/.config/vivaldi/NativeMessagingHosts"
echo " .. Removing manifest file for Brave"
remove_chrome_manifest "$HOME/.config/BraveSoftware/Brave-Browser/NativeMessagingHosts"
echo " .. Removing manifest file for Edge"
remove_chrome_manifest "$HOME/.config/microsoft-edge/NativeMessagingHosts"

echo " .. Removing manifest file for Mozilla Firefox"
remove_chrome_manifest "$HOME/.mozilla/native-messaging-hosts"
echo " .. Removing manifest file for Waterfox"
remove_chrome_manifest "$HOME/.waterfox/native-messaging-hosts"
echo " .. Removing manifest file for Thunderbird"
remove_chrome_manifest "$HOME/.thunderbird/native-messaging-hosts"

for target in "$HOME"/tor-browser*/Browser/TorBrowser/Data/Browser/Mozilla/NativeMessagingHosts; do
  if [ -f "$target/$ID.json" ]; then
    echo " .. Removing manifest file for Tor Browser"
    rm -f "$target/$ID.json"
  fi
done

echo " .. Removing executables"
rm -rf "$HOME/.config/$ID"

echo " .. Native Client is removed"
