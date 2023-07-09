
section .bss
_IDT_BEGIN:
resb 2048
_IDT_END:

section .data
_IDTR:
dw 0
dd 0
debug_msg db 'Max IDT entries: ', 0
newline db 10, 0

extern isr_default
extern SEGDESC_KERNEL_CODE
extern idt_fill
extern timedelay_exp
extern term_puts
extern term_put_uint

section .text

global idt_init
idt_init:
	push ebp
	mov ebp, esp
	sub esp, 24

	push debug_msg
	call term_puts
	add esp, 4

	mov eax, _IDT_END
	sub eax, _IDT_BEGIN

	push edx
	push edi
	mov edx, 0
	mov edi, 8
	div edi
	pop edi
	pop edx

	push dword 10
	push eax
	call term_put_uint
	add esp, 8

	push newline
	call term_puts
	add esp, 4

	push _IDT_BEGIN
	call idt_fill
	add esp, 4

	mov word [_IDTR], 255
	mov dword [_IDTR + 2], _IDT_BEGIN
	mov eax, _IDTR
	lidt [eax]

	xchg bx, bx ;Bochs magic break

	sti

	mov esp, ebp
	pop ebp
	ret
