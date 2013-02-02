NSIShim
=======

A specification for side-by-side (shim) installs and upgrades, and a reference implementation using NSIS for the installer and C# for the app/client. Based loosely on [Shimmer](https://github.com/github/Shimmer).


## Specification


### Application

The entire application including all dependencies should be included in the application. Specifically for a .NET application the entire application should be compiled to `project\bin\Release\..`. Dependencies that can't be included with the application (eg the .NET framework) should be bootstrapped by the installer script.


### Installer / bootstrap

> `%APPDATA%` (cmd.exe) or `$env:APPDATA` (PowerShell) refers to the user's `AppData\Roaming` folder, for example `C:\Users\Ben\AppData\Roaming`.

The installer is a standalone executable file (for example an executable generated from an NSIS script) that:

1. Install the entire application to `%APPDATA%\application_id\version` (optionally to `%APPDATA%\author\application_id\version`)
2. Create or overwrite a shortcut to the application executable (`%APPDATA%\application_id\version\application.exe`) to `%APPDATA%\application_id\application.lnk`.
	- if the application includes multiple user entry points (eg. a POS terminal and a financial controller terminal for the same system) then multiple shortcuts could be created at `%APPDATA%\application_id\`
3. Optionally create entries in the Start menu or Startup menu linking to the entry points created at `%APPDATA%\application_id\*.lnk`

This allows side-by-side installation of an new version of an application while an older version of the same application is still running.


### Release layout (file share or URL)

TBA


### Application features / in-process endpoints

TBA


## Future improvements


### Diff installers

The current implementations of this specification will not include diff installers. This is a loose description of how diff installers could work for future reference. Each file included in the installer is compared to the last version to get a .diff file. The diff files are packaged in a diff installer. Each diff installer is then run sequentially from the installed version to the new version.