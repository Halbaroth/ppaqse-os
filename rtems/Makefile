DOCKER:=docker

setup:
	$(DOCKER) build -t ppaqse-os/rtems-toolchain --file ./dockers/toolchain.dockerfile .

shell: setup
	$(DOCKER) run                                     \
		--user ppaqse                                   \
		-v ./artifacts:/home/ppaqse/artifacts           \
		-it ppaqse-os/rtems-toolchain                   \
		/bin/bash

hello_world: setup
	$(DOCKER) run                                     \
		--user ppaqse                                   \
		-v ./artifacts:/home/ppaqse/artifacts           \
		-it ppaqse-os/rtems-toolchain                   \
		/bin/bash -c "make -C /home/ppaqse/examples/hello_world/"

watchdog: setup
	$(DOCKER) run                                     \
		--user ppaqse                                   \
		-v ./artifacts:/home/ppaqse/artifacts           \
		-it ppaqse-os/rtems-toolchain                   \
		/bin/bash -c "make -C /home/ppaqse/examples/watchdog/"

timer: setup
	$(DOCKER) run                                     \
		--user ppaqse                                   \
		-v ./artifacts:/home/ppaqse/artifacts           \
		-it ppaqse-os/rtems-toolchain                   \
		/bin/bash -c "make -C /home/ppaqse/examples/timer/"

.PHONY: setup shell hello_world
