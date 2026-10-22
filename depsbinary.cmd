@echo off
setlocal
set "OP_NAME=OpenSSL DLLs"

:: Arguments: %1 = architecture (32 or 64), %2 = application name (default trayslate)
set "ARCH=%~1"
set "APP_NAME=%~2"
if "%APP_NAME%"=="" set "APP_NAME=trayslate"

if "%ARCH%"=="" (
    echo [depsbinary.cmd] Architecture not specified. Use 32 or 64.
    exit /b 1
)

IF /I "%ARCH%"=="32" (SET "ARCH_LABEL=x86") ELSE (SET "ARCH_LABEL=x64")

:: Define suffix for file names based on architecture
IF "%ARCH%"=="32" (SET "SUFFIX=") ELSE (SET "SUFFIX=-x64")

echo.
echo ############################################################
echo          Copy and Sign %OP_NAME% for %ARCH_LABEL%
echo ############################################################
echo.

echo Wait 2 seconds to ensure files are free...
ping 127.0.0.1 -n 3 >nul

:: Build file names and copy
IF "%ARCH%"=="32" (SET "SSL_VER=1_1") ELSE (SET "SSL_VER=3")
SET "FILE_SSL=libssl-%SSL_VER%%SUFFIX%.dll"
SET "FILE_CRYPTO=libcrypto-%SSL_VER%%SUFFIX%.dll"

echo Copying %ARCH_LABEL% %OP_NAME%...
copy /Y "%~dp0libs\openssl\%FILE_SSL%"    "%~dp0" >NUL
copy /Y "%~dp0libs\openssl\%FILE_CRYPTO%" "%~dp0" >NUL

:: Certificate settings (same as main script, can be kept independent)
IF "%SIGNTOOL%"=="" (
    SET "SIGNTOOL=C:\Program Files (x86)\Windows Kits\10\bin\10.0.26100.0\x64\signtool.exe"
)
IF "%CERTFILE%"=="" (
    IF EXIST "%~dp0installer\AlexanderT.pfx" (
        SET "CERTFILE=%~dp0installer\AlexanderT.pfx"
    ) ELSE (
        IF NOT "%CERT_PFX%"=="" (
            SET "CERTFILE=%TEMP%\%APP_NAME%-cert.pfx"
            powershell -NoProfile -Command "[IO.File]::WriteAllBytes('%TEMP%\\%APP_NAME%-cert.pfx',[Convert]::FromBase64String($env:CERT_PFX))"
        ) ELSE (
            SET "CERTFILE="
        )
    )
)
SET "CERTPASS=1234"
SET "TIMESTAMP_URL=http://timestamp.sectigo.com"

set "SIGN_ERROR=0"

call :SignFile "%FILE_SSL%"
call :SignFile "%FILE_CRYPTO%"

if "%SIGN_ERROR%"=="1" (
    echo One or more signing operations failed.
    exit /b 1
)

echo %OP_NAME% processed successfully.
endlocal
exit /b 0

:SignFile
:: Subroutine to sign any file. Argument: %1 = file name
setlocal
set "TARGET_FILE=%~1"

if exist "%TARGET_FILE%" (
    if not "%CERTFILE%"=="" (
        if exist "%CERTFILE%" (
            if exist "%SIGNTOOL%" (
                echo Signing %TARGET_FILE%...
                "%SIGNTOOL%" sign /f "%CERTFILE%" /p "%CERTPASS%" /fd SHA256 /tr %TIMESTAMP_URL% /td SHA256 "%TARGET_FILE%" < nul
                IF %ERRORLEVEL% EQU 0 (
                    echo Signing %TARGET_FILE% succeeded
                ) else (
                    echo Signing %TARGET_FILE% failed
                    endlocal & set "SIGN_ERROR=1"
                    exit /b 1
                )
            ) else (
                echo signtool.exe not found, skipping file signing.
            )
        ) else (
            echo Certificate file not found, skipping file signing.
        )
    ) else (
        echo CERTFILE not set, skipping file signing.
    )
) else (
    echo Warning: %TARGET_FILE% not found, cannot sign.
    endlocal & set "SIGN_ERROR=1"
    exit /b 1
)
endlocal
exit /b 0