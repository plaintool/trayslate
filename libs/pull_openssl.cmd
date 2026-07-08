@echo off
cd /d %~dp0..

git subtree pull --prefix=libs/openssl https://github.com/plainlib/openssl.git main --squash

if %errorlevel% neq 0 (
    echo ERROR: Subtree pull failed
    pause
    exit /b %errorlevel%
)

echo Updated.
pause