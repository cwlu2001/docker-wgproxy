dev:
	docker run \
		--rm -it \
		--name docker-wgproxy \
		--cap-add NET_ADMIN \
		--cap-add SYS_MODULE \
		-v ./wg0.conf:/etc/wireguard/wg0.conf:ro \
		-v /lib/modules:/lib/modules:ro \
		--sysctl net.ipv4.ip_forward=1 \
		--sysctl net.ipv4.conf.all.src_valid_mark=1 \
		alpine:3 sh

build:
	docker buildx build -t cwlu2001/docker-wgproxy:dev .
	docker image prune -f

run:
	docker run \
			--rm -it \
			--name docker-wgproxy \
			--cap-add NET_ADMIN \
			-p 8888:8888 \
			-v ./wg0.conf:/etc/wireguard/wg0.conf \
			--sysctl net.ipv4.ip_forward=1 \
			--sysctl net.ipv4.conf.all.src_valid_mark=1 \
			cwlu2001/docker-wgproxy:dev

run-d:
	docker run \
			--rm -d \
			--name docker-wgproxy \
			--cap-add NET_ADMIN \
			-p 8888:8888 \
			-v ./wg0.conf:/etc/wireguard/wg0.conf \
			--sysctl net.ipv4.ip_forward=1 \
			--sysctl net.ipv4.conf.all.src_valid_mark=1 \
			-e PROXY_LOGLEVEL=Notice \
			cwlu2001/docker-wgproxy:dev

exec:
	docker exec -it docker-wgproxy bash

stop:
	docker stop -t 1 docker-wgproxy

top htop:
	docker top docker-wgproxy

log logs:
	docker logs -f docker-wgproxy
