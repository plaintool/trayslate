@echo off
cd /d %~dp0..

git subtree pull --prefix=libs/helpers https://github.com/plainlib/helpers.git main --squash

if %errorlevel% neq 0 (
    echo ERROR: Subtree pull failed
    pause
    exit /b %errorlevel%
)

echo Updated.
pause