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


:applyPolicyUpgrade
REM 
call :regQueryToVar "%REG_SYNCTHING%" "enableAutoUpgrade" "REG_SZ" "enableAutoUpgrade"
IF NOT DEFINED enableAutoUpgrade SET enableAutoUpgrade=1
REM
IF "%enableAutoUpgrade%" == "0" (
	call :logAdd "[INFO] applyPolicyUpgrade: Disabling auto upgrade ..."
	SETX /M "STNOUPGRADE" "1" 2>&1 | find ":"
	SET OPTION_AUTO_UPGRADE_INTERVAL_H=0
	SET OPTION_RELEASES_URL=http://localhost/upgrades.syncthing.net/meta.json
) ELSE (
	call :logAdd "[INFO] applyPolicyUpgrade: Enabling auto upgrade ..."
	SETX /M "STNOUPGRADE" "" 2>&1 | find ":"
	SET OPTION_AUTO_UPGRADE_INTERVAL_H=12
	SET OPTION_RELEASES_URL=https://upgrades.syncthing.net/meta.json
)
REM
REM 	Upgrade server and automatic upgrades
call :editConfigXml "<autoUpgradeIntervalH>.*<\/autoUpgradeIntervalH>" "<autoUpgradeIntervalH>%OPTION_AUTO_UPGRADE_INTERVAL_H%</autoUpgradeIntervalH>"
call :editConfigXml "<releasesURL>.*<\/releasesURL>" "<releasesURL>%OPTION_RELEASES_URL%</releasesURL>"
REM
goto :eof


:applyPolicyRemoteWebUi
REM 
REM Web UI Bind
call :regQueryToVar "%REG_SYNCTHING%" "webUiTcpPort" "REG_SZ" "webUiTcpPort"
IF NOT DEFINED webUiTcpPort SET webUiTcpPort=8384
call :regQueryToVar "%REG_SYNCTHING%" "enableRemoteWebUi" "REG_SZ" "enableRemoteWebUi"
IF NOT DEFINED enableRemoteWebUi SET enableRemoteWebUi=0
REM
SET "PROPERTY_REMOTE_WEB_UI_BIND=127.0.0.1:%webUiTcpPort%"
IF "%enableRemoteWebUi%" == "1" SET "PROPERTY_REMOTE_WEB_UI_BIND=0.0.0.0:%webUiTcpPort%"
call :logAdd "[INFO] applyPolicyRemoteWebUi: PROPERTY_REMOTE_WEB_UI_BIND=[%PROPERTY_REMOTE_WEB_UI_BIND%]"
call :editConfigXml "<address>127\.0\.0\.1:.*<\/address>" "<address>%PROPERTY_REMOTE_WEB_UI_BIND%</address>"
call :editConfigXml "<address>0\.0\.0\.0:.*<\/address>" "<address>%PROPERTY_REMOTE_WEB_UI_BIND%</address>"
REM
goto :eof


:applyPolicyDataTcpPort
REM
call :regQueryToVar "%REG_SYNCTHING%" "dataTcpPort" "REG_SZ" "dataTcpPort"
IF NOT DEFINED dataTcpPort SET dataTcpPort=22000
call :editConfigXml "<listenAddress>default<\/listenAddress>" "<listenAddress>tcp4://:%dataTcpPort%</listenAddress>"
call :editConfigXml "<listenAddress>tcp4://.*<\/listenAddress>" "<listenAddress>tcp4://:%dataTcpPort%</listenAddress>"
REM
goto :eof


:applyPolicyEnableGlobalDiscovery
REM
call :regQueryToVar "%REG_SYNCTHING%" "enableGlobalDiscovery" "REG_SZ" "enableGlobalDiscovery"
IF NOT DEFINED enableGlobalDiscovery SET enableGlobalDiscovery=1
IF "%enableGlobalDiscovery%" == "0" SET enableGlobalDiscovery=false
IF "%enableGlobalDiscovery%" == "1" SET enableGlobalDiscovery=true
call :editConfigXml "<globalAnnounceEnabled>.*<\/globalAnnounceEnabled>" "<globalAnnounceEnabled>%enableGlobalDiscovery%</globalAnnounceEnabled>"
REM
goto :eof


:applyPolicyEnableLocalDiscovery
REM
call :regQueryToVar "%REG_SYNCTHING%" "enableLocalDiscovery" "REG_SZ" "enableLocalDiscovery"
IF NOT DEFINED enableLocalDiscovery SET enableLocalDiscovery=1
IF "%enableLocalDiscovery%" == "0" SET enableLocalDiscovery=false
IF "%enableLocalDiscovery%" == "1" SET enableLocalDiscovery=true
call :editConfigXml "<localAnnounceEnabled>.*<\/localAnnounceEnabled>" "<localAnnounceEnabled>%enableLocalDiscovery%</localAnnounceEnabled>"
REM
goto :eof


:applyPolicyEnableNAT
REM
call :regQueryToVar "%REG_SYNCTHING%" "enableNAT" "REG_SZ" "enableNAT"
IF NOT DEFINED enableNAT SET enableNAT=1
IF "%enableNAT%" == "0" SET enableNAT=false
IF "%enableNAT%" == "1" SET enableNAT=true
call :editConfigXml "<natEnabled>.*<\/natEnabled>" "<natEnabled>%enableNAT%</natEnabled>"
REM
goto :eof


:applyPolicyEnableRelays
REM
call :regQueryToVar "%REG_SYNCTHING%" "enableRelays" "REG_SZ" "enableRelays"
IF NOT DEFINED enableRelays SET enableRelays=1
IF "%enableRelays%" == "0" SET enableRelays=false
IF "%enableRelays%" == "1" SET enableRelays=true
call :editConfigXml "<relaysEnabled>.*<\/relaysEnabled>" "<relaysEnabled>%enableRelays%</relaysEnabled>"
REM
goto :eof


:applyPolicyEnableTelemetry
REM
call :regQueryToVar "%REG_SYNCTHING%" "enableTelemetry" "REG_SZ" "enableTelemetry"
IF NOT DEFINED enableTelemetry SET enableTelemetry=1
REM 
REM 	Crash Reporting
IF "%enableTelemetry%" == "0" SET PROPERTY_CRASH_REPORTING_ENABLED=false
IF "%enableTelemetry%" == "1" SET PROPERTY_CRASH_REPORTING_ENABLED=true
call :editConfigXml "<crashReportingEnabled>.*<\/crashReportingEnabled>" "<crashReportingEnabled>%PROPERTY_CRASH_REPORTING_ENABLED%</crashReportingEnabled>"
REM 
REM 	Usage Reporting
IF "%enableTelemetry%" == "0" SET PROPERTY_UR_ACCEPTED=-1
IF "%enableTelemetry%" == "1" SET PROPERTY_UR_ACCEPTED=1
call :editConfigXml "<urAccepted>.*<\/urAccepted>" "<urAccepted>%PROPERTY_UR_ACCEPTED%</urAccepted>"
call :editConfigXml "<urSeen>.*<\/urSeen>" "<urSeen>3</urSeen>"
REM
goto :eof


:applyPolicyHashers
REM
call :regQueryToVar "%REG_SYNCTHING%" "hashers" "REG_SZ" "hashers"
IF NOT DEFINED hashers SET hashers=0
call :editConfigXml "<hashers>.*<\/hashers>" "<hashers>%hashers%</hashers>"
REM
goto :eof


:applyPolicyDefaultVersioning
REM
call :regQueryToVar "%REG_SYNCTHING%" "defaultVersioningMode" "REG_SZ" "defaultVersioningMode"
IF NOT DEFINED defaultVersioningMode SET defaultVersioningMode=none
REM
SET CONFIG_XML_NQ=%CONFIG_XML:"=%
REM
powershell -ExecutionPolicy ByPass "[xml]$xml = Get-Content $ENV:CONFIG_XML_NQ; $versioningNode = $xml.SelectSingleNode('//configuration/defaults/folder/versioning'); $versioningNode.SetAttribute('type', $ENV:defaultVersioningMode); $xml.Save($ENV:CONFIG_XML_NQ);"
REM
IF "%defaultVersioningMode%" == "trashcan" powershell -ExecutionPolicy ByPass "[xml]$xml = Get-Content $ENV:CONFIG_XML_NQ; $versioningNode = $xml.SelectSingleNode('//configuration/defaults/folder/versioning'); $paramNode = $xml.SelectSingleNode('//configuration/defaults/folder/versioning/param'); if ($paramNode -eq $null) { $versioningNode.AppendChild($xml.CreateElement('param')) | Out-Null }; $xml.Save($ENV:CONFIG_XML_NQ);"
REM
IF "%defaultVersioningMode%" == "trashcan" powershell -ExecutionPolicy ByPass "[xml]$xml = Get-Content $ENV:CONFIG_XML_NQ; $paramNode = $xml.SelectSingleNode('//configuration/defaults/folder/versioning/param'); $paramNode.SetAttribute('key', 'cleanoutdays'); $paramNode.SetAttribute('val', '90'); $xml.Save($ENV:CONFIG_XML_NQ);"
REM
goto :eof


:applyAddDevicePolicy
REM 
REM Syntax:
REM 	call :applyAddDevicePolicy "[SERVER_DEVICE_ID]" "[SERVER_DEVICE_NAME]" "[PROTOCOL://SERVER_DNS:SERVER_TCP_PORT]"
REM 
REM Called By:
REM 	MAIN
REM 
REM Global Variables.
REM 	[IN] CONFIG_XML
REM 
REM Variables.
call :regQueryToVar "%REG_SYNCTHING%" "addDeviceID" "REG_SZ" "addDeviceID"
IF NOT DEFINED addDeviceID goto :eof
call :regQueryToVar "%REG_SYNCTHING%" "addDeviceHost" "REG_SZ" "addDeviceHost"
IF NOT DEFINED addDeviceHost goto :eof
call :regQueryToVar "%REG_SYNCTHING%" "addDevicePort" "REG_SZ" "addDevicePort"
IF NOT DEFINED addDevicePort goto :eof
REM
SET TMP_ADTC_SERVER_ADDR=tcp4://%addDeviceHost%:%addDevicePort%
REM
call :logAdd "[INFO] applyAddDevicePolicy"
REM 
REM Check if device already exists in config.
SET TMP_ADTC_DEVICE_ALREADY_PRESENT=0
TYPE %CONFIG_XML% 2>NUL: | findstr /I /R /C:".*<device id=\"%addDeviceID%\" name=\".*\" .*>.*" 1>NUL: && SET TMP_ADTC_DEVICE_ALREADY_PRESENT=1
REM
REM Add device to config if it does not exist yet.
IF "%TMP_ADTC_DEVICE_ALREADY_PRESENT%" == "0" call :logAdd "[INFO] applyAddDevicePolicy: Adding device to config [%addDeviceID%], [%TMP_ADTC_SERVER_ADDR%] ..." & call :editConfigXml "(.*<gui.*>.*)" "    <device id=`%addDeviceID%` name=`%addDeviceHost%` compression=`metadata` introducer=`false` skipIntroductionRemovals=`false` introducedBy=``><address>%TMP_ADTC_SERVER_ADDR%</address></device>§r§n$1" & goto :eof
REM 
REM Update existing device.
call :logAdd "[INFO] Device [%addDeviceID%] already present in [config.xml]."
call :editConfigUpdateDevice "%addDeviceID%" "address" "%TMP_ADTC_SERVER_ADDR%"
REM 
goto :eof


:addRelayListenerToConfig
REM 
REM Syntax:
REM 	call :addRelayListenerToConfig
REM 
REM Called By:
REM 	MAIN
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
SET "REG_SYNCTHING=HKLM\SOFTWARE\Policies\Syncthing"
REM 
REM Runtime Variables.
SET SYNCTHING_PATH=%SCRIPT_PATH%
SET CONFIG_XML="%SYNCTHING_PATH%\AppData\config.xml"
REM 
REM Always stop service before a test.
IF "%DEBUG_MODE%" == "1" net stop "Syncthing" & RD /S /Q "%SYNCTHING_PATH%\AppData"
IF NOT EXIST "%SYNCTHING_PATH%\AppData" MD "%SYNCTHING_PATH%\AppData"
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
IF NOT EXIST "%CONFIG_XML%" call :generateKeysAndConfig
IF NOT EXIST "%CONFIG_XML%" call :logAdd "[ERROR] CONFIG_XML not found. Stop." & goto :eof
REM 
SET "CONFIG_XML_BACKUP=%DATE:~-4%-%DATE:~-7,-5%-%DATE:~-10,-8%_%time:~-11,2%-%time:~-8,2%-%time:~-5,2%_config.xml"
SET "CONFIG_XML_BACKUP=%CONFIG_XML_BACKUP: =0%"
call :logAdd "[INFO] configureSyncthing: Backup config to [%CONFIG_XML_BACKUP%] ..."
copy /y %CONFIG_XML% "%SYNCTHING_PATH%\AppData\%CONFIG_XML_BACKUP%"
SET COPY_RESULT=%ERRORLEVEL%
IF NOT "%COPY_RESULT%" == "0" call :logAdd "[WARN] Backup config FAILED with code %COPY_RESULT%."
REM
call :writeSamplePoliciesToReg
REM
call :applyPolicyUpgrade
call :applyPolicyRemoteWebUi
call :applyPolicyDataTcpPort
call :addRelayListenerToConfig
REM
call :applyPolicyEnableGlobalDiscovery
call :applyPolicyEnableLocalDiscovery
call :applyPolicyEnableNAT
call :applyPolicyEnableRelays
REM
call :applyPolicyEnableTelemetry
REM
call :applyPolicyHashers
call :applyPolicyDefaultVersioning
REM
call :editConfigXml "<startBrowser>true<\/startBrowser>" "<startBrowser>false</startBrowser>"
REM
REM 	defaults: folder
call :editConfigXml "(.*<folder id=\`\` label=\`.*\` path=)\`~\`" "$1 `%SystemDrive%\Server\Sync`"
REM 
REM Perform ongoing config maintenance.
call :regQueryToVar "%REG_SYNCTHING%" "setDevicenameToComputername" "REG_SZ" "setDevicenameToComputername"
IF NOT DEFINED setDevicenameToComputername SET setDevicenameToComputername=1
IF "%setDevicenameToComputername%" == "1" call :renameLocalDevice
REM
call :applyAddDevicePolicy
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
"%SYNCTHING_EXE%" generate --no-default-folder --config="%SYNCTHING_PATH%\appdata"
call :storeLocalDeviceId
IF "%DEBUG_MODE%" == "1" copy /y "%SYNCTHING_PATH%\appdata\config.xml" "%SYNCTHING_PATH%\generateKeysAndConfig_result.xml" 
REM 
goto :eof


:storeLocalDeviceId
REM 
REM Syntax:
REM 	call :storeLocalDeviceId
REM 
REM Called By:
REM 	:generateKeysAndConfig
REM 	:renameLocalDevice
REM 
REM Global Variables.
REM 	[IN] SYNCTHING_EXE
REM 	[IN] SYNCTHING_PATH
REM 
"%SYNCTHING_EXE%" -device-id -home "%SYNCTHING_PATH%\appdata" > "%SYNCTHING_PATH%\appdata\device_id.txt"
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


:renameLocalDevice
REM 
REM Syntax:
REM 	call :renameLocalDevice
REM 
REM Global Variables.
REM 	[IN] SYNCTHING_EXE
REM 	[IN] SYNCTHING_PATH
REM 
SET LOCAL_DEVICE_ID=
IF NOT EXIST "%SYNCTHING_PATH%\appdata\device_id.txt" call :storeLocalDeviceId
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
IF NOT DEFINED %TMP_RQTV_REG_ENTRY_ENV_VAR% call :logAdd "[WARN] regQueryToVar: Failed query [%TMP_RQTV_REG_KEY%]:[%TMP_RQTV_REG_ENTRY_NAME%]:[%TMP_RQTV_REG_ENTRY_TYPE%]." & SET "REG_QUERIES_SUCCEEDED=0" &goto :eof
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


:writeSamplePoliciesToReg
REM
call :logAdd "[INFO] writeSamplePoliciesToReg"
REG ADD "%REG_SYNCTHING%\Example" /f
REM
REG ADD "%REG_SYNCTHING%\Example" /v "addDeviceHost" /t REG_SZ /d "localhost.localdomain" /f >NUL:
REG ADD "%REG_SYNCTHING%\Example" /v "addDeviceID" /t REG_SZ /d "CF6WMOG-F4RHVKW-2FTJONJ-GJ3FZQS-YW5TJVW-VDDT6ZQ-EVJ2WDP-RL4QZQO" /f >NUL:
REG ADD "%REG_SYNCTHING%\Example" /v "addDevicePort" /t REG_SZ /d "22000" /f >NUL:
REM
REG ADD "%REG_SYNCTHING%\Example" /v "dataTcpPort" /t REG_SZ /d "22000" /f >NUL:
REG ADD "%REG_SYNCTHING%\Example" /v "defaultVersioningMode" /t REG_SZ /d "none" /f >NUL:
REG ADD "%REG_SYNCTHING%\Example" /v "enableAutoUpgrade" /t REG_SZ /d "1" /f >NUL:
REM
REG ADD "%REG_SYNCTHING%\Example" /v "enableGlobalDiscovery" /t REG_SZ /d "1" /f >NUL:
REG ADD "%REG_SYNCTHING%\Example" /v "enableLocalDiscovery" /t REG_SZ /d "1" /f >NUL:
REG ADD "%REG_SYNCTHING%\Example" /v "enableNAT" /t REG_SZ /d "1" /f >NUL:
REG ADD "%REG_SYNCTHING%\Example" /v "enableRelays" /t REG_SZ /d "1" /f >NUL:
REM
REG ADD "%REG_SYNCTHING%\Example" /v "enableRemoteWebUi" /t REG_SZ /d "0" /f >NUL:
REG ADD "%REG_SYNCTHING%\Example" /v "enableTelemetry" /t REG_SZ /d "1" /f >NUL:
REG ADD "%REG_SYNCTHING%\Example" /v "hashers" /t REG_SZ /d "0" /f >NUL:
REG ADD "%REG_SYNCTHING%\Example" /v "setDevicenameToComputername" /t REG_SZ /d "1" /f >NUL:
REG ADD "%REG_SYNCTHING%\Example" /v "webUiTcpPort" /t REG_SZ /d "8384" /f >NUL:
REM
goto :eof
