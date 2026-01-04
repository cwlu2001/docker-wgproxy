FROM alpine:3.22 AS build
RUN apk add --no-cache \
        s6-overlay wireguard-tools iptables tinyproxy dante-server && \
    sed -i 's|\[\[ $proto == -4 \]\] && cmd sysctl -q net\.ipv4\.conf\.all\.src_valid_mark=1|[[ $proto == -4 ]] \&\& [[ $(sysctl -n net.ipv4.conf.all.src_valid_mark) != 1 ]] \&\& cmd sysctl -q net.ipv4.conf.all.src_valid_mark=1|' /usr/bin/wg-quick

COPY root/ /
ENV S6_VERBOSITY=1 \
    WG_NESTED=0 \
    HTTP=1 SOCKS=1
ENTRYPOINT ["/init"]