# Code Review

Issues found and fixed during driver cleanup.

## Fixed Issues

### Firmware path buffer overflow
- File: `aicwf_compat_8800dc.c`
- Problem: Used `sprintf(buf, "%s/%s", buf, "aic8800DC")` - reads and writes same buffer
- Fix: Added guard to check before appending

### Missing NUL terminator
- File: `aicbluetooth.c`
- Problem: `get_fw_path()` used `memcpy()` without adding NUL terminator
- Fix: Used `strscpy()` with proper termination

### Install script Fedora path
- Files: `install_setup.sh`, `uninstall_setup.sh`
- Problem: Broken distro detection caused wrong privilege escalation
- Fix: Rewrote to use direct sudo/su fallback

### Makefile targets wrong in docs
- Problem: README said `modules_install` but Makefile has `install`
- Fix: Updated docs to match actual Makefile

### Prebuilt objects in repo
- Problem: `.o`, `.ko`, `.mod*` files committed to git
- Fix: Cleaned tree, removed from git

### 6.17 support broke 6.8
- Files: `rwnx_main.c`, `rwnx_rx.c`
- Problem: Added 6.17 API without version guards, broke 6.8 builds
- Fix: Added `#if LINUX_VERSION_CODE` guards for conditional compilation

### Invalid log level
- File: `aicwf_usb.c`
- Problem: Used `LOGWARN` which isn't defined
- Fix: Changed to defined log level

## Known Limitations

- Out-of-tree driver, not in mainline
- No in-kernel driver for these USB IDs
- Requires manual rebuild after kernel updates (or use DKMS)

## What This Review Doesn't Cover

This is a cleanup pass, not a full security audit. The driver comes from Tenda and hasn't been reviewed for security vulnerabilities beyond the obvious bugs above.