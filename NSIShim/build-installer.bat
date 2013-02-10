@echo off

rem "********** Get the version **********"
set /P version=Installer version: 
if /i "%version%" == "" goto :help

if not exist releases mkdir releases

rem "********** Include vs vars if not already included ***********"
if not "%INCLUDED_VSVARS%" == "" goto :skipvsvars
call "%VS100COMNTOOLS%vsvars32.bat"
set INCLUDED_VSVARS=1
:skipvsvars

rem "********** Build the application and installer **********"
msbuild.exe /ToolsVersion:4.0 "nsishim.sln" /p:configuration=Release
tools\nsis-2.46\makensis.exe /NOCD /V2 /Dversion=%version% MyCoolAppInstaller.nsi

rem "********** Append release info **********"
set installerFile=mycoolapp-%version%.exe
for /F "tokens=*" %%i in ('src\calcmd5\bin\Debug\calcmd5.exe "releases\mycoolapp-%version%.exe"') do set md5hash=%%i
for %%j in (releases\mycoolapp-%version%.exe) do @set installerSize=%%~zj
echo %md5hash% %installerFile% %installerSize% >> releases\RELEASES
goto :done


:help
	echo Make sure to include the version!

:done

