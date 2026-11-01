Clipboard History Manager - Linux helper
========================================

What this is
------------
This helper is the native part of the Clipboard History Manager browser
extension (https://github.com/lunu-bounir/clipboard-helper). It is not a
standalone app: the Linux browser extensions connect to it to read
the system clipboard on demand.

Getting started
---------------
1. Run the installer next to this file (in a terminal, from this folder):

       bash install.sh

2. Reload the browser.

The installer copies the helper to:

    ~/.config/desktop.clipboard.manager/

and registers it with Google Chrome, Chromium, Vivaldi, Brave, Edge,
Firefox, Waterfox, Thunderbird and the Tor Browser bundle (only for the
browsers it finds on disk).

Desktop notes
-------------
The helper reads clipboard changes through the X clipboard (X11). Under
X11 and XWayland sessions this covers everything. Under native Wayland
(GNOME/Mutter, KWin/KDE) clipboard content of graphical applications
reaches the helper through the compositor's X11 clipboard bridge; how
well that bridge works differs per desktop environment.

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
