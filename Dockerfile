FROM alpine:3.20 AS build
RUN apk add --no-cache \
    dumb-init wireguard-tools iptables tinyproxy
RUN sed -i 's|\[\[ $proto == -4 \]\] && cmd sysctl -q net\.ipv4\.conf\.all\.src_valid_mark=1|[[ $proto == -4 ]] \&\& [[ $(sysctl -n net.ipv4.conf.all.src_valid_mark) != 1 ]] \&\& cmd sysctl -q net.ipv4.conf.all.src_valid_mark=1|' /usr/bin/wg-quick
# Credit https://github.com/linuxserver/docker-wireguard/blob/57c13095b646f4d4e4c3c0508871ef9bcad8cb84/Dockerfile#L37
RUN mkdir -p /etc/tinyproxy /etc/wireguard /config /default-config
RUN rm -rf /tmp/ /etc/tinyproxy/tinyproxy.conf
COPY tinyproxy.conf /default-config/tinyproxy.conf
COPY --chmod=744 entrypoint.sh /entrypoint.sh

FROM scratch
ENV WIREGUARD_INTERFACE=wg0
EXPOSE 18888
COPY --from=build / /
ENTRYPOINT [ "/usr/bin/dumb-init", "--" ]
CMD [ "/entrypoint.sh" ]
