@echo off
setlocal

:: Resolve script directory
SET "SOURCE_DIR=%~dp0"
SET "VERSION=%~1"

:: If no version passed, try to read from ..\VERSION
IF "%VERSION%"=="" (
    IF EXIST "%SOURCE_DIR%..\VERSION" (
        FOR /F "usebackq delims=" %%i IN ("%SOURCE_DIR%..\VERSION") DO SET "VERSION=%%i"
    )
)

:: Still no version? Error out
IF "%VERSION%"=="" (
    echo ERROR: Version not specified. Pass as argument or place a VERSION file in the parent directory.
    exit /b 1
)

echo.
echo ############################################################
echo                   Build Portable %VERSION%                    
echo ############################################################
echo.

    powershell -NoProfile -Command ^
    "$tmp='%~dp0temp_dist';" ^
    "$exe64='%~dp0..\\trayslate.exe';" ^
    "$exe32='%~dp0..\\trayslate32.exe';" ^
    "$settings='%~dp0portable';" ^
    "$license='%~dp0\\LICENSE.rtf';" ^
    "$thirdparties='%~dp0..\\THIRD_PARTIES';" ^
    "$dlls=@('%~dp0..\\libcrypto-3-x64.dll','%~dp0..\\libssl-3-x64.dll','%~dp0..\\libcrypto-1_1.dll','%~dp0..\\libssl-1_1.dll');" ^
    "$configDir='%~dp0..\\config';" ^
    "$destZip='%~dp0trayslate-%VERSION%-x86-x64-portable.zip';" ^
    "if ((Test-Path $exe64) -and (Test-Path $exe32) -and (Test-Path $configDir)) {" ^
    "  if (Test-Path $tmp) { Remove-Item -Recurse -Force $tmp };" ^
    "  New-Item -ItemType Directory -Path \"$tmp/config\" -Force | Out-Null;" ^
    "  Copy-Item $exe64, $exe32, $settings, $license, $thirdparties -Destination $tmp;" ^
    "  Copy-Item $dlls -Destination $tmp;" ^
    "  Copy-Item \"$configDir\\*.ini\" -Destination \"$tmp/config\";" ^
    "  Start-Sleep -Seconds 2;" ^
    "  Compress-Archive -Force -Path \"$tmp\\*\" -DestinationPath $destZip;" ^
    "  Remove-Item -Recurse -Force $tmp;" ^
    "} else { Write-Error 'Portable inputs missing'; exit 1 }"

endlocal