CFLAGS=-g -Wall $$(pkg-config --cflags xencontrol)
LDFLAGS=$$(pkg-config --libs xencontrol)
CC=gcc
NAME=watchdog

all: build

build : init.c
	$(CC) -o "$(NAME)" init.c $(CFLAGS) $(LDFLAGS)
	mv -f "$(NAME)" ../../artifacts/

.PHONY: all build
