@echo off
setlocal enabledelayedexpansion
REM
SETX TMP "%%USERPROFILE%%\AppData\Local\Temp"
SETX TEMP "%%USERPROFILE%%\AppData\Local\Temp"
REM
goto :eof
