@echo off
setlocal EnableDelayedExpansion

echo.
echo ############################################################
echo                  Build InnoSetup installer                  
echo ############################################################
echo.

:: Define paths
SET "SOURCE_DIR=%~dp0"
SET "VERSION=%VERSION%"
IF "%~2" NEQ "" (
    SET "VERSION=%~2"
)
IF "%VERSION%"=="" (
    FOR /F "usebackq delims=" %%i IN ("%SOURCE_DIR%..\VERSION") DO SET "VERSION=%%i"
)

:: --- Download Inno Setup language files (local build only) ---
if not defined CI (
    set "destination=C:\Program Files (x86)\Inno Setup 6\Languages"

    if not exist "!destination!\Belarusian.isl" curl -fLsS -o "!destination!\Belarusian.isl" "https://raw.githubusercontent.com/jrsoftware/issrc/refs/heads/main/Files/Languages/Unofficial/Belarusian.isl"
    if not exist "!destination!\ChineseSimplified.isl" curl -fLsS -o "!destination!\ChineseSimplified.isl" "https://raw.githubusercontent.com/jrsoftware/issrc/refs/heads/main/Files/Languages/ChineseSimplified.isl"
    if not exist "!destination!\Greek.isl" curl -fLsS -o "!destination!\Greek.isl" "https://raw.githubusercontent.com/jrsoftware/issrc/refs/heads/main/Files/Languages/Unofficial/Greek.isl"
    if not exist "!destination!\Hindi.islu" curl -fLsS -o "!destination!\Hindi.islu" "https://raw.githubusercontent.com/jrsoftware/issrc/refs/heads/main/Files/Languages/Unofficial/Hindi.islu"
    if not exist "!destination!\Indonesian.isl" curl -fLsS -o "!destination!\Indonesian.isl" "https://raw.githubusercontent.com/jrsoftware/issrc/refs/heads/main/Files/Languages/Unofficial/Indonesian.isl"
    if not exist "!destination!\Romanian.isl" curl -fLsS -o "!destination!\Romanian.isl" "https://raw.githubusercontent.com/jrsoftware/issrc/refs/heads/main/Files/Languages/Unofficial/Romanian.isl"

    if errorlevel 1 (
        echo Failed to download Inno Setup language files
        exit /b 1
    )
)

:: --- Build inno setup ---
"C:\Program Files (x86)\Inno Setup 6\ISCC.exe" /DMyVersion=%VERSION% "%SOURCE_DIR%\innosetup.iss"
echo File created: trayslate-any-x86-x64.exe
echo.

echo.
echo ############################################################
echo                  Sign InnoSetup installer                   
echo ############################################################
echo.

::Wait 2 seconds to ensure file is free
ping 127.0.0.1 -n 3 >nul

:: --- Sign installers ---
IF "%SIGNTOOL%"=="" (
    SET "SIGNTOOL=C:\Program Files (x86)\Windows Kits\10\bin\10.0.26100.0\x64\signtool.exe"
)
IF "%CERTFILE%"=="" (
    IF EXIST "%SOURCE_DIR%AlexanderT.pfx" (
        SET "CERTFILE=%SOURCE_DIR%AlexanderT.pfx"
    ) ELSE (
        IF NOT "%CERT_PFX%"=="" (
            SET "CERTFILE=%TEMP%\trayslate-cert.pfx"
            powershell -NoProfile -Command "[IO.File]::WriteAllBytes('%TEMP%\\trayslate-cert.pfx',[Convert]::FromBase64String($env:CERT_PFX))"
        ) ELSE (
            SET "CERTFILE="
        )
    )
)
SET "CERTPASS=1234"
::SET "TIMESTAMP_URL=http://timestamp.digicert.com"
SET "TIMESTAMP_URL=http://timestamp.sectigo.com"
::SET "TIMESTAMP_URL=http://ts.ssl.com"

if not "%CERTFILE%"=="" (
    if exist "%CERTFILE%" (
        if exist "%SIGNTOOL%" (
            echo Signing file...
            "%SIGNTOOL%" sign /f "%CERTFILE%" /p "%CERTPASS%" /fd SHA256 /tr %TIMESTAMP_URL% /td SHA256 "%SOURCE_DIR%\trayslate-%VERSION%-any-x86-x64.exe" < nul
            IF %ERRORLEVEL% EQU 0 (
                echo Signing of trayslate-%VERSION%-any-x86-x64.exe completed successfully
            ) else (
                echo Signing failed for trayslate-%VERSION%-any-x86-x64.exe
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

endlocal
echo Build and signing trayslate-%VERSION%-any-x86-x64.exe completed successfully!