@echo off
cd /d %~dp0..

git subtree push --prefix=libs/helpers https://github.com/plainlib/helpers.git main

if %errorlevel% neq 0 (
    echo ERROR: Subtree push failed
    pause
    exit /b %errorlevel%
)

echo Pushed.
pause