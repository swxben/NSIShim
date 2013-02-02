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

This could be hosted on a file share within a network or via a public or private URL. The application will have a link to the file share. The link is optionally configurable, but ideally the implementation should be able to transparently use local file paths (`C:\dev\app\`), UNC paths (`\\file-server\it\app\`) or URLs (`http://server/app/`).

A file named `RELEASES` must be present at the release path. This file contains the name of each installer in release order - oldest at top, newest at bottom, along with the SHA1 hashes of their contents and their file sizes. Example:

	94689fede03fed7ab59c24337673a27837f0c3ec  MyCoolApp-1.0.0.exe  1004502
	3a2eadd15dd984e4559f2b4d790ec8badaeb6a39  MyCoolApp-1.1.0.exe  1040561


### Application features / in-process endpoints

TBA


## Future improvements


### Diff installers

The current implementations of this specification will not include diff installers. This is a loose description of how diff installers could work for future reference. Each file included in the installer is compared to the last version to get a .diff file. The diff files are packaged in a diff installer. Each diff installer is then run sequentially from the installed version to the new version.

It is expected that adding support for diff installers will not be a breaking change to this specification - the existing specification with full installers only should still 'work' after support for diff installers is added. I'm not sure how that would work.


### Semantic support for semantic versioning

The initial specification doesn't mention versioning - the release at the  bottom of the `RELEASES` file is treated as the latest release. Optional support should be added for semantic versioning - pre-release versions (eg 1.0.0-rc1) may not be installed automatically but could be opted in to either by a manual upgrade or changing update channels.

This could be implemented as a non-breaking change by having multiple `RELEASE` files:

- the existing `RELEASE` file contains normal versions only
- have a `RELEASE.rc` file to satisfy users on an RC channel
- have a `RELEASE.nightly` file hooked up to a CI server for users that want bleeding edge updates