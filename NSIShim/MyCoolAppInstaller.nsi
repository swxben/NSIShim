; NSIS script for the MyCoolApp installer

RequestExecutionLevel user

!include "FileFunc.nsh"

; The name of the installer
Name "MyCoolApp"

; The file to write
OutFile "mycoolapp-${version}.exe"

; Version info
; VIProductVersion needs to be x.x.x.x so it may have to be fixed to eg 1.0.0.0 for versioning systems that can't be adapted
VIProductVersion ${version}.0
VIAddVersionKey ProductName "MyCoolApp"
VIAddVersionKey Comments "MyCoolApp installer"
VIAddVersionKey CompanyName "Software by Ben Pty Ltd"
VIAddVersionKey LegalCopyright "CC BY-SA 3.0"
VIAddVersionKey FileDescription "MyCoolApp NSIShim example, by SWXBEN"

VIAddVersionKey FileVersion ${version}
VIAddVersionKey ProductVersion ${version}

VIAddVersionKey InternalName "MyCoolApp NSIShim example"
VIAddVersionKey LegalTrademarks "CC BY-SA 3.0"
VIAddVersionKey OriginalFilename "mycoolapp-${version}.exe"

; The default installation directory
InstallDir "$APPDATA\swxben\MyCoolApp\${version}"

;--------------------------------

; Pages

Page instfiles

;--------------------------------

; Install the files and create shortcuts
Section ""

  ; Copy the files
  SetOutPath "$INSTDIR"
  File "src\MyCoolApp\bin\Release\MyCoolApp.exe"

  ; Write shortcut
  ;SetOutPath "$APPDATA\swxben\MyCoolApp"
  CreateShortcut "$APPDATA\swxben\MyCoolApp\MyCoolApp.lnk" "$INSTDIR\MyCoolApp.exe"

  CreateShortcut "$SMPROGRAMS\swxben\MyCoolApp\MyCoolApp.lnk" "$APPDATA\swxben\MyCoolApp\MyCoolApp.lnk"
  CreateShortcut "$DESKTOP\MyCoolApp.lnk" "$APPDATA\swxben\MyCoolApp\MyCoolApp.lnk"

  ; See if should restart on exit
  ${GetParameters} $R0
  ${GetOptions} $R0 "/S" $R1
  IfErrors abortinstall
  Exec "$APPDATA\swxben\MyCoolApp\MyCoolApp.lnk"
  
  abortinstall:
SectionEnd ; end the section