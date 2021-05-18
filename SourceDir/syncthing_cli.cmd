@echo off
setlocal enabledelayedexpansion
REM
REM Script Configuration.
SET LOGFILE="%TEMP%\%~n0.log"
REM 
REM Get service account.
SET REG_QUERIES_SUCCEEDED=1
call :regQueryToVar "HKLM\SYSTEM\CurrentControlSet\Services\Syncthing" "ObjectName" "REG_SZ" "SERVICE_ACCOUNT"
IF "%REG_QUERIES_SUCCEEDED%" == "0" call :logAdd "[ERROR] Could not read SERVICE_ACCOUNT from service registry." & goto :eof
REM 
call :runSyncthingCliCmd %*
REM 
call :logAdd "[INFO] Done."
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


:regQueryToVar
REM 
REM Syntax:
REM 	call :regQueryToVar "[REG_KEY]" "[REG_ENTRY_NAME]" "[REG_ENTRY_TYPE]" "[ENV_VAR]"
REM 
REM Example:
REM 	call :regQueryToVar "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion" "ProgramFilesDir" "REG_SZ" "TestVar"
REM 
REM Called By:
REM 	readMsiPkgCfgFromRegistry
REM 
REM Global Variables.
REM 	[OUT] [ENV_VAR]
REM 	[OUT] REG_QUERIES_SUCCEEDED
REM 
REM Variables.
SET TMP_RQTV_REG_KEY=%1
IF DEFINED TMP_RQTV_REG_KEY SET TMP_RQTV_REG_KEY=%TMP_RQTV_REG_KEY:"=%
REM 
SET TMP_RQTV_REG_ENTRY_NAME=%2
IF DEFINED TMP_RQTV_REG_ENTRY_NAME SET TMP_RQTV_REG_ENTRY_NAME=%TMP_RQTV_REG_ENTRY_NAME:"=%
REM 
SET TMP_RQTV_REG_ENTRY_TYPE=%3
IF DEFINED TMP_RQTV_REG_ENTRY_TYPE SET TMP_RQTV_REG_ENTRY_TYPE=%TMP_RQTV_REG_ENTRY_TYPE:"=%
REM 
SET TMP_RQTV_REG_ENTRY_ENV_VAR=%4
IF DEFINED TMP_RQTV_REG_ENTRY_ENV_VAR SET TMP_RQTV_REG_ENTRY_ENV_VAR=%TMP_RQTV_REG_ENTRY_ENV_VAR:"=%
REM 
SET "%TMP_RQTV_REG_ENTRY_ENV_VAR%="
for /f "tokens=3* delims= " %%A in ('reg query "%TMP_RQTV_REG_KEY%" /v "%TMP_RQTV_REG_ENTRY_NAME%" 2^> NUL: ^| find /i "%TMP_RQTV_REG_ENTRY_TYPE%"') DO (
	IF "%%B" == "" SET "%TMP_RQTV_REG_ENTRY_ENV_VAR%=%%A"
	IF NOT "%%B" == "" SET "%TMP_RQTV_REG_ENTRY_ENV_VAR%=%%A %%B"
)
IF NOT DEFINED %TMP_RQTV_REG_ENTRY_ENV_VAR% call :logAdd "[ERROR] regQueryToVar: Failed query [%TMP_RQTV_REG_KEY%]:[%TMP_RQTV_REG_ENTRY_NAME%]:[%TMP_RQTV_REG_ENTRY_TYPE%]." & SET "REG_QUERIES_SUCCEEDED=0" &goto :eof
call :logAdd "[INFO] regQueryToVar: Got %TMP_RQTV_REG_ENTRY_ENV_VAR%=[%%%TMP_RQTV_REG_ENTRY_ENV_VAR%%%]"
REM 
goto :eof


:runAsViaTaskScheduler
REM
REM Syntax:
REM 	call :runAsViaTaskScheduler [COMMAND_LINE_PARAM_1] [COMMAND_LINE_PARAM_2] [...]
REM
REM Global vars.
REM 	[IN] SERVICE_ACCOUNT
REM
schtasks /RU "%SERVICE_ACCOUNT%" /CREATE /SC ONEVENT /EC Application /MO *[System/EventID=777] /TN "Syncthing" /TR "%~dps0syncthing.exe -no-console -no-browser -home %~dps0appdata %*" /F
schtasks /RUN /TN "Syncthing"
REM
REM Open log tail in separate window.
start "Syncthing Log" powershell -ExecutionPolicy "ByPass" "Get-Content -Path \"%~dps0appdata\syncthing.log\" -Wait"
REM
call :logAdd "[INFO] Waiting for task to finish ..."
echo ****************** PLEASE NOTE ***********************
echo * To shutdown Syncthing properly, use your browser   *
echo * to navigate to its Web UI.                         *
echo * Then choose: Actions ^> Shutdown.                   *
echo ******************************************************
:runAsViaTaskSchedulerWaitForTaskToEnd
schtasks /QUERY /TN "Syncthing" /FO list 2>NUL: | find /i "Status:" | findstr /i /c:"Bereit" /c:"Ready" >NUL: || (timeout /nobreak 1 >NUL: & goto :runAsViaTaskSchedulerWaitForTaskToEnd)
call :logAdd "[INFO] Exec via task scheduler finished."
REM
goto :eof


:runSyncthingCliCmd
REM
REM Syntax:
REM 	call :runSyncthingCliCmd %*
REM
REM Global vars.
REM 	[IN] SERVICE_ACCOUNT
REM
SET TMP_CLI_CMD=%*
IF DEFINED TMP_CLI_CMD SET TMP_CLI_CMD=%TMP_CLI_CMD:"='%
REM
call :logAdd "[INFO] Stopping service: Syncthing"
net stop "Syncthing" 2>NUL:
REM
call :logAdd "[INFO] Stopping process: syncthing.exe"
taskkill /f /im "syncthing.exe" 1>NUL: 2>&1
REM
call :logAdd "[%SERVICE_ACCOUNT%] Exec via task scheduler: syncthing %TMP_CLI_CMD%"
call :runAsViaTaskScheduler %*
REM
goto :eof
