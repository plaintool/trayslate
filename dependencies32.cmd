@echo off
setlocal

:: Determine LAZARUS_DIR if not provided
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

:: Path to 32-bit FPC compiler (if not already set by caller)
if not defined FPC32 (
    for /d %%F in ("%LAZARUS_DIR%\fpc\*") do (
        if exist "%%~F\bin\i386-win32\fpc.exe" (
            set "FPC32=%%~F\bin\i386-win32\fpc.exe"
        )
    )
)
if not defined FPC32 (
    echo ERROR: 32-bit FPC compiler not found. Set FPC32_PATH or ensure i386-win32 target is installed.
    pause
    exit /b 1
)

:start_deps

echo.
echo ############################################################
echo #                 Build Synapse (32-bit)                   #
echo ############################################################
echo.

:: Dependency settings
set "SYNAPSE_REPO=https://github.com/plainlib/synapse.git"
set "SYNAPSE_PATH=libs/synapse"
set "SYNAPSE_LPK=%~dp0libs\synapse\laz_synapse.lpk"

echo Dependencies update started
cd /d "%~dp0"
echo Current directory: %CD%

echo Checking Synapse subtree state

:: Check for unstaged changes in the subtree
git diff --quiet -- %SYNAPSE_PATH%
if errorlevel 1 (
    echo WARNING: Synapse has unstaged changes, skipping subtree update
    goto skip_update
)

:: Check for staged changes in the subtree
git diff --cached --quiet -- %SYNAPSE_PATH%
if errorlevel 1 (
    echo WARNING: Synapse has staged changes, skipping subtree update
    goto skip_update
)

:: No local changes – safe to attempt pull
echo Updating Synapse subtree
git subtree pull --prefix=%SYNAPSE_PATH% %SYNAPSE_REPO% master --squash
if errorlevel 1 (
    echo WARNING: Synapse subtree update failed, continuing with existing code
) else (
    echo Synapse subtree updated successfully
)

goto process_lpk

:skip_update
echo Skipping Synapse subtree update due to local changes.

:process_lpk
echo Processing Lazarus package for 32-bit
if exist "%SYNAPSE_LPK%" (
    echo Building laz_synapse.lpk (32-bit)
    "%LAZBUILD%" "%SYNAPSE_LPK%" --cpu=i386 --ws=win32 --compiler="%FPC32%" -q -q
    if errorlevel 1 (
        echo ERROR: Synapse LPK 32-bit build failed
        pause
        exit /b %errorlevel%
    )
    echo Synapse LPK (32-bit) processed successfully

    :: Revert auto-generated changes in laz_synapse.pas to keep working tree clean
    if exist "%SYNAPSE_PATH%\laz_synapse.pas" (
        git checkout -- "%SYNAPSE_PATH%\laz_synapse.pas"
        if not errorlevel 1 (
            echo Reverted auto-changes in laz_synapse.pas
        )
    )
) else (
    echo WARNING: laz_synapse.lpk not found, skipping
)

echo Dependencies OK
exit /b 0