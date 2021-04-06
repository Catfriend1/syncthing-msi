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
REM Get command-line parameters.
SET "FOLDER_PATH=%1"
IF NOT DEFINED FOLDER_PATH call :logAdd "[ERROR] Parameter #1 folder path missing." & goto :eof
IF NOT EXIST %FOLDER_PATH% call :logAdd "[ERROR] FOLDER_PATH=[FOLDER_PATH] does not exist." & goto :eof
REM 
call :grantFolderAccessToSyncthing "%SERVICE_ACCOUNT%" %FOLDER_PATH%
REM 
call :logAdd "[INFO] Done."
goto :eof

:grantFolderAccessToSyncthing
REM 
REM Syntax:
REM 	call :grantFolderAccessToSyncthing "[SERVICE_ACCOUNT]" "[PATH_TO_FOLDER]"
REM 
REM Variables.
SET "GFATS_SERVICE_ACCOUNT=%1"
IF DEFINED GFATS_SERVICE_ACCOUNT SET "GFATS_SERVICE_ACCOUNT=%GFATS_SERVICE_ACCOUNT:"=%"
REM 
SET "GFATS_FOLDER_PATH=%2"
IF DEFINED GFATS_FOLDER_PATH SET "GFATS_FOLDER_PATH=%GFATS_FOLDER_PATH:"=%"
REM 
call :logAdd "[INFO] grantFolderAccessToSyncthing: Setting ACL for [%SERVICE_ACCOUNT%] on [%GFATS_FOLDER_PATH%] ..."
icacls "%GFATS_FOLDER_PATH%" /grant "%GFATS_SERVICE_ACCOUNT%":(OI)(CI)F 1> NUL:
SET ICACLS_RESULT=%ERRORLEVEL%
IF NOT "%ICACLS_RESULT%" == "0" call :logAdd "[ERROR] Failed to apply some file or folder ACLs - code %ICACLS_RESULT%." & goto :eof
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
