@echo off
cd /d %~dp0..

git subtree pull --prefix=libs/toolkit https://github.com/plainlib/toolkit.git main --squash

if %errorlevel% neq 0 (
    echo ERROR: Subtree pull failed
    pause
    exit /b %errorlevel%
)

echo Updated.
pause