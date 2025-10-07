@echo off
setlocal

rem Define paths
set "SOURCE_DIR=E:\trayslator\installer"
set "VERSION=1.0.0"

rem --- Build peruser ---
echo Compiling msisetup_peruser.wxs with candle...
candle -nologo "%SOURCE_DIR%\msisetup_peruser.wxs" -out "%SOURCE_DIR%\peruser.wixobj" -ext WixUIExtension >nul
echo Linking peruser.wixobj into trayslator-%VERSION%.msi with light...
light -nologo "%SOURCE_DIR%\peruser.wixobj" -out "%SOURCE_DIR%\trayslator-%VERSION%.msi" -ext WixUIExtension >nul
echo File created: trayslator-%VERSION%.msi
echo.

rem --- Build permachine ---
echo Compiling msisetup_permachine.wxs with candle...
candle -nologo "%SOURCE_DIR%\msisetup_permachine.wxs" -out "%SOURCE_DIR%\permachine.wixobj" -ext WixUIExtension >nul
echo Linking permachine.wixobj into trayslator-%VERSION%-allusers.msi with light...
light -nologo "%SOURCE_DIR%\permachine.wixobj" -out "%SOURCE_DIR%\trayslator-%VERSION%-allusers.msi" -ext WixUIExtension >nul
echo File created: trayslator-%VERSION%-allusers.msi
echo.

rem --- Clean temporary files ---
echo Deleting temporary .wixobj and .wixpdb files...
del /q "%SOURCE_DIR%\*.wixobj" >nul
del /q "%SOURCE_DIR%\*.wixpdb" >nul
echo Cleanup completed.
echo.

echo Build completed!
