@echo off
setlocal enabledelayedexpansion
SET SCRIPT_PATH=%~dps0
REM 
RD /S /Q "%SCRIPT_PATH%nssm-2.24-101-g897c7ad" 2> NUL:
RD /S /Q "%SCRIPT_PATH%syncthing-windows-amd64-v1.8.0" 2> NUL:
RD /S /Q "%SCRIPT_PATH%wix" 2> NUL:
REM 
DEL /F "%SCRIPT_PATH%Syncthing\syncthing.exe" 2> NUL:
DEL /F "%SCRIPT_PATH%Syncthing\*.txt" 2> NUL:
DEL /F "%SCRIPT_PATH%*.msi" 2> NUL:
DEL /F "%SCRIPT_PATH%*.zip" 2> NUL:
REM 
goto :eof
