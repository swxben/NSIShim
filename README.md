NSIShim
=======

A specification for side-by-side (shim) installs and upgrades, and a reference implementation using NSIS for the installer and C# for the app/client. Based loosely on [Shimmer](https://github.com/github/Shimmer).


## Specification

Hmm. I think the specification could be called xShim, with the NSIS/C# reference implementation called NSIShim. TIME TO TAKE OVER THE WURLD.


### Application

The entire application including all dependencies should be included in the application. For example, a .NET application would be compiled to `project\bin\Release\....` which is bundled up in the install script. Dependencies that can't be included with the install script (eg the .NET framework) should be bootstrapped by the installer script. In other words, this specification does not build in any support for managing application dependencies.


### Installer / bootstrap

> `%APPDATA%` (cmd.exe) or `$env:APPDATA` (PowerShell) refers to the user's `AppData\Roaming` folder, for example `C:\Users\Ben\AppData\Roaming`.

The installer is a standalone executable file (for example an executable generated from an NSIS script) that:

1. Install the entire application to `%APPDATA%\application_id\version` (optionally to `%APPDATA%\author\application_id\version`)
2. Create or overwrite a shortcut to the application executable (`%APPDATA%\application_id\version\application.exe`) to `%APPDATA%\application_id\application.lnk`.
	- For example: `%APPDATA%\MyCoolApp\1.0.0\MyCoolApp.exe`, `%APPDATA%\MyCoolApp\MyCoolApp.lnk`
	- if the application includes multiple user entry points (eg. a POS terminal and a financial controller terminal for the same system) then multiple shortcuts could be created at `%APPDATA%\application_id\`
	- this spec doesn't specify what the shortcuts are called, how many are created, nesting of paths up to the `application_id`, etc. This is totally up to the installer.
3. Optionally create entries in the Start menu or Startup menu linking to the entry points created at `%APPDATA%\application_id\*.lnk`

This allows side-by-side installation of an new version of an application while an older version of the same application is still running.


#### Shared files

Each full installer must not rely on the existence of a previous version of the application - it should create a full production environment. That said, there could be files that have to be migrated from version to version, such as SQLite databases or configuration files. If it is appropriate to store these files with the application (rather than in user-specified locations) they can be stored in a `SHARED` folder at `%APPDATA%\application_id\SHARED`. Migration for these files should be done in the installation script or by the application on opening the file. The migration process is not covered by this specification. The `SHARED` folder should be created by the installation script if it does not exist, i.e. the xShim implementation is not responsible for creating or maintaining the `SHARED` folder, but any other folders created within `%APPDATA%\application_id` (eg `%APPDATA%\Configuration\...`) may be broken by future changes to the xShim specification.


### Release layout (file share or URL)

This could be hosted on a file share within a network or via a public or private URL. The application will have a link to the file share. The link is optionally configurable, but ideally the implementation should be able to transparently use local file paths (`C:\dev\app\`), UNC paths (`\\file-server\it\app\`) or URLs (`http://server/app/`).

A file named `RELEASES` must be present at the release path. This file contains the name of each installer in release order - oldest at top, newest at bottom, along with the SHA1 hashes of their contents and their file sizes. Example:

	94689fede03fed7ab59c24337673a27837f0c3ec  MyCoolApp-1.0.0.exe  1004502
	3a2eadd15dd984e4559f2b4d790ec8badaeb6a39  MyCoolApp-1.1.0.exe  1040561

The version is extracted from the installer file name using the convention `ApplicationId-{version}.ext`. No further analysis is done on the version at this point as there is an assumption that the newest version is at the bottom. This is unlikely to change as semantic versioning will be supported by putting pre-release versions in multiple `RELEASE` files for alternate release channels.

### Application features / in-process endpoints

#### Check for updates

An update check could be triggered by any of the following conditions:

- A one-off check when the application is started
- A check initiated by the user
- A poll check, for example every 15 minutes

The updater implementation should provide support for any of these conditions by way of exposing a `CheckForUpdates` method and a `StartPollForUpdatesEvery(TimeSpan)` method (or similar). Polling can be disabled by a `StopPollForUpdates` method - this could be used if the application goes offline or upgrade polling is disabled by the user.

The `CheckForUpdates` method should return true if there are updates that can be applied. It should also cache the metadata for available updates at the time of the check.

**TODO** when setting up poll should be able to flag auto shim installs, on either `CheckForUpdates` or `StartPoll`.

#### Get available updates

**TODO** iterate cached updates

#### Apply available updates

**TODO** shim install each update - maybe just latest update?? how would this work with diffs?


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


### Release notes

I don't want to mess around with embedding release notes in the EXE or using NuGet or anything else. Probably the easiest way would be to use a naming convention to link release notes to a release. So for `MyCoolApp-1.0.0.exe` it could look for `MyCoolApp-1.0.0.txt` or `MyCoolApp-1.0.0.md`.