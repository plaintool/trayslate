@echo off
setlocal

::Build 32-bit Lazarus project "trayslate" using lazbuild
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

::Path to 32-bit FPC compiler
SET "FPC32=%FPC32_PATH%"
if not exist "%FPC32%" (
    for /d %%F in ("%LAZARUS_DIR%\fpc\*") do (
        if exist "%%~F\bin\i386-win32\fpc.exe" (
            SET "FPC32=%%~F\bin\i386-win32\fpc.exe"
        )
    )
)
if not exist "%FPC32%" (
    echo 32-bit FPC compiler not found. Set FPC32_PATH.
    exit /b 1
)

::Rename existing 64-bit exe to trayslate64.exe to avoid overwriting
if exist "trayslate.exe" (
    echo Renaming existing 64-bit executable...
    ren "trayslate.exe" "trayslate64.exe"
)

echo Building 32-bit project: %PROJECT_PATH%
"%LAZBUILD%" %PROJECT_PATH% --cpu=i386 --ws=win32 --build-mode=%BUILD_MODE% --compiler=%FPC32%

IF %ERRORLEVEL% NEQ 0 (
    echo 32-bit build failed!
    ::Restore 64-bit exe back
    if exist "trayslate64.exe" ren "trayslate64.exe" "trayslate.exe"
    exit /b %ERRORLEVEL%
)

::Rename output to trayslate32.exe to distinguish from 64-bit
if exist "trayslate.exe" (
    echo Renaming 32-bit executable...
    if exist "trayslate32.exe" del /F /Q "trayslate32.exe"
    ren "trayslate.exe" "trayslate32.exe"
)

::Restore 64-bit exe back to original name
if exist "trayslate64.exe" (
    echo Restoring 64-bit executable name...
    if exist "trayslate.exe" del /F /Q "trayslate.exe"
    ren "trayslate64.exe" "trayslate.exe"
)

echo 32-bit build completed successfully

:: Copy 32-bit OpenSSL DLLs to output folder
copy /Y "%~dp0installer\redist\libcrypto-1_1.dll" "%~dp0"
copy /Y "%~dp0installer\redist\libssl-1_1.dll" "%~dp0"

::Wait 2 seconds to ensure file is free
timeout /t 2 /nobreak >nul

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
SET "TIMESTAMP_URL=http://timestamp.digicert.com"

::Sign the 32-bit executable
if exist "trayslate32.exe" (
    if not "%CERTFILE%"=="" (
        if exist "%CERTFILE%" (
            if exist "%SIGNTOOL%" (
                echo Signing 32-bit executable...
                "%SIGNTOOL%" sign /f "%CERTFILE%" /p "%CERTPASS%" /fd SHA256 /tr %TIMESTAMP_URL% /td SHA256 "trayslate32.exe"
                IF %ERRORLEVEL% EQU 0 (
                    echo Signing completed successfully
                ) else (
                    echo Signing failed
                )
                echo Signing 32-bit libssl-1_1.dll...
                "%SIGNTOOL%" sign /f "%CERTFILE%" /p "%CERTPASS%" /fd SHA256 /tr %TIMESTAMP_URL% /td SHA256 "libssl-1_1.dll"
                IF %ERRORLEVEL% EQU 0 (
                    echo Signing completed successfully
                ) else (
                    echo Signing failed
                )
                echo Signing 32-bit libcrypto-1_1.dll...
                "%SIGNTOOL%" sign /f "%CERTFILE%" /p "%CERTPASS%" /fd SHA256 /tr %TIMESTAMP_URL% /td SHA256 "libcrypto-1_1.dll"
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
