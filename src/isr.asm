
section .data
message db "Default ISR triggered", 10, 0
newline db 10, 0

section .text

extern term_puts
extern term_put_uint
extern timedelay_exp

global isr_default
isr_default:
	cli

	push ebp
	mov ebp, esp
	sub esp, 16

	push message
	call term_puts
	add esp, 4

	xchg bx, bx

	mov esp, ebp
	pop ebp
	sti
	iret
