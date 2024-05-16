@echo off
REM
REG ADD "HKLM\SOFTWARE\WinSuite" /v "ThreadManagerOn" /t REG_DWORD /d 1 /f
REM
goto :eof
