#!/bin/sh
CONF=/etc/config/qpkg.conf
QPKG_NAME="syncthing"
QPKG_ROOT=`/sbin/getcfg $QPKG_NAME Install_Path -f ${CONF}`
DAEMON_BIN=syncthing
DAEMON=${QPKG_ROOT}/${DAEMON_BIN}
SYNCTHING_CONFIG=${QPKG_ROOT}/config.xml
APACHE_ROOT=`/sbin/getcfg SHARE_DEF defWeb -d Qweb -f /etc/config/def_share.info`
export QNAP_QPKG=$QPKG_NAME

export SHELL=/bin/sh
export LC_ALL=en_US.UTF-8
export USER=admin
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

export HOSTNAME
export QPKG_ROOT QPKG_NAME
export PATH=$QPKG_ROOT/bin:$PATH
export HOME=$QPKG_ROOT


export PIDF=/var/run/${QPKG_NAME}.pid

# 
# Notes:
# 	See log
# 		log_tool -q -v | grep "syncthing"
# 

case "$1" in
  start)
    ENABLED=$(/sbin/getcfg $QPKG_NAME Enable -u -d FALSE -f $CONF)
    if [ "$ENABLED" != "TRUE" ]; then
        echo "$QPKG_NAME is disabled."
        exit 1
    fi

	# ln -sf $QPKG_ROOT /opt/$QPKG_NAME
	cd $QPKG_ROOT

	# Set proxy
	# 	Example: PROXY_SERVER=http://192.168.1.1:8080
	PROXY_SERVER="$(cat "/etc/config/uLinux.conf" | grep "proxy server = " | sed -e "s/proxy server = //gI")"
	if [ ! -z "${PROXY_SERVER}" ]; then
		export http_proxy="${PROXY_SERVER}"
		export https_proxy="${PROXY_SERVER}"
	fi

	if [ ! -f "${SYNCTHING_CONFIG}" ]; then
		cat << EOF > "${SYNCTHING_CONFIG}"
<configuration version="36">
<gui enabled="true" tls="false" debugging="false">
	<address>0.0.0.0:8384</address>
</gui>
</configuration>
EOF
	fi

	# Disable Upgrade before launch
	# ./${QPKG_NAME} -upgrade ;

	killall ${DAEMON_BIN}
	sleep 3
	killall -9 ${DAEMON_BIN}
	sleep 1
	# export STRECHECKDBEVERY=1s
	# export STTRACE=model db scanner
	/sbin/daemon_mgr ${DAEMON_BIN} start "$DAEMON -home=$HOME -logfile=$HOME/syncthing.log &"
	/sbin/log_tool -t 0 -a "${QPKG_NAME} is started, detected proxy \"${PROXY_SERVER}\""

	exit 0
    ;;

  stop)

	echo "Stop services: ${QPKG_NAME}"
	/sbin/daemon_mgr ${DAEMON_BIN} stop "$DAEMON"
	killall ${DAEMON_BIN}
	sleep 3
	/sbin/log_tool -t 0 -a "${QPKG_NAME} server is stopped"

	# rm -rf /opt/$QPKG_NAME
	exit 0
    ;;

  restart)
    $0 stop
    $0 start
    exit 0
    ;;

  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
esac

exit 0
