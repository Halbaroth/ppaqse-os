main.o: main.c
	$(CC) -m32 -nostdlib -ffreestanding -c main.c -o main.o

entry.o: entry.s
	$(CC) -m32 -nostdlib -ffreestanding -c entry.s -o entry.o

build: entry.o main.o
	$(LD) -T linker.ld -z noexecstack -o kernel.elf entry.o main.o

clean:
	rm -f main.o entry.o kernel.elf

.PHONY: build clean
