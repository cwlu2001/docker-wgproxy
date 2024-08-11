#!/bin/bash

LOCAL_IP_ADDRESS=$(ip route get 1.1.1.1 | sed -n 's|.*src \([0-9.]\+\).*|\1|p')
WIREGUARD_INTERFACE=${WIREGUARD_INTERFACE}
PROXY_UID=${PROXY_UID}
PROXY_GID=${PROXY_GID}
PROXY_PORT=${PROXY_PORT}
PROXY_LOGLEVEL=${PROXY_LOGLEVEL}

__echo() {
    GRAY="\033[1;30m"
    NC="\033[0m"
    echo -e "${GRAY}[#] $@${NC}"
}

__cmd() {
    $@
}

__exec() {
    exec $@
}

__start_wg() {
    __echo Starting Wireguard
    __cmd /usr/bin/wg-quick up $WIREGUARD_INTERFACE
    __cmd ip rule add from $LOCAL_IP_ADDRESS lookup main
    __echo Interface Info
    __cmd /usr/bin/wg
    __echo Wireguard Started
}

__start_tp() {
    __echo Starting Tinyproxy
    __exec /usr/bin/tinyproxy -d -c /etc/tinyproxy/tinyproxy.conf
}

cat << EOF > /etc/tinyproxy/tinyproxy.conf
User $PROXY_UID
Group $PROXY_GID
Port $PROXY_PORT
Allow 0.0.0.0/0
Timeout 300
LogLevel $PROXY_LOGLEVEL
MaxClients 100
EOF

__start_wg
__start_tp

