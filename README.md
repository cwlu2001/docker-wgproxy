# wgproxy
![ci] ![docker_pulls] ![docker_image_size]

[ci]: https://github.com/cwlu2001/docker-build/actions/workflows/wgproxy.yml/badge.svg
[docker_pulls]: https://img.shields.io/docker/pulls/cwlu2001/wgproxy?logo=docker
[docker_image_size]: https://img.shields.io/docker/image-size/cwlu2001/wgproxy?logo=docker


wgproxy is a HTTP/SOCKS + WireGuard/AmneziaWG proxy server

## Configuration
### Proxy
#### [Tinyproxy](https://tinyproxy.github.io/)
Mount point: `/config/tinyproxy.conf`

#### [Dante](https://www.inet.no/dante/doc/1.4.x/config/index.html)
Mount point: `/config/sockd.conf`


## Start
docker compose
```yaml
services:
  wgproxy:
    image: cwlu2001/wgproxy:latest
    container_name: wgproxy
    restart: unless-stopped
    ports:
      - 1080:1080     # SOCKS
      - 1080:1080/udp # SOCKS
#      - 8888:8888     # HTTP
    volumes:
      - path_to_cfg_file:/config/wg0.conf:ro
    cap_add:
      - NET_ADMIN
    sysctls:
      - net.ipv4.ip_forward=1
      - net.ipv4.conf.all.src_valid_mark=1
    devices:
      - /dev/net/tun

```

## Options
| Variable | Default | Options | Description |
| --- | --- | --- | --- |
| `WIREGUARD` | `wireguard` | `wireguard`, `amneziawg` | Wireguard implementation to use |
| `HTTP` | `false` | `true`, `false` | Enable HTTP proxy |
| `SOCKS` | `true` | `true`, `false` | Enable SOCKS proxy |

## Links
+ [Source](https://github.com/cwlu2001/docker-wgproxy)
+ [Build](https://github.com/cwlu2001/docker-build/actions/workflows/wgproxy.yml)
