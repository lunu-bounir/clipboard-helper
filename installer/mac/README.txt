Clipboard History Manager - macOS helper
========================================

What this is
------------
This helper is the native part of the Clipboard History Manager browser
extension (https://github.com/lunu-bounir/clipboard-helper). It is not a
standalone app: the macOS browser extensions connect to it to read
the system clipboard on demand.

Getting started
---------------
1. Run the installer next to this file (in Terminal, from this folder):

       bash install.sh

2. Reload the browser.

The installer copies the helper to:

    ~/.config/desktop.clipboard.manager/

and registers it with Google Chrome, Chromium, Vivaldi, Brave, Edge,
Firefox, Waterfox, Tor Browser and Thunderbird.

Security dialogs you may see
----------------------------
The helper is not signed with a Developer ID certificate, so macOS may
report "helper cannot be opened because the developer cannot be verified"
if the quarantine flag is re-applied by other software on your machine. If
this happens, right-click on the "helper" executable and choose "Open"
once, then confirm. This whitelists the executable for the future.

Privacy
-------
The helper runs only while a browser that registered it is connected and
exits as soon as the browser closes the connection. It reads the clipboard
only when the extension asks it to, usually right after something was
copied. Nothing starts automatically at boot and nothing gets installed
system-wide.

Uninstall
---------
    bash uninstall.sh
