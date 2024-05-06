@echo off
setlocal enabledelayedexpansion
REM
IF /I "%USERNAME%" == "User1" call :configMouse
REM
goto :eof


:configMouse
REM
echo [INFO] configMouse
REG ADD "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "4" /f
REM
goto :eof
