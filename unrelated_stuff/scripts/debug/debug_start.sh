#!/bin/sh
PATH=$PATH:/home/builduser/syncthing
# 
INSTANCE_ID="${1}"
if [ -z ${INSTANCE_ID} ]; then echo "[ERROR] Parameter #1 INSTANCE_ID missing."; exit 99; fi;
# 
export STTRACE="fs model scanner walk walkfs"
# 
# Clear database
echo "[INFO] Clearing database ..."
rm -rf "/root/.config/syncthing${INSTANCE_ID}/index-v0.14.0.db"
#
CONFIG_DIR="/root/.config/syncthing${INSTANCE_ID}"
CONFIG_XML="${CONFIG_DIR}/config.xml"
#
if [ ! -f "${CONFIG_XML}" ]; then
	echo "[INFO] Generating new config ..."
	./syncthing -generate="${CONFIG_DIR}"
	#
	## Remove default shared folder
	sed -i -e "/<folder.*>/,/<\/folder>/d" "${CONFIG_XML}"
fi
# 
# Preconfigure test instance.
echo "[INFO] Writing config ..."
# 
## WebGUI Port, Data Port, Do not auto-upgrade, Do not start browser
sed -i -e "s/<address>127\.0\.0\.1:8384<\/address>/<address>0.0.0.0:800${INSTANCE_ID}<\/address>/g" "${CONFIG_XML}"
sed -i -e "s/<listenAddress>.*<\/listenAddress>/<listenAddress>tcp4:\/\/:801${INSTANCE_ID}<\/listenAddress>/g" "${CONFIG_XML}"
sed -i -e "s/<autoUpgradeIntervalH>12<\/autoUpgradeIntervalH>/<autoUpgradeIntervalH>0<\/autoUpgradeIntervalH>/g" "${CONFIG_XML}"
sed -i -e "s/<startBrowser>true<\/startBrowser>/<startBrowser>false<\/startBrowser>/g" "${CONFIG_XML}"
# 
## Global Discovery=0, Local discovery=1, Relays=0, NAT Traversal=0
sed -i -e "s/<relaysEnabled>true<\/relaysEnabled>/<relaysEnabled>false<\/relaysEnabled>/g" "${CONFIG_XML}"
sed -i -e "s/<natEnabled>true<\/natEnabled>/<natEnabled>false<\/natEnabled>/g" "${CONFIG_XML}"
sed -i -e "s/<globalAnnounceEnabled>true<\/globalAnnounceEnabled>/<globalAnnounceEnabled>false<\/globalAnnounceEnabled>/g" "${CONFIG_XML}"
sed -i -e "s/<localAnnounceEnabled>false<\/localAnnounceEnabled>/<localAnnounceEnabled>true<\/localAnnounceEnabled>/g" "${CONFIG_XML}"
# 
## Crash Reporting
sed -i -e "s/<crashReportingEnabled>.*<\/crashReportingEnabled>/<crashReportingEnabled>false<\/crashReportingEnabled>/g" "${CONFIG_XML}"
sed -i -e "s/<crashReportingURL>.*<\/crashReportingURL>/<crashReportingURL>http:\/\/localhost\/crash.syncthing.net\/newcrash<\/crashReportingURL>/g" "${CONFIG_XML}"
# 
## Usage Reporting
sed -i -e "s/<urAccepted>.*<\/urAccepted>/<urAccepted>-1<\/urAccepted>/g" "${CONFIG_XML}"
sed -i -e "s/<urSeen>.*<\/urSeen>/<urSeen>3<\/urSeen>/g" "${CONFIG_XML}"
sed -i -e "s/<urURL>.*<\/urURL>/<urURL>http:\/\/localhost\/data.syncthing.net\/newdata<\/urURL>/g" "${CONFIG_XML}"
sed -i -e "s/<releasesURL>.*<\/releasesURL>/<releasesURL>http:\/\/localhost\/upgrades.syncthing.net\/meta.json<\/releasesURL>/g" "${CONFIG_XML}"
# 
## Default Folder Path
sed -i -e "s/<defaultFolderPath>~<\/defaultFolderPath>/<defaultFolderPath>\/root\/Sync${INSTANCE_ID}<\/defaultFolderPath>/g" "${CONFIG_XML}"
# 
# Start binary.
./syncthing -home="${CONFIG_DIR}"
#
echo "[INFO] Done."
exit 0
