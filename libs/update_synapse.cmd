@echo off
cd /d %~dp0..

git subtree pull --prefix=libs/synapse https://github.com/plainlib/synapse.git master --squash

if %errorlevel% neq 0 (
    echo ERROR: Subtree pull failed
    pause
    exit /b %errorlevel%
)

echo Updated.
pause