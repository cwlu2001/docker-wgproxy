#!/bin/sh

LOCAL_IP=$(hostname -i)
WIREGUARD_IMPLT=${WIREGUARD_IMPLT:-wireguard}
WIREGUARD_INTF=wg0
WIREGUARD_CFG=/config/$WIREGUARD_INTF.conf
HTTP=${HTTP:-false}
SOCKS=${SOCKS:-true}

__echo() {
    YELLOW="\033[1;33m"
    NC="\033[0m"
    echo -e "${YELLOW}[#] $@${NC}"
}

__start_wg() {
    __echo Starting $WIREGUARD_IMPLT
    if [[ ! -f $WIREGUARD_CFG ]]; then
        __echo No Wireguard config dected, terminating ...
        exit 1
    fi
    case "$WIREGUARD_IMPLT" in
        wireguard)
            wg-quick up $WIREGUARD_INTF
        ;;
        amnezia)
            awg-quick up $WIREGUARD_INTF
        ;;
    esac
    ip rule add from $LOCAL_IP lookup main
}
__stop_wg() {
    __echo Stopping $WIREGUARD_IMPLT
    case "$WIREGUARD_IMPLT" in
        wireguard)
            wg-quick up $WIREGUARD_INTF > /dev/null 2>&1
        ;;
        amnezia)
            awg-quick down $WIREGUARD_INTF > /dev/null 2>&1
        ;;
    esac
    ip rule delete from $LOCAL_IP lookup main
}

__start_proxy() {
    if [[ "$HTTP" == "true" ]]; then
        __echo Starting HTTP proxy
        tinyproxy -d -c /config/tinyproxy.conf &
    fi
    if [[ "$SOCKS" == "true" ]]; then
        __echo Starting SOCKS proxy
        sockd -f /config/sockd.conf &
    fi
}

trap __stop_wg SIGTERM SIGINT
__start_wg
__start_proxy
sleep infinity
