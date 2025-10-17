void outb(short port, char data) {
  asm volatile ("outb %b0, %w1" :: "a"(data), "Nd"(port));
}

#define SERIAL_PORT 0x3F8

void puts(const char* str) {
  while (*str) {
    outb(SERIAL_PORT, *str);
    str++;
  }
  outb(SERIAL_PORT, '\n');
}

void main(void) {
  puts("Hello, world");

  while (1) {
    asm volatile ("hlt");
  }
}
