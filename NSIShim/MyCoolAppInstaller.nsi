; NSIS script for the MyCoolApp installer

!include "FileFunc.nsh"

; The name of the installer
Name "MyCoolApp"

; The file to write
OutFile "mycoolapp-${version}.exe"

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