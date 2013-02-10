@echo off

if /i "%1" == "" goto :help

call "%VS100COMNTOOLS%vsvars32.bat"
msbuild.exe /ToolsVersion:4.0 "nsishim.sln" /p:configuration=Release
tools\nsis-2.46\makensis.exe /NOCD /V2 /Dversion=%1 MyCoolAppInstaller.nsi
echo MD5:
src\calcmd5\bin\Debug\calcmd5.exe "mycoolapp-%1.exe"

goto :done


:help
	echo Make sure to include the version!

:done

