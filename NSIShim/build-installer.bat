@echo off
call "%VS100COMNTOOLS%vsvars32.bat"

msbuild.exe /ToolsVersion:4.0 "nsishim.sln" /p:configuration=Release

tools\nsis-2.46\makensis.exe /NOCD /V2 /Dversion=%1 MyCoolAppInstaller.nsi
