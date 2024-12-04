#!/bin/sh

LOCAL_IP_ADDRESS=$(ip route get 1.1.1.1 | sed -n 's|.*src \([0-9.]\+\).*|\1|p')
WIREGUARD_INTERFACE=${WIREGUARD_INTERFACE}
WIREGUARD_SYSTEM_CONFIG_FILE=/etc/wireguard/$WIREGUARD_INTERFACE.conf
WIREGUARD_USER_CONFIG_FILE=/config/$WIREGUARD_INTERFACE.conf
PROXY_SYSTEM_CONFIG_FILE=/etc/tinyproxy/tinyproxy.conf
PROXY_USER_CONFIG_FILE=/config/tinyproxy.conf
PROXY_PID=""

__echo() {
    YELLOW="\033[1;33m"
    NC="\033[0m"
    echo -e "${YELLOW}[#] $@${NC}"
}

__start_wg() {
    __echo Starting Wireguard
    if  [ ! -f $WIREGUARD_SYSTEM_CONFIG_FILE ] && [ ! -f $WIREGUARD_USER_CONFIG_FILE ]; then
        __echo No Wireguard config dected, terminating ...
        exit 0
    elif [ ! -f $WIREGUARD_SYSTEM_CONFIG_FILE ] ; then
        ln -s $WIREGUARD_USER_CONFIG_FILE $WIREGUARD_SYSTEM_CONFIG_FILE
    fi
    wg-quick up $WIREGUARD_INTERFACE
    ip rule add from $LOCAL_IP_ADDRESS lookup main
    ping -4 -c 2 -W 2 1.1.1.1 > /dev/null
    wg
}

__start_tp() {
    __echo Starting Tinyproxy
    if [ ! -f $PROXY_SYSTEM_CONFIG_FILE ]; then
        if  [ -f $PROXY_USER_CONFIG_FILE ]; then
            __echo Using user defined config
        else
            __echo No config dected, using default ...
            PROXY_USER_CONFIG_FILE=/default-config/tinyproxy.conf
        fi
        ln -s $PROXY_USER_CONFIG_FILE $PROXY_SYSTEM_CONFIG_FILE
    fi
    tinyproxy -d
}

__stop_wg() {
    __echo Stopping Wireguard
    wg-quick down $WIREGUARD_INTERFACE > /dev/null 2>&1
    ip rule delete from $LOCAL_IP_ADDRESS lookup main
}


trap __stop_wg SIGTERM SIGINT
__start_wg
__start_tp
