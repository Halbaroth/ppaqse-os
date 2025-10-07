DOCKER:=docker

all: build

setup-toolchain:
	$(DOCKER) build -t ppaqse-os/mirageos-toolchain --file ./dockers/toolchain .
	mkdir -p ./unikernels
	chmod 777 ./unikernels

setup-memtrace-viewer:
	$(DOCKER) build -t ppaqse-os/mirageos-memtrace-viewer --file ./dockers/memtrace-viewer .

toolchain: setup-toolchain
	$(DOCKER) run --user opam -it ppaqse-os/mirageos-toolchain /bin/bash

memtrace-viewer: setup-memtrace-viewer
	$(DOCKER) run

build-hello_world: setup-toolchain
	$(DOCKER) run --user opam -v ./unikernels:/unikernels ppaqse-os/mirageos-toolchain ./examples/hello_world/build.sh

build-watchdog: setup-toolchain
	$(DOCKER) run --user docker -v ./unikernels:/unikernels ppaqse-os/mirageos-toolchain ./examples/watchdog/build.sh

build-memtrace: setup-toolchain
	$(DOCKER) run --user opam -v ./unikernels:/unikernels ppaqse-os/mirageos-toolchain ./examples/memtrace/build.sh

build: build-hello_world build-watchdog build-memtrace

clean:
	yes

.PHONY: all setup shell build build-hello_world build-watchdog build-memtrace clean
