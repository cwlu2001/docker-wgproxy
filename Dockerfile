FROM alpine:3.22 AS build
RUN apk add --no-cache \
        tini wireguard-tools iptables tinyproxy && \
    sed -i 's|\[\[ $proto == -4 \]\] && cmd sysctl -q net\.ipv4\.conf\.all\.src_valid_mark=1|[[ $proto == -4 ]] \&\& [[ $(sysctl -n net.ipv4.conf.all.src_valid_mark) != 1 ]] \&\& cmd sysctl -q net.ipv4.conf.all.src_valid_mark=1|' /usr/bin/wg-quick && \
    # Credit https://github.com/linuxserver/docker-wireguard/blob/57c13095b646f4d4e4c3c0508871ef9bcad8cb84/Dockerfile#L37
    mkdir -p /etc/tinyproxy /etc/wireguard /config /default-config && \
    rm -rf /tmp/ /etc/tinyproxy/tinyproxy.conf
COPY tinyproxy.conf /default-config/tinyproxy.conf
COPY --chmod=744 entrypoint.sh /entrypoint.sh
ENV WIREGUARD_INTERFACE=wg0
EXPOSE 18888
ENTRYPOINT [ "/sbin/tini", "--" ]
CMD [ "/entrypoint.sh" ]
