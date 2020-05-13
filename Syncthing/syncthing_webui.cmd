@echo off
setlocal enabledelayedexpansion
SET SCRIPT_PATH=%~dps0
cd /d "%SCRIPT_PATH%"
cls
title Syncthing - Web UI
REM
REM Script Configuration.
SET LOGFILE="%TEMP%\%~n0.log"
REM 
REM Runtime Variables.
SET WEB_UI_PORT=8384
call :getWebUiPort
REM 
call :logAdd "[INFO] WEB_UI_PORT=[%WEB_UI_PORT%]"
start "Syncthing - Web UI" /D "%SystemRoot%" "http://localhost:%WEB_UI_PORT%"
REM 
goto :eof


:getWebUiPort
REM 
REM Syntax:
REM 	call :getWebUiPort
REM 
REM Global Variables.
REM 	[OUT] WEB_UI_PORT
REM 
REM We don't read config.xml as this requires to give the "Users" group access to the "AppData" directory containing secret device keys.
REM 	IF NOT EXIST %CONFIG_XML% call :logAdd "[ERROR] CONFIG_XML=[%CONFIG_XML%] does not exist." & goto :eof
REM 	FOR /F "tokens=2 delims=:" %%A in ('TYPE %CONFIG_XML% 2^>NUL: ^| psreplace "(<gui.*?</gui>)" "$1" ^| findstr /I /R /C:"<address>.*:.*</address>" ^| psreplace "<.*?>"') DO SET WEB_UI_PORT=%%A
REM 
REM Detect which port Syncthing is listening on.
FOR /F "tokens=*" %%A in ('powershell -NoLogo -NoProfile -ExecutionPolicy ByPass -Command "Write-Host (Get-NetTCPConnection -State Listen -OwningProcess (Get-Process -Name \"syncthing\").Id | ForEach { Write-Host $_.LocalPort })" 2^>NUL:') DO call :probeWebUiPort %%A
REM 
goto :eof


:probeWebUiPort
REM 
REM Syntax:
REM 	call :probeWebUiPort [TCP_PORT_TO_PROBE]
REM 
REM Global Variables.
REM 	[OUT] WEB_UI_PORT
REM 
SET TMP_PWUP_PORT=%1
IF NOT DEFINED TMP_PWUP_PORT call :logAdd "[ERROR] probeWebUiPort: Param #1 port missing." & goto :eof
REM 
call :logAdd "[INFO] Probing tcp %TMP_PWUP_PORT% ..."
powershell -NoLogo -NoProfile -ExecutionPolicy ByPass -Command "(Invoke-WebRequest -uri \"http://localhost:%TMP_PWUP_PORT%\").Headers.Keys" 2>&1 | findstr /i /c:"X-Syncthing-Id" /c:"Not Authorized" >NUL: && (call :logAdd "[INFO] Found Syncthing Web UI on tcp %TMP_PWUP_PORT%." & SET WEB_UI_PORT=%TMP_PWUP_PORT%)
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
