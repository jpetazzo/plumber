all:
	docker build -t placeholder - < Dockerfile.placeholder
	docker build -t pw2 .
	docker kill pipes x1 x2 || true
	docker rm pipes x1 x2 || true
	docker run --name pipes -d placeholder
	docker run --net container:pipes --privileged -v /proc:/hostproc -v /var/run/docker.sock:/var/run/docker.sock -v $(shell which docker):/usr/local/bin/docker pw2 /run.sh init
	docker run --net container:pipes --privileged -v /proc:/hostproc -v /var/run/docker.sock:/var/run/docker.sock -v $(shell which docker):/usr/local/bin/docker pw2 /run.sh add x1 10.11.12.1/24
	docker run --net container:pipes --privileged -v /proc:/hostproc -v /var/run/docker.sock:/var/run/docker.sock -v $(shell which docker):/usr/local/bin/docker pw2 /run.sh add x2 10.11.12.2/24
	@echo You should now run:
	@echo docker run --net container:x1 ubuntu ping 10.11.12.2
	@echo docker run --net container:x2 ubuntu ip addr ls

test:
	docker run --net container:x1 ubuntu sh -c "sleep 1 ; ip addr ls dev eth1"
	docker run --net container:x2 ubuntu sh -c "sleep 1 ; ip addr ls dev eth1"
