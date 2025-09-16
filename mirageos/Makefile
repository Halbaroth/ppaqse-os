DOCKER:=docker

all: build

setup:
	$(DOCKER) build -t ppaqse-os/mirageos --file ./Dockerfile .
	mkdir -p ./dist
	chmod 777 ./dist

shell: setup
	$(DOCKER) run --user docker -it ppaqse-os/mirageos sh

build-hello_world: setup
	$(DOCKER) run --user docker -v ./dist:/dist ppaqse-os/mirageos ./examples/hello_world/build.sh

build-watchdog: setup
	$(DOCKER) run --user docker -v ./dist:/dist ppaqse-os/mirageos ./examples/watchdog/build.sh

build: build-hello_world build-watchdog

clean:
	yes

.PHONY: all setup shell build build-hello_world build-watchdog clean
