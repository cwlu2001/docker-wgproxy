# wgproxy
![ci] ![docker_pulls] ![docker_image_size]

[ci]: https://github.com/cwlu2001/docker-build/actions/workflows/wgproxy.yml/badge.svg
[docker_pulls]: https://img.shields.io/docker/pulls/cwlu2001/wgproxy?logo=docker
[docker_image_size]: https://img.shields.io/docker/image-size/cwlu2001/wgproxy?logo=docker


wgproxy is a self-hosted proxy server using WireGuard VPN as upstream server

## Configuration
### Wireguard
Rename your WireGuard config file to `wg0.conf` and place into `path_to_config/`

### Tinyproxy
Default setting will generated automatically in `path_to_config/` in first run

[Customize proxy settings](https://tinyproxy.github.io/)

## Start
docker compose
```yaml
services:
  wgproxy:
    image: cwlu2001/docker-wgproxy:latest
    container_name: wgproxy
    restart: unless-stopped
    ports:
      - 18888:18888/tcp
    volumes:
      - path_to_config/:/config
    cap_add:
      - NET_ADMIN
    sysctls:
      - net.ipv4.ip_forward=1
      - net.ipv4.conf.all.src_valid_mark=1
```

## Links
+ [Source](https://github.com/cwlu2001/docker-wgproxy)
+ [Build](https://github.com/cwlu2001/docker-build/actions/workflows/wgproxy.yml)
