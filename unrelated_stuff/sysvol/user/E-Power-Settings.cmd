@echo off
setlocal enabledelayedexpansion
REM
REG ADD "HKCU\Software\Policies\Microsoft\Windows\System\Power" /v "PromptPasswordOnResume" /t REG_DWORD /d "1" /f
REM
goto :eof
