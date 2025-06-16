.section .text
.globl _start

_start:
  mov $0x100000, %esp
  call main

halt:
  hlt
  jmp halt
