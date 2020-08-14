@echo off
cd /d "%~dps0%"
cls
REM 
SET STTRACE=fs main model scanner walk
REM 
rd /s /q "%localappdata%\syncthing\index-v0.14.0.db"
REM 
syncthing.exe
