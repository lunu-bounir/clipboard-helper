# Release checklist / antivirus false-positive handling

The helper binaries watch the clipboard by design, which is a behavior profile
that antivirus products heuristically associate with "clipbanker" malware.
Unsigned helpers therefore get flagged even though nothing here is malicious.
There is no way around this other than identifying the binaries properly and
reporting false positives. Making the helper harder for security software to
see (obfuscation, stealth tricks) is explicitly *not* on the table.

## Per-release checklist

1. Build with GitHub Actions (push a tag `v*`).
2. Download the artifacts (`mac.zip`, `windows.zip`, `linux.zip`) from the draft release.
3. Collect SHA-256 hashes: `shasum -a 256 *.zip` (or `certutil -hashfile windows.zip SHA256`).
4. Submit false-positive reports for **each new build**:
   - Microsoft Defender: <https://www.microsoft.com/en-us/wdsi/filesubmission>
     (choose "Software developer", paste the hash, note that this is the native
     messaging helper of the published Clipboard History Manager extension).
   - Avast / AVG: <https://www.avast.com/false-positive-file-form>
   - ESET: <https://www.eset.com/us/contact/log-parser/>
   - Bitdefender: <https://www.bitdefender.ca/support/contact/ticket-report-false-register/nhl_enCA_url_sam/>
   - Kaspersky: <https://opentip.kaspersky.com/forum/false-positive>
   - Malwarebytes: <https://forums.malwarebytes.com/forum/112-false-positives/>
5. Publish the checksums in the release notes.

## Reducing the heuristic surface (already applied)

- Windows helper ships with full `VERSIONINFO` version metadata and a
  descriptive name (`clipboard-history-helper.exe`) instead of a generic
  `helper.exe`.
- Reproducible build with vendored dependencies (`vendor/json.hpp`), no network
  access at build time.
- The helper runs only while a browser that explicitly lists our extension IDs
  has connected to it, and exits whenever the browser closes the pipe.
- Windows clipboard reads happen through the standard `CF_UNICODETEXT`
  clipboard API; macOS through `NSPasteboard`; Linux through the standard X11
  selection protocol. No smashing of windows, no global hooks, no persistence.

## The long-term fix: code signing

Unsigned binaries remain the weakest link: reputation resets on every rebuild.
The standard, cheap fixes:

- **Windows**: Certum sells an "Open Source Code Signing" certificate for
  roughly €25/year, specifically for open-source maintainers. It removes
  SmartScreen warnings and dramatically reduces false positives.
- **macOS**: Apple Developer Program (US$99/year) → Developer ID signing +
  notarization removes Gatekeeper entirely. Until then, `install.sh` clears the
  `com.apple.quarantine` attribute (like Homebrew casks do).
