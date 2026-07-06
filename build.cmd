@echo off
setlocal

:: Determine build architecture: 64-bit by default, 32-bit if first argument is "32"
SET "ARCH=64"
IF /I "%1"=="32" SET "ARCH=32"

:: Label for console output
IF "%ARCH%"=="32" (SET "ARCH_LABEL=x86") ELSE (SET "ARCH_LABEL=x64")

:: Skip kill in CI environments
::IF "%ARCH%"=="32" GOTO :start.build
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
IF "%ARCH%"=="32" (
    call "%~dp0dependencies32.cmd"
) ELSE (
    call "%~dp0dependencies.cmd"
)
if %ERRORLEVEL% neq 0 (
    echo Dependency build failed!
    exit /b %ERRORLEVEL%
)

:: Set up 32-bit compiler path only when needed
IF "%ARCH%"=="32" SET "FPC32=%FPC32_PATH%"
IF "%ARCH%"=="32" if not exist "%FPC32%" (
    for /d %%F in ("%LAZARUS_DIR%\fpc\*") do (
        if exist "%%~F\bin\i386-win32\fpc.exe" (
            SET "FPC32=%%~F\bin\i386-win32\fpc.exe"
        )
    )
)
IF "%ARCH%"=="32" if not exist "%FPC32%" (
    echo 32-bit FPC compiler not found. Set FPC32_PATH.
    exit /b 1
)

echo.
echo ############################################################
echo                      Build %ARCH_LABEL%                   
echo ############################################################
echo.

:: 32-bit build needs to protect the existing 64-bit executable
IF "%ARCH%"=="32" (
    if exist "trayslate.exe" (
        echo Renaming existing 64-bit executable...
        ren "trayslate.exe" "trayslate64.exe"
    )
)

echo Building project: %PROJECT_PATH%
IF "%ARCH%"=="32" (
    "%LAZBUILD%" %PROJECT_PATH% --cpu=i386 --ws=win32 --build-mode=%BUILD_MODE% --compiler=%FPC32% -q
) ELSE (
    "%LAZBUILD%" %PROJECT_PATH% --build-mode=%BUILD_MODE% -q
)

IF %ERRORLEVEL% NEQ 0 (
    IF "%ARCH%"=="32" (
        echo 32-bit build failed!
        ::Restore 64-bit exe back
        if exist "trayslate64.exe" ren "trayslate64.exe" "trayslate.exe"
    ) ELSE (
        echo Build failed!
    )
    exit /b %ERRORLEVEL%
)

:: 32-bit post-build renaming
IF "%ARCH%"=="32" (
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
)

echo Build completed successfully

echo.
echo ############################################################
echo                        Signing %ARCH_LABEL%               
echo ############################################################
echo.

:: Copy OpenSSL DLLs (paths differ per architecture)
IF "%ARCH%"=="32" (
    copy /Y "%~dp0installer\redist\libcrypto-1_1.dll" "%~dp0"
    copy /Y "%~dp0installer\redist\libssl-1_1.dll" "%~dp0"
) ELSE (
    copy /y "%~dp0installer\redist\libcrypto-1_1-x64.dll" "%~dp0" >NUL
    copy /Y "%~dp0installer\redist\libssl-1_1-x64.dll"    "%~dp0" >NUL
)

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

:: Set architecture-specific file names for signing
IF "%ARCH%"=="32" (
    SET "EXE_NAME=trayslate32.exe"
    SET "DLL_SSL=libssl-1_1.dll"
    SET "DLL_CRYPTO=libcrypto-1_1.dll"
) ELSE (
    SET "EXE_NAME=trayslate.exe"
    SET "DLL_SSL=libssl-1_1-x64.dll"
    SET "DLL_CRYPTO=libcrypto-1_1-x64.dll"
)

::Sign the executable and DLLs in the same folder
if exist "%EXE_NAME%" (
    if not "%CERTFILE%"=="" (
        if exist "%CERTFILE%" (
            if exist "%SIGNTOOL%" (
                echo Signing executable...
                "%SIGNTOOL%" sign /f "%CERTFILE%" /p "%CERTPASS%" /fd SHA256 /tr %TIMESTAMP_URL% /td SHA256 "%EXE_NAME%" < nul
                IF %ERRORLEVEL% EQU 0 (
                    echo Signing completed successfully
                ) else (
                    echo Signing failed
                )
                echo Signing %DLL_SSL%...
                "%SIGNTOOL%" sign /f "%CERTFILE%" /p "%CERTPASS%" /fd SHA256 /tr %TIMESTAMP_URL% /td SHA256 "%DLL_SSL%" < nul
                IF %ERRORLEVEL% EQU 0 (
                    echo Signing completed successfully
                ) else (
                    echo Signing failed
                )
                echo Signing %DLL_CRYPTO%...
                "%SIGNTOOL%" sign /f "%CERTFILE%" /p "%CERTPASS%" /fd SHA256 /tr %TIMESTAMP_URL% /td SHA256 "%DLL_CRYPTO%" < nul
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