DOCKER:=docker

setup-toolchain:
	$(DOCKER) build -t ppaqse-os/rtems-toolchain --file ./dockers/toolchain.dockerfile .

toolchain: setup-toolchain
	$(DOCKER) run                                     \
		--user ppaqse                                   \
		-it ppaqse-os/rtems-toolchain /bin/bash

.PHONY: setup-toolchain toolchain
