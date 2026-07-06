@echo off
cd /d %~dp0..

git subtree push --prefix=libs/synapse https://github.com/plainlib/synapse.git master

if %errorlevel% neq 0 (
    echo ERROR: Subtree push failed
    pause
    exit /b %errorlevel%
)

echo Pushed.
pause