@echo off
setlocal enabledelayedexpansion
SET SCRIPT_PATH=%~dps0
REM 
DEL /F "%SCRIPT_PATH%SourceDir\*.txt" 2> NUL:
DEL /F "%SCRIPT_PATH%SourceDir\syncthing.exe" 2> NUL:
REM 
goto :eof
