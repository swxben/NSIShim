NSIShim xShim reference implementation
======================================

# NSIS script notes

- Silent mode
	- if the installer is called with `/S` on the command line
- Pass values in to the script by calling `makensis /Dversion=1.2.3` then in the script `OutFile installer-${version}.exe`
