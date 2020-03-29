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
REM 
call :setupSyncthing
REM 
REM End of Script.
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
REM Runtime Variables.
SET SYNCTHING_PATH=%SCRIPT_PATH%
SET CONFIG_XML="%SYNCTHING_PATH%\AppData\config.xml"
SET CONFIG_XML_TMP="%SYNCTHING_PATH%\AppData\config.xml.tmp"
REM 
REM Detect a fresh installation.
IF NOT EXIST "%CONFIG_XML%" call :generateKeysAndConfig & call :applyFirstTimeConfig & goto :eof
REM 
REM Detect an empty installation.
SET USER_FOLDERS_PRESENT=0
TYPE %CONFIG_XML% 2>NUL: | findstr /I /R /C:".*<folder id=\".*\" label=\".*\" .*>.*" | findstr /V /I /R /C:".*<folder id=\".*\" label=\"Default Folder\" .*>.*" 1>NUL: && SET USER_FOLDERS_PRESENT=1
REM 
call :logAdd "[INFO] configureSyncthing: Detected an existing installation. Will perform upgrade."
REM 
REM Note:
REM 	Windows Installer STOPS the service prior to starting this script if we install another MSI version as the one that is already installed.
REM 	Windows Installer DOES NOT STOP the service prior to starting this script if we install the SAME MSI version as the one that is already installed.
SET QUEUE_SERVICE_RESTART=0
sc query Syncthing | find /i "STATE" | find /i "RUNNING" 1> NUL: && (SET QUEUE_SERVICE_RESTART=1& net stop "Syncthing")
REM 
REM Reset config to defaults if an empty config was identified.
call :logAdd "[INFO] configureSyncthing: USER_FOLDERS_PRESENT=[%USER_FOLDERS_PRESENT%]"
IF "%USER_FOLDERS_PRESENT%" == "0" call :applyFirstTimeConfig
REM 
REM Perform ongoing config maintenance.
sed.exe -e "s/<hashers>0<\/hashers>/<hashers>1<\/hashers>/g" %CONFIG_XML% > %CONFIG_XML_TMP%
move /y %CONFIG_XML_TMP% %CONFIG_XML%
REM 
IF "%QUEUE_SERVICE_RESTART%" == "1" call :logAdd "[INFO] Restarting previously running service ..." & sc start "Syncthing" | find /i "STATE"
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
REM 
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
REM 	[IN] CONFIG_XML_TMP
REM 
REM Adjust syncthing "config.xml".
call :logAdd "[INFO] applyFirstTimeConfig: Adjusting [config.xml] ..."
REM 
REM 	WebGUI Port, Data Port, Do not auto-upgrade, Do not start browser
sed.exe -e "s/<address>127\.0\.0\.1:8384<\/address>/<address>127.0.0.1:8384<\/address>/g" -e "s/<listenAddress>.*<\/listenAddress>/<listenAddress>tcp4:\/\/:22000<\/listenAddress>/g" -e "s/<autoUpgradeIntervalH>12<\/autoUpgradeIntervalH>/<autoUpgradeIntervalH>0<\/autoUpgradeIntervalH>/g" -e "s/<startBrowser>true<\/startBrowser>/<startBrowser>false<\/startBrowser>/g" %CONFIG_XML% > %CONFIG_XML_TMP%
move /y %CONFIG_XML_TMP% %CONFIG_XML% 1> NUL:
REM 
REM 	Global Discovery=0, Local discovery=1, Relays=0, NAT Traversal=0
sed.exe -e "s/<relaysEnabled>true<\/relaysEnabled>/<relaysEnabled>false<\/relaysEnabled>/g" -e "s/<natEnabled>true<\/natEnabled>/<natEnabled>false<\/natEnabled>/g" -e "s/<globalAnnounceEnabled>true<\/globalAnnounceEnabled>/<globalAnnounceEnabled>false<\/globalAnnounceEnabled>/g" -e "s/<localAnnounceEnabled>false<\/localAnnounceEnabled>/<localAnnounceEnabled>true<\/localAnnounceEnabled>/g" %CONFIG_XML% > %CONFIG_XML_TMP%
move /y %CONFIG_XML_TMP% %CONFIG_XML% 1> NUL:
REM 
REM 	Crash Reporting
sed.exe -e "s/<crashReportingEnabled>.*<\/crashReportingEnabled>/<crashReportingEnabled>false<\/crashReportingEnabled>/g" -e "s/<crashReportingURL>.*<\/crashReportingURL>/<crashReportingURL>http:\/\/localhost\/crash.syncthing.net\/newcrash<\/crashReportingURL>/g" %CONFIG_XML% > %CONFIG_XML_TMP%
move /y %CONFIG_XML_TMP% %CONFIG_XML% 1> NUL:
REM 
REM 	Usage Reporting
sed.exe -e "s/<urAccepted>.*<\/urAccepted>/<urAccepted>-1<\/urAccepted>/g" -e "s/<urSeen>.*<\/urSeen>/<urSeen>3<\/urSeen>/g" -e "s/<urURL>.*<\/urURL>/<urURL>http:\/\/localhost\/data.syncthing.net\/newdata<\/urURL>/g" -e "s/<releasesURL>.*<\/releasesURL>/<releasesURL>http:\/\/localhost\/upgrades.syncthing.net\/meta.json<\/releasesURL>/g" %CONFIG_XML% > %CONFIG_XML_TMP%
move /y %CONFIG_XML_TMP% %CONFIG_XML% 1> NUL:
REM 
REM 	Remove Default Shared Folder
sed.exe -e "/<folder.*>/,/<\/folder>/d" %CONFIG_XML% > %CONFIG_XML_TMP%
move /y %CONFIG_XML_TMP% %CONFIG_XML% 1> NUL:
REM 
REM   Default Folder Path
sed.exe -e "s/<defaultFolderPath>~<\/defaultFolderPath>/<defaultFolderPath>%SystemDrive%\\Server\\Sync<\/defaultFolderPath>/g" %CONFIG_XML% > %CONFIG_XML_TMP%
move /y %CONFIG_XML_TMP% %CONFIG_XML% 
REM 
REM   Retrieving server info from registry.
call :retrieveServerInfo
REM 
IF DEFINED PRESET_SYNC_SERVER_DNS IF DEFINED PRESET_SYNC_SERVER_PORT IF DEFINED PRESET_SYNC_SERVER_DEVICE_ID call :addDeviceToConfig "%PRESET_SYNC_SERVER_DEVICE_ID%" "%PRESET_SYNC_SERVER_DNS%" "tcp4://%PRESET_SYNC_SERVER_DNS%:%PRESET_SYNC_SERVER_PORT%"
REM 
goto :eof


:retrieveServerInfo
REM 
REM Syntax:
REM 	call :retrieveServerInfo
REM 
REM Called By:
REM 	:applyFirstTimeConfig
REM 
REM Global Variables.
REM 	[OUT] MSI_PACKAGE_SUFFIX
REM 	[OUT] PRESET_SYNC_SERVER_DEVICE_ID
REM 	[OUT] PRESET_SYNC_SERVER_DNS
REM 	[OUT] PRESET_SYNC_SERVER_PORT
REM 
SET MSI_PACKAGE_SUFFIX=
SET PRESET_SYNC_SERVER_DEVICE_ID=
SET PRESET_SYNC_SERVER_DNS=
SET PRESET_SYNC_SERVER_PORT=
REM 
REM WMI approach:
FOR /F "tokens=*" %%A IN ('wmic path win32_process where Caption^="msiexec.exe" get Commandline /value 2^>NUL: ^| find /i "=" ^| find "__" ^| find /i "msiexec.exe" ^| find /i "\Syncthing" ^| find /i ".msi" ^| sed.exe -e "s/.*Syncthing.*__//gI" -e "s/\.msi//gI" -e "s/ //g" -e "s/\""//g"') DO SET MSI_PACKAGE_SUFFIX=%%A
REM 
REM Registry approach:
REM 	FOR /F "tokens=3" %%A IN ('REG QUERY "HKLM\SOFTWARE\Classes\Installer\Products" /f "PackageName" /s /e 2^>NUL: ^| find /i "Syncthing" ^| sed.exe -e "s/Syncthing.*__//gI" -e "s/\.msi//gI"') DO SET MSI_PACKAGE_SUFFIX=%%A
REM 
IF NOT DEFINED MSI_PACKAGE_SUFFIX goto :eof
call :logAdd "[INFO] retrieveServerInfoFromRegistry: MSI_PACKAGE_SUFFIX=[%MSI_PACKAGE_SUFFIX%]"
REM 
FOR /F "tokens=1 delims=+" %%A IN ('echo %MSI_PACKAGE_SUFFIX%') DO SET PRESET_SYNC_SERVER_DEVICE_ID=%%A
IF NOT DEFINED PRESET_SYNC_SERVER_DEVICE_ID goto :eof
call :logAdd "[INFO] retrieveServerInfoFromRegistry: PRESET_SYNC_SERVER_DEVICE_ID=[%PRESET_SYNC_SERVER_DEVICE_ID%]"
REM 
FOR /F "tokens=2 delims=+" %%A IN ('echo %MSI_PACKAGE_SUFFIX%') DO SET PRESET_SYNC_SERVER_DNS=%%A
IF NOT DEFINED PRESET_SYNC_SERVER_DNS goto :eof
call :logAdd "[INFO] retrieveServerInfoFromRegistry: PRESET_SYNC_SERVER_DNS=[%PRESET_SYNC_SERVER_DNS%]"
REM 
FOR /F "tokens=3 delims=+" %%A IN ('echo %MSI_PACKAGE_SUFFIX%') DO SET PRESET_SYNC_SERVER_PORT=%%A
IF NOT DEFINED PRESET_SYNC_SERVER_PORT goto :eof
call :logAdd "[INFO] retrieveServerInfoFromRegistry: PRESET_SYNC_SERVER_PORT=[%PRESET_SYNC_SERVER_PORT%]"
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
REM 	[IN] CONFIG_XML_TMP
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
IF "%TMP_ADTC_DEVICE_ALREADY_PRESENT%" == "1" call :logAdd "[WARN] Device [%TMP_ADTC_SERVER_DEVICE_ID%] already present in [config.xml]. Skipping ..." & goto :eof
REM 
REM Add device to config.
call :logAdd "[INFO] addDeviceToConfig: Adding device to config [%TMP_ADTC_SERVER_DEVICE_ID%], [%TMP_ADTC_SERVER_ADDR%] ..."
sed.exe -e "/.*<gui.*>.*/i <device id=\"%TMP_ADTC_SERVER_DEVICE_ID%\" name=\"%TMP_ADTC_SERVER_NAME%\" compression=\"metadata\" introducer=\"false\" skipIntroductionRemovals=\"false\" introducedBy=\"\"><address>%TMP_ADTC_SERVER_ADDR%</address></device>" %CONFIG_XML% > %CONFIG_XML_TMP%
move /y %CONFIG_XML_TMP% %CONFIG_XML%
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
REM 
call :logAdd "[INFO] setupSyncthing: Configuration done."
REM 
REM Delete log file on success.
IF "%CLEAN_LOG_AFTER_SUCCESSFUL_INSTALL%" == "1" DEL /F "%LOGFILE%" 2> NUL:
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
