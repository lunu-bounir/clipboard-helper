Clipboard History Manager - Windows helper
==========================================

What this is
------------
This helper is the native part of the Clipboard History Manager browser
extension (https://github.com/lunu-bounir/clipboard-helper). It is not a
standalone app: the Windows browser extensions connect to it to
read the system clipboard on demand.

Getting started
---------------
1. Double-click "install.bat" (or run it from a command line).
2. Reload the browser (Google Chrome, Edge, Brave, Firefox, Waterfox,
   Thunderbird).

The installer copies the helper to:

    %LocalAPPData%\desktop.clipboard.manager\

and registers it for the current user through HKCU registry keys. No
administrator rights are involved.

Security dialogs you may see
----------------------------
The helper is not code-signed, so Windows SmartScreen or your antivirus
may show "unrecognized app" style warnings (clipboard reading helpers match
patterns used by clipboard-stealing malware, which is why unsigned ones
draw attention). Choose "More info" then "Run anyway". False-positive
reports are sent per release to the antivirus vendors to keep pulls down.

Privacy
-------
The helper runs only while a browser that registered it is connected and
exits as soon as the browser closes the connection. It reads the clipboard
only when the extension asks it to, usually right after something was
copied. Nothing starts automatically at boot.

Uninstall
---------
Double-click "uninstall.bat" in the same folder.
