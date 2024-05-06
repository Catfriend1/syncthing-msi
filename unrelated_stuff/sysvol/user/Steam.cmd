@echo off
REM
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Steam" /f 2>&1 | find /i "erfolg"
REM
goto :eof
