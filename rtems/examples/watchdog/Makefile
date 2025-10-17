WAF=./waf
NAME=watchdog

all: build

configure:
	$(WAF) --rtems-tools="$(RTEMS_PREFIX)/tools" --rtems="$(RTEMS_PREFIX)/kernel" configure

build: configure
	$(WAF)
	aarch64-rtems6-objcopy \
		-Obinary \
		"build/aarch64-rtems6-raspberrypi4b/$(NAME)" \
		"$(HOME)/artifacts/$(NAME).img"

.PHONY: all configure build
