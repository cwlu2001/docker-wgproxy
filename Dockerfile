FROM alpine:3.20

ENV WIREGUARD_INTERFACE=wg0
ENV PROXY_UID=9999
ENV PROXY_GID=9999
ENV PROXY_PORT=8888
ENV PROXY_LOGLEVEL=Notice

RUN apk add --no-cache \
      wireguard-tools iptables tinyproxy && \
    sed -i 's|\[\[ $proto == -4 \]\] && cmd sysctl -q net\.ipv4\.conf\.all\.src_valid_mark=1|[[ $proto == -4 ]] \&\& [[ $(sysctl -n net.ipv4.conf.all.src_valid_mark) != 1 ]] \&\& cmd sysctl -q net.ipv4.conf.all.src_valid_mark=1|' /usr/bin/wg-quick && \
    mkdir -p /etc/tinyproxy

COPY --chmod=744 entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
