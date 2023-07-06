MBALIGN equ 1<<0
MBMEMINFO equ 1<<1
MAGIC equ 0x1BADB002
FLAGS equ MBALIGN | MBMEMINFO
CHECKSUM equ -(MAGIC + FLAGS)

section .multiboot
align 4
	dd MAGIC
	dd FLAGS
	dd CHECKSUM

section .bss
align 16
stack_bottom:
resb 16384
stack_top:

extern kernel_main

section .text
global _start
_start:
	mov esp, stack_top
	mov ebp, stack_bottom

	call kernel_main

_boot_hlt:
	jmp _boot_hlt
