@echo off
setlocal enabledelayedexpansion
SET SCRIPT_PATH=%~dps0
cd /d "%SCRIPT_PATH%"
cls
title Syncthing - Upgrade
REM
REM Script Configuration.
SET LOGFILE="%TEMP%\%~n0.log"
SET CLEAN_LOG_AFTER_SUCCESSFUL_INSTALL=0
SET DEBUG_MODE=0
REM 
call :setupSyncthing
REM 
REM End of Script.
call :logAdd "[INFO] === END ==="
call :logAdd "[INFO]"
goto :eof


:applyFirstTimeConfig
REM 
REM Syntax:
REM 	call :applyFirstTimeConfig
REM 
REM Called By:
REM 	:configureSyncthing
REM 
REM Global Variables.
REM 	[IN] CONFIG_XML
REM 	[IN] PROPERTY_*
REM 
REM Auto upgrade
IF "%PROPERTY_STNOUPGRADE%" == "1" (
	call :logAdd "[INFO] applyFirstTimeConfig: Disabling auto upgrade ..."
	SETX /M "STNOUPGRADE" "1" 2>&1 | find ":"
	SET OPTION_AUTO_UPGRADE_INTERVAL_H=0
	SET OPTION_RELEASES_URL=http://localhost/upgrades.syncthing.net/meta.json
) ELSE (
	call :logAdd "[INFO] applyFirstTimeConfig: Enabling auto upgrade ..."
	SETX /M "STNOUPGRADE" "" 2>&1 | find ":"
	SET OPTION_AUTO_UPGRADE_INTERVAL_H=12
	SET OPTION_RELEASES_URL=https://upgrades.syncthing.net/meta.json
)
REM 
REM Web UI Bind
SET "PROPERTY_REMOTE_WEB_UI_BIND=127.0.0.1:%PROPERTY_WEB_UI_PORT%"
IF "%PROPERTY_REMOTE_WEB_UI%" == "1" SET "PROPERTY_REMOTE_WEB_UI_BIND=0.0.0.0:%PROPERTY_WEB_UI_PORT%"
call :logAdd "[INFO] applyFirstTimeConfig: PROPERTY_REMOTE_WEB_UI_BIND=[%PROPERTY_REMOTE_WEB_UI_BIND%]"
REM 
REM Adjust syncthing "config.xml".
call :logAdd "[INFO] applyFirstTimeConfig: Adjusting [config.xml] ..."
REM 
REM 	WebGUI Port, Data Port, Do not start browser
call :editConfigXml "<address>127\.0\.0\.1:.*<\/address>" "<address>%PROPERTY_REMOTE_WEB_UI_BIND%</address>"
call :editConfigXml "<address>0\.0\.0\.0:.*<\/address>" "<address>%PROPERTY_REMOTE_WEB_UI_BIND%</address>"
call :editConfigXml "<listenAddress>default<\/listenAddress>" "<listenAddress>tcp4://:%PROPERTY_DATA_PORT%</listenAddress>"
call :editConfigXml "<listenAddress>tcp4://.*<\/listenAddress>" "<listenAddress>tcp4://:%PROPERTY_DATA_PORT%</listenAddress>"
call :addRelayListenerToConfig
call :editConfigXml "<startBrowser>true<\/startBrowser>" "<startBrowser>false</startBrowser>"
REM 
REM 	Global Discovery, Local discovery, Relays, NAT Traversal
call :editConfigXml "<relaysEnabled>.*<\/relaysEnabled>" "<relaysEnabled>%PROPERTY_RELAYS_ENABLED%</relaysEnabled>"
call :editConfigXml "<natEnabled>.*<\/natEnabled>" "<natEnabled>%PROPERTY_NAT_ENABLED%</natEnabled>"
call :editConfigXml "<globalAnnounceEnabled>.*<\/globalAnnounceEnabled>" "<globalAnnounceEnabled>%PROPERTY_GLOBAL_ANNOUNCE_ENABLED%</globalAnnounceEnabled>"
call :editConfigXml "<localAnnounceEnabled>.*<\/localAnnounceEnabled>" "<localAnnounceEnabled>%PROPERTY_LOCAL_ANNOUNCE_ENABLED%</localAnnounceEnabled>"
REM 
REM 	Crash Reporting
call :editConfigXml "<crashReportingEnabled>.*<\/crashReportingEnabled>" "<crashReportingEnabled>%PROPERTY_CRASH_REPORTING_ENABLED%</crashReportingEnabled>"
REM 
REM 	Upgrade server and automatic upgrades
call :editConfigXml "<autoUpgradeIntervalH>.*<\/autoUpgradeIntervalH>" "<autoUpgradeIntervalH>%OPTION_AUTO_UPGRADE_INTERVAL_H%</autoUpgradeIntervalH>"
call :editConfigXml "<releasesURL>.*<\/releasesURL>" "<releasesURL>%OPTION_RELEASES_URL%</releasesURL>"
REM 
REM 	Usage Reporting
call :editConfigXml "<urAccepted>.*<\/urAccepted>" "<urAccepted>%PROPERTY_UR_ACCEPTED%</urAccepted>"
call :editConfigXml "<urSeen>.*<\/urSeen>" "<urSeen>3</urSeen>"
REM 
REM 	Remove Default Shared Folder
call :editConfigXml "(?s)\r\n\s+<folder id=\`default\` .*?<\/folder>" ""
REM 
REM 	Default Folder Path
call :editConfigXml "<defaultFolderPath>~<\/defaultFolderPath>" "<defaultFolderPath>%SystemDrive%\Server\Sync</defaultFolderPath>"
REM 
REM 	Optional - Add device to config.
IF NOT "%PROPERTY_ADD_DEVICE_HOST%" == "localhost.localdomain" IF DEFINED PROPERTY_ADD_DEVICE_HOST IF DEFINED PROPERTY_ADD_DEVICE_PORT IF DEFINED PROPERTY_ADD_DEVICE_ID call :addDeviceToConfig "%PROPERTY_ADD_DEVICE_ID%" "%PROPERTY_ADD_DEVICE_HOST%" "tcp4://%PROPERTY_ADD_DEVICE_HOST%:%PROPERTY_ADD_DEVICE_PORT%"
REM 
goto :eof


:addDeviceToConfig
REM 
REM Syntax:
REM 	call :addDeviceToConfig "[SERVER_DEVICE_ID]" "[SERVER_DEVICE_NAME]" "[PROTOCOL://SERVER_DNS:SERVER_TCP_PORT]"
REM 
REM Called By:
REM 	:applyFirstTimeConfig
REM 
REM Global Variables.
REM 	[IN] CONFIG_XML
REM 
REM Variables.
SET TMP_ADTC_SERVER_DEVICE_ID=%1
IF DEFINED TMP_ADTC_SERVER_DEVICE_ID SET TMP_ADTC_SERVER_DEVICE_ID=%TMP_ADTC_SERVER_DEVICE_ID:"=%
IF NOT DEFINED TMP_ADTC_SERVER_DEVICE_ID call :logAdd "[ERROR] addDeviceToConfig: Missing parameter TMP_ADTC_SERVER_DEVICE_ID" & goto :eof
REM 
SET TMP_ADTC_SERVER_NAME=%2
IF DEFINED TMP_ADTC_SERVER_NAME SET TMP_ADTC_SERVER_NAME=%TMP_ADTC_SERVER_NAME:"=%
IF NOT DEFINED TMP_ADTC_SERVER_NAME call :logAdd "[ERROR] addDeviceToConfig: Missing parameter TMP_ADTC_SERVER_NAME" & goto :eof
REM 
SET TMP_ADTC_SERVER_ADDR=%3
IF DEFINED TMP_ADTC_SERVER_ADDR SET TMP_ADTC_SERVER_ADDR=%TMP_ADTC_SERVER_ADDR:"=%
IF NOT DEFINED TMP_ADTC_SERVER_ADDR call :logAdd "[ERROR] addDeviceToConfig: Missing parameter TMP_ADTC_SERVER_ADDR" & goto :eof
REM 
REM Check if device already exists in config.
SET TMP_ADTC_DEVICE_ALREADY_PRESENT=0
TYPE %CONFIG_XML% 2>NUL: | findstr /I /R /C:".*<device id=\"%TMP_ADTC_SERVER_DEVICE_ID%\" name=\".*\" .*>.*" 1>NUL: && SET TMP_ADTC_DEVICE_ALREADY_PRESENT=1
REM
REM Add device to config if it does not exist yet.
IF "%TMP_ADTC_DEVICE_ALREADY_PRESENT%" == "0" call :logAdd "[INFO] addDeviceToConfig: Adding device to config [%TMP_ADTC_SERVER_DEVICE_ID%], [%TMP_ADTC_SERVER_ADDR%] ..." & call :editConfigXml "(.*<gui.*>.*)" "    <device id=`%TMP_ADTC_SERVER_DEVICE_ID%` name=`%TMP_ADTC_SERVER_NAME%` compression=`metadata` introducer=`false` skipIntroductionRemovals=`false` introducedBy=``><address>%TMP_ADTC_SERVER_ADDR%</address></device>§r§n$1" & goto :eof
REM 
REM Update existing device.
call :logAdd "[INFO] Device [%TMP_ADTC_SERVER_DEVICE_ID%] already present in [config.xml]."
call :editConfigUpdateDevice "%TMP_ADTC_SERVER_DEVICE_ID%" "address" "%TMP_ADTC_SERVER_ADDR%"
REM 
goto :eof


:addRelayListenerToConfig
REM 
REM Syntax:
REM 	call :addRelayListenerToConfig
REM 
REM Called By:
REM 	:applyFirstTimeConfig
REM 
REM Global Variables.
REM 	[IN] CONFIG_XML
REM 
SET TMP_ARLTC_LISTENADDRESS_ALREADY_PRESENT=0
TYPE %CONFIG_XML% 2>NUL: | findstr /I /R /C:".*<listenAddress>dynamic+https://relays.syncthing.net/endpoint</listenAddress>.*" 1>NUL: && SET TMP_ARLTC_LISTENADDRESS_ALREADY_PRESENT=1
IF "%TMP_ARLTC_LISTENADDRESS_ALREADY_PRESENT%" == "1" call :logAdd "[INFO] addRelayListenerToConfig: Relay listenAddress already present in [config.xml]. Skipping ..." & goto :eof
REM 
call :logAdd "[INFO] addRelayListenerToConfig: Adding relay listener."
call :editConfigXml "(.*<listenAddress>.*</listenAddress>)" "$1§r§n        <listenAddress>dynamic+https://relays.syncthing.net/endpoint</listenAddress>"
REM 
goto :eof


:configureSyncthing
REM 
REM Syntax:
REM 	call :configureSyncthing
REM 
REM Called By:
REM 	:setupSyncthing
REM 
REM Global Variables.
REM 	[IN] SCRIPT_PATH
REM 	[IN] SYNCTHING_EXE
REM 
REM Consts.
SET "REG_SYNCTHING=HKLM\SOFTWARE\WOW6432Node\The Syncthing Authors\Syncthing"
REM 
REM Runtime Variables.
SET SYNCTHING_PATH=%SCRIPT_PATH%
SET CONFIG_XML="%SYNCTHING_PATH%\AppData\config.xml"
REM 
REM Always stop service before a test.
IF "%DEBUG_MODE%" == "1" net stop "Syncthing" & RD /S /Q "%SYNCTHING_PATH%\AppData"
IF NOT EXIST "%SYNCTHING_PATH%\AppData" MD "%SYNCTHING_PATH%\AppData"
REM 
call :readMsiPkgCfgFromRegistry
IF "%REG_QUERIES_SUCCEEDED%" == "0" call :logAdd "[ERROR] readMsiPkgCfgFromRegistry FAILED. Stop." & goto :eof
REM 
REM Note:
REM 	Windows Installer STOPS the service prior to starting this script if we install another MSI version as the one that is already installed.
REM 	Windows Installer DOES NOT STOP the service prior to starting this script if we install the SAME MSI version as the one that is already installed.
SET QUEUE_SERVICE_RESTART=0
sc query Syncthing | find /i "STATE" | find /i "RUNNING" 1> NUL: && (SET QUEUE_SERVICE_RESTART=1& call :stopService)
REM 
call :setupFilePermissions
REM 
REM Detect a fresh installation.
IF NOT EXIST "%CONFIG_XML%" call :generateKeysAndConfig & SET PROPERTY_OVERRIDE_EXISTING_CONFIG=1
IF NOT EXIST "%CONFIG_XML%" call :logAdd "[ERROR] CONFIG_XML not found. Stop." & goto :eof
REM 
SET "CONFIG_XML_BACKUP=%DATE:~-4%-%DATE:~-7,-5%-%DATE:~-10,-8%_%time:~-11,2%-%time:~-8,2%-%time:~-5,2%_config.xml"
call :logAdd "[INFO] configureSyncthing: Backup config to [%CONFIG_XML_BACKUP%] ..."
copy /y %CONFIG_XML% "%SYNCTHING_PATH%\AppData\%CONFIG_XML_BACKUP%"
SET COPY_RESULT=%ERRORLEVEL%
IF NOT "%COPY_RESULT%" == "0" call :logAdd "[WARN] Backup config FAILED with code %COPY_RESULT%."
REM 
REM Detect an empty installation.
SET USER_FOLDERS_PRESENT=0
TYPE %CONFIG_XML% 2>NUL: | findstr /I /R /C:".*<folder id=\".*\" label=\".*\" .*>.*" | findstr /V /I /R /C:".*<folder id=\".*\" label=\"Default Folder\" .*>.*" 1>NUL: && SET USER_FOLDERS_PRESENT=1
REM 
REM Reset config to defaults if an empty config was identified.
call :logAdd "[INFO] configureSyncthing: USER_FOLDERS_PRESENT=[%USER_FOLDERS_PRESENT%]"
IF "%USER_FOLDERS_PRESENT%" == "0" SET PROPERTY_OVERRIDE_EXISTING_CONFIG=1
IF "%PROPERTY_OVERRIDE_EXISTING_CONFIG%" == "1" call :logAdd "[INFO] configureSyncthing: Enforcing first time config ..." & call :applyFirstTimeConfig
REM 
REM Perform ongoing config maintenance.
IF "%PROPERTY_OVERRIDE_DEVICE_NAME_WITH_COMPUTERNAME%" == "1" call :renameLocalDevice
call :editConfigXml "<hashers>.*<\/hashers>" "<hashers>%PROPERTY_HASHERS%</hashers>"
REM 
call :psConvertFileFromCRLFtoLF %CONFIG_XML%
REM 
IF "%QUEUE_SERVICE_RESTART%" == "1" call :logAdd "[INFO] configureSyncthing: Restarting previously running service ..." & call :startService
REM 
goto :eof


:editConfigXml
REM 
REM Syntax:
REM 	call :editConfigXml "[REGEX_SEARCH]", "[REPLACE]"
REM 
REM Global Variables.
REM 	[IN] CONFIG_XML
REM 
type %CONFIG_XML% 2> NUL: | psreplace %1 %2 %CONFIG_XML%
REM
goto :eof


:editConfigUpdateDevice
REM 
REM Syntax:
REM 	call :editConfigUpdateDevice "[DEVICE_ID]" "[DEVICE_ATTRIBUTE_NAME]" "[DEVICE_ATTRIBUTE_VALUE]"
REM 
REM Global Variables.
REM 	[IN] CONFIG_XML
REM 
REM Variables.
SET TMP_ECUD_DEVICE_ID=%1
IF DEFINED TMP_ECUD_DEVICE_ID SET TMP_ECUD_DEVICE_ID=%TMP_ECUD_DEVICE_ID:"=%
REM 
SET TMP_ECUD_DEVICE_ATTRIBUTE_NAME=%2
IF DEFINED TMP_ECUD_DEVICE_ATTRIBUTE_NAME SET TMP_ECUD_DEVICE_ATTRIBUTE_NAME=%TMP_ECUD_DEVICE_ATTRIBUTE_NAME:"=%
REM 
SET TMP_ECUD_DEVICE_ATTRIBUTE_VALUE=%3
IF DEFINED TMP_ECUD_DEVICE_ATTRIBUTE_VALUE SET TMP_ECUD_DEVICE_ATTRIBUTE_VALUE=%TMP_ECUD_DEVICE_ATTRIBUTE_VALUE:"=%
REM 
call :logAdd "[INFO] editConfigUpdateDevice: device['%TMP_ECUD_DEVICE_ID%'].%TMP_ECUD_DEVICE_ATTRIBUTE_NAME%='%TMP_ECUD_DEVICE_ATTRIBUTE_VALUE%'"
REM 
IF NOT EXIST %CONFIG_XML% call :logAdd "[ERROR] editConfigUpdateDevice: CONFIG_XML not found. " & goto :eof
powershell -NoLogo -NoProfile -ExecutionPolicy ByPass -Command "$xml = New-Object XML; $xml.PreserveWhitespace = $true; $xml.Load('%CONFIG_XML%'); ($xml.SelectSingleNode(\"/configuration/device[@id = '%TMP_ECUD_DEVICE_ID%']\")).%TMP_ECUD_DEVICE_ATTRIBUTE_NAME%='%TMP_ECUD_DEVICE_ATTRIBUTE_VALUE%';$xml.Save('%CONFIG_XML%')" 2> NUL:
REM 
goto :eof


:execTakeown
REM 
REM Syntax:
REM 	call :execTakeown "[FULL_PATH_TO_DIRECTORY]"
REM 
SET TMP_PATH_TO_OWN=%1
REM 
REM German Windows 7 and Windows 10.1703 use /D y
REM German Windows 10.1809+ use /D j
takeown /F %TMP_PATH_TO_OWN% /R /A /D y 2>&1 | findstr /v /c:"'y'" /c:"TAKEOWN /?" 1> NUL:
takeown /F %TMP_PATH_TO_OWN% /R /A /D j 2>&1 | findstr /v /c:"'j'" /c:"TAKEOWN /?" 1> NUL:
REM 
goto :eof


:generateKeysAndConfig
REM 
REM Syntax:
REM 	call :generateKeysAndConfig
REM 
REM Called By:
REM 	:configureSyncthing
REM 
REM Global Variables.
REM 	[IN] SYNCTHING_EXE
REM 	[IN] SYNCTHING_PATH
REM 
REM 	Generate a fresh deviceID, keys and config.
call :logAdd "[INFO] generateKeysAndConfig: Generating new keys and config ..."
REM 
"%SYNCTHING_EXE%" -logflags=0 -generate "%SYNCTHING_PATH%\appdata"
"%SYNCTHING_EXE%" -device-id -home "%SYNCTHING_PATH%\appdata" > "%SYNCTHING_PATH%\appdata\device_id.txt"
IF "%DEBUG_MODE%" == "1" copy /y "%SYNCTHING_PATH%\appdata\config.xml" "%SYNCTHING_PATH%\generateKeysAndConfig_result.xml" 
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


:psConvertFileFromCRLFtoLF
REM 
REM Syntax:
REM 	call :psConvertFileFromCRLFtoLF [FULLFN]
REM 
REM Variables.
SET TMP_PSCFFCL_FULLFN=%1
IF DEFINED TMP_PSCFFCL_FULLFN SET TMP_PSCFFCL_FULLFN=%TMP_PSCFFCL_FULLFN:"=%
REM 
IF NOT EXIST %TMP_PSCFFCL_FULLFN% call :logAdd "[ERROR] psConvertFileFromCRLFtoLF: TMP_PSCFFCL_FULLFN=[%TMP_PSCFFCL_FULLFN%] does not exist." & goto :eof
call :logAdd "[INFO] psConvertFileFromCRLFtoLF: Converting [%TMP_PSCFFCL_FULLFN%] ..."
powershell -NoLogo -NoProfile -ExecutionPolicy ByPass -Command "Set-Content -Path '%TMP_PSCFFCL_FULLFN%' -NoNewLine -Value (Get-Content '%TMP_PSCFFCL_FULLFN%' -Raw).Replace(\"`r`n\",\"`n\")" 2> NUL:
REM 
goto :eof


:readMsiPkgCfgFromRegistry
REM 
REM Syntax:
REM 	call :readMsiPkgCfgFromRegistry
REM 
REM Called By:
REM 	configureSyncthing
REM 
REM Global Variables.
REM 	[IN]  REG_SYNCTHING
REM 	[OUT] PROPERTY_ADD_DEVICE_HOST
REM 	[OUT] PROPERTY_ADD_DEVICE_ID
REM 	[OUT] PROPERTY_ADD_DEVICE_PORT
REM 	[OUT] PROPERTY_CRASH_REPORTING_ENABLED
REM 	[OUT] PROPERTY_DATA_PORT
REM 	[OUT] PROPERTY_GLOBAL_ANNOUNCE_ENABLED
REM 	[OUT] PROPERTY_HASHERS
REM 	[OUT] PROPERTY_LOCAL_ANNOUNCE_ENABLED
REM 	[OUT] PROPERTY_NAT_ENABLED
REM 	[OUT] PROPERTY_OVERRIDE_DEVICE_NAME_WITH_COMPUTERNAME
REM 	[OUT] PROPERTY_OVERRIDE_EXISTING_CONFIG
REM 	[OUT] PROPERTY_RELAYS_ENABLED
REM 	[OUT] PROPERTY_REMOTE_WEB_UI
REM 	[OUT] PROPERTY_STNOUPGRADE
REM 	[OUT] PROPERTY_UR_ACCEPTED
REM 	[OUT] PROPERTY_WEB_UI_PORT
REM 	[OUT] REG_QUERIES_SUCCEEDED
REM 
call :logAdd "[INFO] readMsiPkgCfgFromRegistry"
SET REG_QUERIES_SUCCEEDED=1
REM 
call :regQueryToVar "%REG_SYNCTHING%" "ADD_DEVICE_HOST" "REG_SZ" "PROPERTY_ADD_DEVICE_HOST"
call :regQueryToVar "%REG_SYNCTHING%" "ADD_DEVICE_ID" "REG_SZ" "PROPERTY_ADD_DEVICE_ID"
call :regQueryToVar "%REG_SYNCTHING%" "ADD_DEVICE_PORT" "REG_SZ" "PROPERTY_ADD_DEVICE_PORT"
call :regQueryToVar "%REG_SYNCTHING%" "crashReportingEnabled" "REG_SZ" "PROPERTY_CRASH_REPORTING_ENABLED"
call :regQueryToVar "%REG_SYNCTHING%" "DATA_PORT" "REG_SZ" "PROPERTY_DATA_PORT"
call :regQueryToVar "%REG_SYNCTHING%" "globalAnnounceEnabled" "REG_SZ" "PROPERTY_GLOBAL_ANNOUNCE_ENABLED"
call :regQueryToVar "%REG_SYNCTHING%" "hashers" "REG_SZ" "PROPERTY_HASHERS"
call :regQueryToVar "%REG_SYNCTHING%" "localAnnounceEnabled" "REG_SZ" "PROPERTY_LOCAL_ANNOUNCE_ENABLED"
call :regQueryToVar "%REG_SYNCTHING%" "natEnabled" "REG_SZ" "PROPERTY_NAT_ENABLED"
call :regQueryToVar "%REG_SYNCTHING%" "OVERRIDE_DEVICE_NAME_WITH_COMPUTERNAME" "REG_SZ" "PROPERTY_OVERRIDE_DEVICE_NAME_WITH_COMPUTERNAME"
call :regQueryToVar "%REG_SYNCTHING%" "OVERRIDE_EXISTING_CONFIG" "REG_SZ" "PROPERTY_OVERRIDE_EXISTING_CONFIG"
call :regQueryToVar "%REG_SYNCTHING%" "relaysEnabled" "REG_SZ" "PROPERTY_RELAYS_ENABLED"
call :regQueryToVar "%REG_SYNCTHING%" "REMOTE_WEB_UI" "REG_SZ" "PROPERTY_REMOTE_WEB_UI"
call :regQueryToVar "%REG_SYNCTHING%" "STNOUPGRADE" "REG_SZ" "PROPERTY_STNOUPGRADE"
call :regQueryToVar "%REG_SYNCTHING%" "urAccepted" "REG_SZ" "PROPERTY_UR_ACCEPTED"
call :regQueryToVar "%REG_SYNCTHING%" "WEB_UI_PORT" "REG_SZ" "PROPERTY_WEB_UI_PORT"
REM 
goto :eof


:renameLocalDevice
REM 
REM Syntax:
REM 	call :renameLocalDevice
REM 
SET LOCAL_DEVICE_ID=
FOR /F "tokens=1" %%A IN ('TYPE "%SYNCTHING_PATH%\appdata\device_id.txt" 2^>NUL:') DO SET "LOCAL_DEVICE_ID=%%A"
IF NOT DEFINED LOCAL_DEVICE_ID call :logAdd "[ERROR] renameLocalDevice: Failed to read LOCAL_DEVICE_ID." & goto :eof
call :editConfigUpdateDevice "%LOCAL_DEVICE_ID%" "name" "%COMPUTERNAME%"
REM 
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


:setupFilePermissions
REM 
REM Syntax:
REM 	call :setupFilePermissions
REM 
REM Variables.
SET ADMIN_GROUP_SID=*S-1-5-32-544
SET USER_LOCAL_SERVICE_SID=*S-1-5-19
SET USER_NETWORK_SERVICE_SID=*S-1-5-20
REM 
call :logAdd "[INFO] setupFilePermissions"
call :execTakeown "%SYNCTHING_PATH%\AppData"
icacls "%SYNCTHING_PATH%\AppData" /inheritance:r 1> NUL:
icacls "%SYNCTHING_PATH%\AppData" /grant "%ADMIN_GROUP_SID%":(OI)(CI)F /T 1> NUL:
icacls "%SYNCTHING_PATH%\AppData" /grant "%USER_LOCAL_SERVICE_SID%":(OI)(CI)F /T 1> NUL:
icacls "%SYNCTHING_PATH%\AppData" /grant "%USER_NETWORK_SERVICE_SID%":(OI)(CI)F /T 1> NUL:
icacls "%SYNCTHING_PATH%\AppData" /grant "SYSTEM":(OI)(CI)F /T 1> NUL:
REM 
goto :eof


:setupSyncthing
REM 
REM Syntax:
REM 	call :setupSyncthing
REM 
REM Called By:
REM 	MAIN
REM 
REM Preconditions:
REM 	Syncthing is NOT running.
REM 		Windows Installer runs this on upgrade when the service is non-present, so Syncthing is NOT running.
REM 
call :logAdd "[INFO] === START ==="
call :logAdd "[INFO] setupSyncthing ..."
REM 
SET SYNCTHING_TITLE=Syncthing
SET SYNCTHING_EXE_SHORT=syncthing.exe
REM 
REM Get Syncthing executable FullFN.
SET SYNCTHING_EXE=
FOR /f %%i in ('powershell "(Get-Item -LiteralPath '%SYNCTHING_EXE_SHORT%').FullName"') DO SET SYNCTHING_EXE=%%i
IF NOT EXIST "%SYNCTHING_EXE%" call :logAdd "[ERROR] Could not resolve Syncthing EXE FullFN." & goto :eof
REM 
REM Configure Windows Firewall
call :logAdd "[INFO] setupSyncthing: Firewall - Deleting previously created rules ..."
netsh advfirewall firewall delete rule name="%SYNCTHING_TITLE%" dir="in" | find /i "."
REM 
call :logAdd "[INFO] setupSyncthing: Firewall - Creating rules for service ..."
netsh advfirewall firewall add rule name="%SYNCTHING_TITLE%" program="%SYNCTHING_EXE%" description="%SYNCTHING_TITLE%" enable="yes" profile="any" localip="any" remoteip="any" action="allow" edge="yes" dir="in" 1> NUL:
IF NOT "%ERRORLEVEL%" == "0" call :logAdd "[ERROR] ... FAILED." & goto :eof
REM 
REM Configure Syncthing on fresh install or upgrade.
call :configureSyncthing
call :logAdd "[INFO] setupSyncthing: Configuration done."
REM 
REM Delete log file on success.
IF "%CLEAN_LOG_AFTER_SUCCESSFUL_INSTALL%" == "1" DEL /F "%LOGFILE%" 2> NUL:
REM 
goto :eof


:startService
REM 
REM Syntax:
REM 	call :startService
REM 
REM Called By:
REM 	configureSyncthing
REM 
call :logAdd "[INFO] startService"
sc start "Syncthing" | find /i "STATE"
REM 
goto :eof


:stopService
REM 
REM Syntax:
REM 	call :stopService
REM 
REM Called By:
REM 	configureSyncthing
REM 
call :logAdd "[INFO] stopService"
net stop "Syncthing" 2>&1 | find "."
REM 
goto :eof
