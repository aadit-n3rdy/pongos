
section .data
message db 'Exited from gdt_fill', 10, 0
gdtr dw 0
dd 0 

section .text

extern _GDT 
extern _GDT_LEN

extern term_puts
extern gdt_fill
extern timedelay_exp

global gdt_init
gdt_init:
	push ebp
	mov ebp, esp
	sub esp, 16

	call gdt_fill
	cmp eax, 0

	jz _gdt_fill_success
	ret


	_gdt_fill_success:


	cli
	mov ax, [_GDT_LEN]
	sub ax, 1
	mov [gdtr], ax
	mov dword [gdtr+2], _GDT

	xor eax, eax


	lgdt [gdtr]
	call 0x10:flush_gdt ; 0x10: offset of code segment

	mov esp, ebp
	pop ebp

	mov eax, 0
	ret

flush_gdt:
	mov ax, 0x08 ; 0x08: offset of data segment
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	ret

