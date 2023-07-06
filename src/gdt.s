
section .data

gdt_begin:
resb 48
gdt_end:


section .text

global somming
somming: db "some shit in gdt_init i think",10,0

extern term_puts
extern gdt_fill
global gdt_init
gdt_init:
	push ebp
	mov ebp, esp
	sub esp, 16

	push gdt_end
	push gdt_start
	call gdt_fill
	add esp, 8

	mov esp, ebp
	pop ebp

	mov eax, 0
	ret

global fkall_func
fkall_func:
	push ebp
	mov ebp, esp

	mov eax, [ebp+8]

	pop ebp
	ret
