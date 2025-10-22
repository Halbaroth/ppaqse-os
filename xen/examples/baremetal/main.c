#include <stdint.h>

#define PORT 0x3F8 // Serial port COM1

void outb(uint16_t port, uint8_t data) {
  asm volatile ("outb %0, %1" :: "a"(data), "Nd"(port));
}

uint8_t inb(uint16_t port) {
  uint8_t r;
  asm volatile ("inb %1, %0" : "=a"(r) : "Nd"(port));
  return r;
}

void wait() {
  while ((inb(PORT + 5) & 0x20) == 0);
}

// Initialize port with baud 38400, 8 databits, no parity and 1 stopbit
void serial_init() {
  outb(PORT + 1, 0x00);
  outb(PORT + 3, 0x80);
  outb(PORT + 0, 0x03);
  outb(PORT + 1, 0x00);
  outb(PORT + 3, 0x03);
  outb(PORT + 2, 0xC7);
  outb(PORT + 4, 0x0B);
}

void puts(const char* str) {
  while (*str) {
    wait();
    outb(PORT, *str);
    str++;
  }
  wait();
  outb(PORT, '\n');
}

void main(void) {
  serial_init();
  puts("Hello, world");

  while (1) {
    wait();
    outb(PORT, '.');
    // asm volatile ("hlt");
  }
}
