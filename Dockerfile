FROM golang:1.25-alpine AS builder
RUN apk add \
    git build-base make linux-headers


FROM builder AS wireguard
WORKDIR /root
RUN git clone https://github.com/WireGuard/wireguard-go go && \
    git clone https://github.com/WireGuard/wireguard-tools tools
RUN cd /root/go && \
    make 
RUN cd /root/tools/src && \
    make
RUN cd /root && \
    mkdir -p /root/bin && \
    cp go/wireguard-go bin/wireguard-go && \
    cp tools/src/wg bin/wg && \
    cp tools/src/wg-quick/linux.bash bin/wg-quick && \
    sed -i 's|\[\[ $proto == -4 \]\] && cmd sysctl -q net\.ipv4\.conf\.all\.src_valid_mark=1|[[ $proto == -4 ]] \&\& [[ $(sysctl -n net.ipv4.conf.all.src_valid_mark) != 1 ]] \&\& cmd sysctl -q net.ipv4.conf.all.src_valid_mark=1|' bin/wg-quick


FROM builder AS amnezia
WORKDIR /root
RUN git clone https://github.com/amnezia-vpn/amneziawg-go go && \
    git clone https://github.com/amnezia-vpn/amneziawg-tools tools
RUN cd /root/go && \
    make 
RUN cd /root/tools/src && \
    make
RUN cd /root && \
    mkdir -p /root/bin && \
    cp go/amneziawg-go bin/amneziawg-go && \
    cp tools/src/wg bin/awg && \
    cp tools/src/wg-quick/linux.bash bin/awg-quick && \
    sed -i 's|\[\[ $proto == -4 \]\] && cmd sysctl -q net\.ipv4\.conf\.all\.src_valid_mark=1|[[ $proto == -4 ]] \&\& [[ $(sysctl -n net.ipv4.conf.all.src_valid_mark) != 1 ]] \&\& cmd sysctl -q net.ipv4.conf.all.src_valid_mark=1|' bin/awg-quick


FROM alpine:3.22
RUN apk add --no-cache \
        tini bash openresolv iproute2 iptables tinyproxy dante-server \
    && \
    mkdir -p \
        /config \
        /etc/wireguard \
        /etc/amnezia/amneziawg \
    && \
    ln -s /config/wg0.conf /etc/wireguard/wg0.conf && \
    ln -s /config/wg0.conf /etc/amnezia/amneziawg/wg0.conf
COPY --from=wireguard /root/bin /usr/local/bin
COPY --from=amnezia /root/bin /usr/local/bin
COPY tinyproxy.conf sockd.conf /config/
COPY --chmod=744 entrypoint.sh /entrypoint.sh
EXPOSE 8888 1080 1080/udp
ENTRYPOINT [ "/sbin/tini", "--", "/entrypoint.sh" ]
