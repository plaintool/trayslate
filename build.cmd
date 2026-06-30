@echo off
setlocal

:: Skip kill in CI environments
TASKLIST | FINDSTR /I "trayslate.exe" >NUL
IF ERRORLEVEL 1 GOTO :start.build
:: Kill App if running (local only)
ECHO Closing process 'trayslate.exe'
taskkill /F /IM trayslate.exe >NUL

:start.build
::Build Lazarus project "trayslate" using lazbuild
SET "PROJECT_PATH=trayslate.lpi"
SET "BUILD_MODE=Release"

SET "LAZARUS_DIR=%LAZARUS_DIR%"
for %%D in ("%LAZARUS_DIR%" "C:\Lazarus" "C:\lazarus") do (
    if exist "%%~D\lazbuild.exe" (
        SET "LAZARUS_DIR=%%~D"
    )
)

if not exist "%LAZARUS_DIR%\lazbuild.exe" (
    echo Lazarus not found. Set LAZARUS_DIR or install Lazarus.
    exit /b 1
)

SET "LAZBUILD=%LAZARUS_DIR%\lazbuild.exe"

:: Updating and building dependencies
call "%~dp0dependencies.cmd"
if %ERRORLEVEL% neq 0 (
    echo Dependency build failed!
    exit /b %ERRORLEVEL%
)

echo Building project: %PROJECT_PATH%
"%LAZBUILD%" %PROJECT_PATH% --build-mode=%BUILD_MODE%

IF %ERRORLEVEL% NEQ 0 (
    echo Build failed!
    exit /b %ERRORLEVEL%
)

echo Build completed successfully

:: Copy 64-bit OpenSSL DLLs to output folder
copy /y "%~dp0installer\redist\libcrypto-1_1-x64.dll" "%~dp0" >NUL
copy /Y "%~dp0installer\redist\libssl-1_1-x64.dll"    "%~dp0" >NUL

echo Wait 2 seconds to ensure file is free
ping 127.0.0.1 -n 3 >nul

::Certificate settings (optional)
IF "%SIGNTOOL%"=="" (
    SET "SIGNTOOL=C:\Program Files (x86)\Windows Kits\10\bin\10.0.26100.0\x64\signtool.exe"
)
IF "%CERTFILE%"=="" (
    IF EXIST "%~dp0installer\AlexanderT.pfx" (
        SET "CERTFILE=%~dp0installer\AlexanderT.pfx"
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

::Sign the executable in the same folder
if exist "trayslate.exe" (
    if not "%CERTFILE%"=="" (
        if exist "%CERTFILE%" (
            if exist "%SIGNTOOL%" (
                echo Signing executable...
                "%SIGNTOOL%" sign /f "%CERTFILE%" /p "%CERTPASS%" /fd SHA256 /tr %TIMESTAMP_URL% /td SHA256 "trayslate.exe" < nul
                IF %ERRORLEVEL% EQU 0 (
                    echo Signing completed successfully
                ) else (
                    echo Signing failed
                )
                echo Signing libssl-1_1-x64.dll...
                "%SIGNTOOL%" sign /f "%CERTFILE%" /p "%CERTPASS%" /fd SHA256 /tr %TIMESTAMP_URL% /td SHA256 "libssl-1_1-x64.dll" < nul
                IF %ERRORLEVEL% EQU 0 (
                    echo Signing completed successfully
                ) else (
                    echo Signing failed
                )
                echo Signing libcrypto-1_1-x64.dll...
                "%SIGNTOOL%" sign /f "%CERTFILE%" /p "%CERTPASS%" /fd SHA256 /tr %TIMESTAMP_URL% /td SHA256 "libcrypto-1_1-x64.dll" < nul
                IF %ERRORLEVEL% EQU 0 (
                    echo Signing completed successfully
                ) else (
                    echo Signing failed
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
) else (
    echo Skipping signing: missing executable.
)
