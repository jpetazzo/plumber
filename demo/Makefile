all:
	docker build -t pw2 .
	docker kill x0 x1 x2 || true
	docker rm x0 x1 x2 || true
	docker run --name x0 --privileged -t -d -i -v /proc:/hostproc -v /var/run/docker.sock:/var/run/docker.sock -v $(shell which docker):/usr/local/bin/docker pw2 /run.sh x1 10.11.12.1/24 x2 10.11.12.2/24
	@echo You should now run:
	@echo docker run --net container:x1 ubuntu ping 10.11.12.2
	@echo docker run --net container:x2 ubuntu ip addr ls

test:
	docker run --net container:x1 ubuntu ip addr ls dev eth1
	docker run --net container:x2 ubuntu ip addr ls dev eth1
