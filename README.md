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
Default setting will generated automatically in `path_to_config/` in first time start

Customize proxy settings? [Link](https://tinyproxy.github.io/)

## Start
via `docker compose`

Use the following command with [compose.yaml](https://github.com/cwlu2001/docker-wgproxy/blob/main/compose.yaml)

```bash
docker compose up -d
```

## Links
+ [Source](https://github.com/cwlu2001/docker-wgproxy)
+ [Build](https://github.com/cwlu2001/docker-build/actions/workflows/wgproxy.yml)
