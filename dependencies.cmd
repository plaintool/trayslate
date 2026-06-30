@echo off
setlocal

:: Use LAZARUS_DIR and LAZBUILD from the calling script
if not defined LAZARUS_DIR (
    echo ERROR: LAZARUS_DIR is not set. Run the main build script first.
    pause
    exit /b 1
)
if not defined LAZBUILD (
    echo ERROR: LAZBUILD is not set. Run the main build script first.
    pause
    exit /b 1
)
if not exist "%LAZBUILD%" (
    echo ERROR: lazbuild.exe not found at "%LAZBUILD%"
    pause
    exit /b 1
)

:start_deps

:: Dependency settings
set "SYNAPSE_REPO=https://github.com/plainlib/synapse.git"
set "SYNAPSE_PATH=libs\synapse"
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
echo Processing Lazarus package
if exist "%SYNAPSE_LPK%" (
    echo Building laz_synapse.lpk
    "%LAZBUILD%" "%SYNAPSE_LPK%" -q -q
    if errorlevel 1 (
        echo ERROR: Synapse LPK build failed
        pause
        exit /b %errorlevel%
    )
    echo Synapse LPK processed successfully
) else (
    echo WARNING: laz_synapse.lpk not found, skipping
)

echo Dependencies OK
exit /b 0