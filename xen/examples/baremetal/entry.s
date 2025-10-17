.section .text
.globl _start

_start:
  mov $0x100000, %esp
  call main

hlt_loop:
  hlt
  jmp hlt_loop
