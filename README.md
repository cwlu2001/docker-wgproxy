# wgproxy
![ci] ![docker_pulls] ![docker_image_size]

[ci]: https://github.com/cwlu2001/docker-build/actions/workflows/wgproxy.yml/badge.svg
[docker_pulls]: https://img.shields.io/docker/pulls/cwlu2001/wgproxy?logo=docker
[docker_image_size]: https://img.shields.io/docker/image-size/cwlu2001/wgproxy?logo=docker


A HTTP & SOCKS proxy server in standalone/nested Wireguard

## Start
<details>
<summary> Normal, single point Wiregaurd </summary>

Mount `wg0.conf` into `config/`
```yaml
services:
  wgproxy:
    image: cwlu2001/wgproxy:latest
    container_name: wgproxy
    restart: unless-stopped
    ports:
      - 8888:8888
      - 1080:1080
    volumes:
      - /path/to/wg0.conf:/config/wg0.conf
    cap_add:
      - NET_ADMIN
    sysctls:
      - net.ipv4.ip_forward=1
      - net.ipv4.conf.all.src_valid_mark=1
```
</details>

<details>
<summary>Nested Wireguard </summary>

> TLDR: HTTP/SOCKS proxy → wg1 (inner) → wg0 (outer) → Internet

Mount `wg0.conf`, `wg1.conf` into `config/`

```yaml
services:
  wgproxy:
    image: cwlu2001/wgproxy:latest
    container_name: wgproxy
    restart: unless-stopped
    ports:
      - 8888:8888
      - 1080:1080
    volumes:
      - ./config:/config/
    cap_add:
      - NET_ADMIN
    environment:
      - WG_NESTED=1 # Enable nested wireguard
    sysctls:
      - net.ipv4.ip_forward=1
      - net.ipv4.conf.all.src_valid_mark=1
```

</details>

## Environment
| Key | Default | Options | Description |
| :---: | :---: | :---: | :---: |
| `HTTP` | `1` | `1`, `0` | Enable HTTP proxy |
| `SOCKS` | `1` | `1`, `0` | Enable SOCKS proxy |
| `WG_NESTED` | `0` | `1`, `0` | Enable nested Wireguard |



## Links
+ [Source](https://github.com/cwlu2001/docker-wgproxy)
+ [Build](https://github.com/cwlu2001/docker-build/actions/workflows/wgproxy.yml)