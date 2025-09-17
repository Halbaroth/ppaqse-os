CFLAGS=-g -Wall $$(pkg-config --cflags xencontrol)
LDFLAGS=$$(pkg-config --libs xencontrol)
CC=gcc

watchdog: watchdog.c
	$(CC) -o watchdog watchdog.c $(CFLAGS) $(LDFLAGS)

clean:
	rm watchdog

.PHONY: all watchdog clean
