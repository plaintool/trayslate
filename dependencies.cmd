@echo off
setlocal

:: Determine build architecture: 64-bit by default, 32-bit if first argument is "32"
SET "ARCH=64"
IF /I "%1"=="32" SET "ARCH=32"

:: Label for console output
IF "%ARCH%"=="32" (SET "ARCH_LABEL=x86") ELSE (SET "ARCH_LABEL=x64")

:: Determine LAZARUS_DIR if not provided by caller
if not defined LAZARUS_DIR (
    for %%D in ("C:\Lazarus" "C:\lazarus") do (
        if exist "%%~D\lazbuild.exe" (
            set "LAZARUS_DIR=%%~D"
        )
    )
)

if not defined LAZARUS_DIR (
    echo ERROR: LAZARUS_DIR is not set and Lazarus was not found automatically.
    pause
    exit /b 1
)

if not defined LAZBUILD (
    set "LAZBUILD=%LAZARUS_DIR%\lazbuild.exe"
)

if not exist "%LAZBUILD%" (
    echo ERROR: lazbuild.exe not found at "%LAZBUILD%"
    pause
    exit /b 1
)

:: 32-bit specific: find FPC32 and set LAZBUILD_OPTS
IF "%ARCH%"=="32" (
    if not defined FPC32 (
        for /d %%F in ("%LAZARUS_DIR%\fpc\*") do (
            if exist "%%~F\bin\i386-win32\fpc.exe" (
                set "FPC32=%%~F\bin\i386-win32\fpc.exe"
            )
        )
    )
    if not defined FPC32 (
        echo ERROR: 32-bit FPC compiler not found. Set FPC32 or ensure i386-win32 target is installed.
        pause
        exit /b 1
    )
    set "LAZBUILD_OPTS=--cpu=i386 --ws=win32 --compiler="%FPC32%""
)

cd /d "%~dp0"

:: Build Synapse
call "%~dp0dependency.cmd" Synapse libs/synapse https://github.com/plainlib/synapse.git "%~dp0libs\synapse\laz_synapse.lpk" laz_synapse.pas
if errorlevel 1 exit /b %errorlevel%

:: Build DarkMode
call "%~dp0dependency.cmd" DarkMode libs/darkmode https://github.com/plainlib/darkmode.git "%~dp0libs\darkmode\darkmode.lpk"
if errorlevel 1 exit /b %errorlevel%

echo Dependencies OK
exit /b 0