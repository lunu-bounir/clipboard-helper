#!/usr/bin/env bash

FILE=helper
ID=desktop.clipboard.manager

echo " .. Removing manifest file for Google Chrome"
rm -f $HOME/Library/Application\ Support/Google/Chrome/NativeMessagingHosts/$ID.json
echo " .. Removing manifest file for Chromium"
rm -f $HOME/Library/Application\ Support/Chromium/NativeMessagingHosts/$ID.json
echo " .. Removing manifest file for Vivaldi"
rm -f $HOME/Library/Application\ Support/Vivaldi/NativeMessagingHosts/$ID.json
echo " .. Removing manifest file for BraveSoftware"
rm -f $HOME/Library/Application\ Support/BraveSoftware/Brave-Browser/NativeMessagingHosts/$ID.json
echo " .. Removing manifest file for Edge"
rm -f $HOME/Library/Application\ Support/Microsoft\ Edge/NativeMessagingHosts/$ID.json
echo " .. Removing manifest file for Mozilla Firefox"
rm -f $HOME/Library/Application\ Support/Mozilla/NativeMessagingHosts/$ID.json
echo " .. Removing manifest file for Waterfox"
rm -f $HOME/Library/Application\ Support/Waterfox/NativeMessagingHosts/$ID.json
echo " .. Removing manifest file for TorBrowser"
rm -f $HOME/Library/Application\ Support/TorBrowser-Data/Browser/Mozilla/NativeMessagingHosts/$ID.json
echo " .. Removing manifest file for Thunderbird"
rm -f $HOME/Library/Application\ Support/Thunderbird/NativeMessagingHosts/$ID.json

echo " .. Removing executables"
rm -f -r $HOME/.config/$ID/

echo " .. Native Client is removed"
read -p "Press enter to continue"
