@echo off
cd /d %~dp0..

git subtree pull --prefix=libs/darkmode https://github.com/plainlib/darkmode.git master --squash

if %errorlevel% neq 0 (
    echo ERROR: Subtree pull failed
    pause
    exit /b %errorlevel%
)

echo Updated.
pause