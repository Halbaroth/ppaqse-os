main.o: main.c
	$(CC) -m32 -ffreestanding -c main.c -o main.o

entry.o: entry.s
	$(CC) -m32 -ffreestanding -c entry.s -o entry.o

build: entry.o main.o
	$(LD) -m elf_i386 -T linker.ld -o kernel.elf entry.o main.o

clean:
	rm main.o entry.o kernel.elf

.PHONY: build clean
