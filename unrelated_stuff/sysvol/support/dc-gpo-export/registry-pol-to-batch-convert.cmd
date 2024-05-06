@echo off
setlocal enabledelayedexpansion
REM
SET "SCRIPT_PATH=%~dps0"
CD /D "%SCRIPT_PATH%"
REM
SET GPO_GUID={31B2F340-016D-11D2-945F-00C04FB984F9}
SET GPO_TYPE=Machine
SET GPO_REGISTRY_POL=\\%USERDNSDOMAIN%\sysvol\%USERDNSDOMAIN%\Policies\%GPO_GUID%\%GPO_TYPE%\Registry.pol
REM
copy /y %GPO_REGISTRY_POL% "X:\Registry.pol"
python registry-pol-to-batch-convert.py
DEL /F /Q "X:\Registry.pol" 2>NUL:
REM
pause
REM
goto :eof
