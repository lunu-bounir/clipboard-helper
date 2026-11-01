#!/usr/bin/env bash

cd "$(dirname "$0")"

FILE=helper
ID=desktop.clipboard.manager

DEST="$HOME/.config/$ID"

echo ".. Copy $FILE to $DEST/"
mkdir -p "$DEST"
cp "$FILE" "$DEST/"
chmod +x "$DEST/$FILE"

cat > $ID.json <<- EOM
{
  "name": "$ID",
  "description": "native part of the Clipboard History Manager extension",
  "path": "$DEST/$FILE",
  "type": "stdio",
  "allowed_origins": [
    "chrome-extension://dcpgnicohhclhnjfchhbjaonpnedimig/",
    "chrome-extension://pkigjgihlaonoomgjgannieikjecdhil/",
    "chrome-extension://empcclfpdmhckpdfpgljnbbkcakfnbho/"
  ]
}
EOM

# The shell script below is regenerated as manifest-firefox.json with allowed_extensions
cat > manifest-firefox.json <<- EOM
{
  "name": "$ID",
  "description": "native part of the Clipboard History Manager extension",
  "path": "$DEST/$FILE",
  "type": "stdio",
  "allowed_extensions": ["{82b3a366-18e0-4400-aa21-36a966d0a42e}"]
}
EOM

install_chrome_manifest () {  # for Chromium-based browsers
  local target="$1"
  if [ -d "$target" ]; then
    echo ".. Copy manifest to $target"
    cp $ID.json "$target/"
  fi
}

install_firefox_manifest () {  # for Firefox-based browsers (allowed_extensions in use)
  local target="$1"
  if [ -d "$target" ]; then
    echo ".. Copy manifest to $target"
    cp manifest-firefox.json "$target/$ID.json"
  fi
}

# Chromium-based browsers
install_chrome_manifest "$HOME/.config/google-chrome/NativeMessagingHosts"
install_chrome_manifest "$HOME/.config/chromium/NativeMessagingHosts"
install_chrome_manifest "$HOME/.config/BraveSoftware/Brave-Browser/NativeMessagingHosts"
install_chrome_manifest "$HOME/.config/vivaldi/NativeMessagingHosts"
install_chrome_manifest "$HOME/.config/microsoft-edge/NativeMessagingHosts"

# Firefox-based browsers and Thunderbird
install_firefox_manifest "$HOME/.mozilla/native-messaging-hosts"
install_firefox_manifest "$HOME/.waterfox/native-messaging-hosts"
install_firefox_manifest "$HOME/.thunderbird/native-messaging-hosts"

# The Tor Browser bundle (bundled Firefox lives inside the extracted bundle)
for target in "$HOME"/tor-browser*/Browser/TorBrowser/Data/Browser/Mozilla/NativeMessagingHosts; do
  if [ -d "$target" ]; then
    echo ".. Copy manifest to $target"
    cp manifest-firefox.json "$target/$ID.json"
  fi
done

rm -f $ID.json manifest-firefox.json

echo
echo ".. Done!"
echo
echo "Notes:"
echo "  - The helper runs only when the Clipboard History Manager extension connects to it."
echo "  - On X11 and XWayland, the helper receives clipboard changes through the X clipboard."
echo "  - On GNOME/KDE Wayland, clipboard content of native Wayland apps reaches the helper"
echo "    through the compositor's X11 clipboard bridge; some compositors bridge better"
echo "    than others."
echo "  - Firefox, Waterfox, and Thunderbird users: if the manifest directory listed above"
echo "    differs on your system, copy $ID.json there manually."
