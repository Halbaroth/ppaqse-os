WAF=./waf

all: build

configure:
	$(WAF) --rtems-tools="$(RTEMS_PREFIX)/tools" --rtems="$(RTEMS_PREFIX)/kernel" configure

build: configure
	$(WAF)

.PHONY: all configure build
