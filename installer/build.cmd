@echo off
setlocal

:: Define paths
SET "SOURCE_DIR=%~dp0"
SET "VERSION=%VERSION%"
IF "%~2" NEQ "" (
    SET "VERSION=%~2"
)
IF "%VERSION%"=="" (
    FOR /F "usebackq delims=" %%i IN ("%SOURCE_DIR%..\VERSION") DO SET "VERSION=%%i"
)

:: Check if platform parameter is provided
IF "%1"=="" (
    SET "PLATFORM=x64"
) ELSE (
    SET "PLATFORM=%1"
)

:: Validate platform parameter
IF NOT "%PLATFORM%"=="x64" IF NOT "%PLATFORM%"=="x86" (
    echo Error: Invalid platform parameter. Use x64 or x86.
    echo Example: %0 x64
    echo Example: %0 x86
    exit /b 1
)

:: --- Build peruser ---
echo Compiling msisetup_peruser.wxs with candle for %PLATFORM%...
candle -nologo "%SOURCE_DIR%\msisetup_peruser.wxs" -out "%SOURCE_DIR%\peruser.wixobj" -ext WixUIExtension -dPlatform=%PLATFORM% -dVersion=%VERSION%
echo Linking peruser.wixobj into trayslator-%VERSION%-%PLATFORM%.msi with light...
light -nologo "%SOURCE_DIR%\peruser.wixobj" -out "%SOURCE_DIR%\trayslator-%VERSION%-%PLATFORM%.msi" -ext WixUIExtension
echo File created: trayslator-%VERSION%-%PLATFORM%.msi
echo.

:: --- Build permachine ---
echo Compiling msisetup_permachine.wxs with candle for %PLATFORM%...
candle -nologo "%SOURCE_DIR%\msisetup_permachine.wxs" -out "%SOURCE_DIR%\permachine.wixobj" -ext WixUIExtension -dPlatform=%PLATFORM% -dVersion=%VERSION%
echo Linking permachine.wixobj into trayslator-%VERSION%-%PLATFORM%-allusers.msi with light...
light -nologo "%SOURCE_DIR%\permachine.wixobj" -out "%SOURCE_DIR%\trayslator-%VERSION%-%PLATFORM%-allusers.msi" -ext WixUIExtension
echo File created: trayslator-%VERSION%-%PLATFORM%-allusers.msi
echo.

:: --- Clean temporary files ---
echo Deleting temporary .wixobj and .wixpdb files...
del /q "%SOURCE_DIR%\*.wixobj" >nul
del /q "%SOURCE_DIR%\*.wixpdb" >nul
echo Cleanup completed.
echo.

:: --- Sign installers ---
IF "%SIGNTOOL%"=="" (
    SET "SIGNTOOL=C:\Program Files (x86)\Windows Kits\10\bin\10.0.26100.0\x64\signtool.exe"
)
IF "%CERTFILE%"=="" (
    IF EXIST "%SOURCE_DIR%AlexanderT.pfx" (
        SET "CERTFILE=%SOURCE_DIR%AlexanderT.pfx"
    ) ELSE (
        IF NOT "%CERT_PFX%"=="" (
            SET "CERTFILE=%TEMP%\trayslator-cert.pfx"
            powershell -NoProfile -Command "[IO.File]::WriteAllBytes('%TEMP%\\trayslator-cert.pfx',[Convert]::FromBase64String($env:CERT_PFX))"
        ) ELSE (
            SET "CERTFILE="
        )
    )
)
SET "CERTPASS=1234"
SET "TIMESTAMP_URL=http://timestamp.digicert.com"

if not "%CERTFILE%"=="" (
    if exist "%CERTFILE%" (
        if exist "%SIGNTOOL%" (
            echo Signing MSI files...
            "%SIGNTOOL%" sign /f "%CERTFILE%" /p "%CERTPASS%" /fd SHA256 /tr %TIMESTAMP_URL% /td SHA256 "%SOURCE_DIR%\trayslator-%VERSION%-%PLATFORM%.msi"
            IF %ERRORLEVEL% EQU 0 (
                echo Signing of trayslator-%VERSION%-%PLATFORM%.msi completed successfully
            ) else (
                echo Signing failed for trayslator-%VERSION%-%PLATFORM%.msi
            )

            "%SIGNTOOL%" sign /f "%CERTFILE%" /p "%CERTPASS%" /fd SHA256 /tr %TIMESTAMP_URL% /td SHA256 "%SOURCE_DIR%\trayslator-%VERSION%-%PLATFORM%-allusers.msi"
            IF %ERRORLEVEL% EQU 0 (
                echo Signing of trayslator-%VERSION%-%PLATFORM%-allusers.msi completed successfully
            ) else (
                echo Signing failed for trayslator-%VERSION%-%PLATFORM%-allusers.msi
            )
        ) else (
            echo Skipping signing: signtool not found.
        )
    ) else (
        echo Skipping signing: cert file not found.
    )
) else (
    echo Skipping signing: CERTFILE not set.
)

:: --- Portable ---
if "%BUILD_PORTABLE%"=="1" (
    powershell -NoProfile -Command "$exe64='%~dp0..\\trayslator.exe'; $exe32='%~dp0..\\trayslator32.exe'; $settings='%~dp0form_settings.json'; $license='%~dp0LICENSE.rtf'; $config='%~dp0..\\config\\google.ini'; $dll1='%~dp0..\\libcrypto-1_1-x64.dll'; $dll2='%~dp0..\\libssl-1_1-x64.dll'; $dll3='%~dp0..\\libcrypto-1_1.dll'; $dll4='%~dp0..\\libssl-1_1.dll'; if ((Test-Path $exe64) -and (Test-Path $exe32) -and (Test-Path $settings) -and (Test-Path $license) -and (Test-Path $config) -and (Test-Path $dll1) -and (Test-Path $dll2) -and (Test-Path $dll3) -and (Test-Path $dll4)) { Compress-Archive -Force -Path $exe64,$exe32,$settings,$license,$config,$dll1,$dll2,$dll3,$dll4 -DestinationPath '%~dp0trayslator-%VERSION%-x86-x64-portable.zip' } else { Write-Error 'Portable inputs missing'; exit 1 }"
)

echo Build and signing completed successfully!