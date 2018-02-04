@setlocal
@echo off

chcp 65001

set MSYS2_PATH_TYPE=inherit

rem Set the environment variable
set MSYS2_BIN="E:\Tools\msys64\usr\bin\bash.exe"

set WindowsSDKversion=10.0.10240.0

set VSInstallerFolder="%ProgramFiles(x86)%\Microsoft Visual Studio\Installer"
if %PROCESSOR_ARCHITECTURE%==x86 set VSInstallerFolder="%ProgramFiles%\Microsoft Visual Studio\Installer"

pushd %VSInstallerFolder%
for /f "usebackq tokens=*" %%i in (`vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
  set VS2017InstallDir=%%i
)
popd

rd /s /q "%~dp0Output/FFmpeg"
rd /s /q "%~dp0Output/FFmpeg_Temp"
rd /s /q "%~dp0FFmpegUniversal/FFmpeg"

echo Building FFmpeg for Windows 10 apps x86...
echo:

setlocal
call "%VS2017InstallDir%\VC\Auxiliary\Build\vcvarsall.bat" x86 uwp %WindowsSDKversion%
%MSYS2_BIN% --login -x %~dp0FFmpegConfig.sh Static Win32
%MSYS2_BIN% --login -x %~dp0FFmpegConfig.sh Shared Win32
call "%~dp0FFmpegCopy.bat" Win32
endlocal

echo Building FFmpeg for Windows 10 apps x64...
echo:

setlocal
call "%VS2017InstallDir%\VC\Auxiliary\Build\vcvarsall.bat" x86_amd64 uwp %WindowsSDKversion%
%MSYS2_BIN% --login -x %~dp0FFmpegConfig.sh Static x64
%MSYS2_BIN% --login -x %~dp0FFmpegConfig.sh Shared x64
call "%~dp0FFmpegCopy.bat" x64
endlocal

echo Building FFmpeg for Windows 10 apps ARM...
echo:

setlocal
call "%VS2017InstallDir%\VC\Auxiliary\Build\vcvarsall.bat" x86_arm uwp %WindowsSDKversion%
%MSYS2_BIN% --login -x %~dp0FFmpegConfig.sh Static ARM
%MSYS2_BIN% --login -x %~dp0FFmpegConfig.sh Shared ARM
call "%~dp0FFmpegCopy.bat" ARM
endlocal

goto Cleanup

echo Building FFmpeg for Windows 10 apps ARM64...
echo:

setlocal
call "%VS2017InstallDir%\VC\Auxiliary\Build\vcvarsall.bat" x86_arm64 uwp %WindowsSDKversion%
%MSYS2_BIN% --login -x %~dp0FFmpegConfig.sh Static ARM64
%MSYS2_BIN% --login -x %~dp0FFmpegConfig.sh Shared ARM64
call "%~dp0FFmpegCopy.bat" ARM64
endlocal

:Cleanup

@endlocal