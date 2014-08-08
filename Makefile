all: build clean setup test

build:
	docker build -q -t placeholder - < Dockerfile.placeholder
	docker build -q -t plumber .

clean:
	docker kill pipes x1 x2 || true
	docker rm pipes x1 x2 || true

setup:
	docker run --name pipes -d placeholder
	docker run --net container:pipes --privileged -v /proc:/hostproc -v /var/run/docker.sock:/var/run/docker.sock -v $(shell which docker):/usr/local/bin/docker plumber init
	docker run --net container:pipes --privileged -v /proc:/hostproc -v /var/run/docker.sock:/var/run/docker.sock -v $(shell which docker):/usr/local/bin/docker plumber add x1 10.11.12.1/24
	docker run --net container:pipes --privileged -v /proc:/hostproc -v /var/run/docker.sock:/var/run/docker.sock -v $(shell which docker):/usr/local/bin/docker plumber add x2 10.11.12.2/24

test:
	docker run --net container:x1 ubuntu ip addr ls dev eth1
	docker run --net container:x2 ubuntu ip addr ls dev eth1
	docker run --net container:x1 ubuntu ping 10.11.12.2
	docker run --net container:x2 ubuntu ip addr ls
