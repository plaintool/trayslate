@echo off
cd /d %~dp0..

git subtree push --prefix=libs/toolkit https://github.com/plainlib/toolkit.git main

if %errorlevel% neq 0 (
    echo ERROR: Subtree push failed
    pause
    exit /b %errorlevel%
)

echo Pushed.
pause