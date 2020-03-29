@echo off
setlocal enabledelayedexpansion
SET SCRIPT_PATH=%~dps0
cd /d "%SCRIPT_PATH%"
cls
title Syncthing - Remove
REM
REM Script Configuration.
SET LOGFILE="%TEMP%\%~n0.log"
REM 
call :removeSyncthing
REM 
REM End of Script.
goto :eof


:removeSyncthing
REM 
REM Syntax:
REM 	call :removeSyncthing
REM 
call :logAdd "[INFO] removeSyncthing ..."
REM 
SET SYNCTHING_TITLE=Syncthing
REM 
REM Configure Windows Firewall
call :logAdd "[INFO] removeSyncthing: Firewall - Deleting previously created rules ..."
netsh advfirewall firewall delete rule name="%SYNCTHING_TITLE%" dir="in"
REM 
REM Delete log file on success.
DEL /F "%LOGFILE%" 2> NUL:
REM 
goto :eof


:logAdd
REM Syntax:
REM		logAdd [TEXT]
SET LOG_TEXT=%1
SET LOG_TEXT=%LOG_TEXT:"=%
SET LOG_DATETIMESTAMP=%DATE:~-4%-%DATE:~-7,-5%-%DATE:~-10,-8%_%time:~-11,2%:%time:~-8,2%:%time:~-5,2%
SET LOG_DATETIMESTAMP=%LOG_DATETIMESTAMP: =0%
echo %LOG_DATETIMESTAMP%: %LOG_TEXT%
echo %LOG_DATETIMESTAMP%: %LOG_TEXT% >> "%LOGFILE%"
goto :eof
