@echo off
setlocal enabledelayedexpansion
SET SCRIPT_PATH=%~dps0
cd /d "%SCRIPT_PATH%"
cls
REM
call :psConvertFileRemoveCRLF "managed-bookmarks-src.json" "..\machine\managed-bookmarks.json"
REM
type "managed-bookmarks-src.json" | tr -d '\r\n' > "..\machine\managed-bookmarks.json"
REM
powershell -ExecutionPolicy "ByPass" -Command "ConvertFrom-Json (Get-Content '..\machine\managed-bookmarks.json' -Raw) | Out-Null" | findstr /v "^$" | findstr /r ".*" >NUL: && (echo [ERROR] JSON is INVALID. & pause & goto :eof)
echo [INFO] JSON is VALID.
REM
REM call :updateGPO C-Google-Chrome HKLM\Software\Policies\Google\Chrome ManagedBookmarks
REM
REM call :updateGPO C-Microsoft-Edge HKLM\Software\Policies\Microsoft\Edge ManagedFavorites
REM
REM call :updateGPO C-Mozilla-Firefox HKLM\Software\Policies\Mozilla\Firefox ManagedBookmarks
REM
start /wait "" "..\machine\managed-bookmarks.json"
REM
REM del /f "..\machine\managed-bookmarks.json" 2>NUL:
REM timeout 3
REM
pause
goto :eof


:logAdd
REM Syntax:
REM		logAdd [TEXT]
SET LOG_TEXT=%1
SET LOG_TEXT=!LOG_TEXT:"=!
SET LOG_DATETIMESTAMP=%DATE:~-4%-%DATE:~-7,-5%-%DATE:~-10,-8%_%time:~-11,2%:%time:~-8,2%:%time:~-5,2%
SET LOG_DATETIMESTAMP=%LOG_DATETIMESTAMP: =0%
echo %LOG_DATETIMESTAMP%: !LOG_TEXT!
REM echo %LOG_DATETIMESTAMP%: !LOG_TEXT! >> "%LOGFILE%"
goto :eof


:psConvertFileRemoveCRLF
REM 
REM Syntax:
REM 	call :psConvertFileRemoveCRLF [SRC_FULLFN] [DST_FULLFN]
REM 
REM Variables.
SET TMP_PSCFR_SRCFULLFN=%1
IF DEFINED TMP_PSCFR_SRCFULLFN SET TMP_PSCFR_SRCFULLFN=%TMP_PSCFR_SRCFULLFN:"=%
REM
SET TMP_PSCFR_DSTFULLFN=%2
IF DEFINED TMP_PSCFR_DSTFULLFN SET TMP_PSCFR_DSTFULLFN=%TMP_PSCFR_DSTFULLFN:"=%
IF NOT DEFINED TMP_PSCFR_DSTFULLFN SET TMP_PSCFR_DSTFULLFN=%TMP_PSCFR_SRCFULLFN%
REM 
IF NOT EXIST %TMP_PSCFR_SRCFULLFN% call :logAdd "[ERROR] psConvertFileFromCRLFtoLF: TMP_PSCFR_SRCFULLFN=[%TMP_PSCFR_SRCFULLFN%] does not exist." & goto :eof
call :logAdd "[INFO] psConvertFileRemoveCRLF: Converting [%TMP_PSCFR_SRCFULLFN%] ..."
powershell -NoLogo -NoProfile -ExecutionPolicy ByPass -Command "Set-Content -Path '%TMP_PSCFR_DSTFULLFN%' -NoNewLine -Value (Get-Content '%TMP_PSCFR_SRCFULLFN%' -Raw).Replace(\"`r`n\",\"\")" 2> NUL:
REM 
goto :eof


:updateGPO
REM
SET "UGPO_NAME=%1"
SET "UPGO_REGKEY=%2"
SET "UGPO_REGVALUENAME=%3"
REM
echo [INFO] Updating GPO: %UGPO_NAME%
powershell -ExecutionPolicy "ByPass" -Command "$buf=Get-Content -Encoding UTF8 '..\machine\managed-bookmarks.json'; Set-GPRegistryValue -Name '%UGPO_NAME%' -Key '%UPGO_REGKEY%' -ValueName '%UGPO_REGVALUENAME%' -Type String -Value $buf" | findstr /C:"ComputerVersion" || (echo [ERROR] Set-GPRegistryValue: Access denied. & goto :eof)
REM
REM powershell -ExecutionPolicy "ByPass" -Command "Get-GPRegistryValue -Name '%UGPO_NAME%' -Key '%UPGO_REGKEY%' -ValueName '%UGPO_REGVALUENAME%'
REM
goto :eof
