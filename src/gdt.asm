
section .data
message db 'Exited from gdt_fill', 10, 0
newline db 10, 0
gdtr dw 0
dd 0 
_GDT_BEGIN:
times 96 db 0
_GDT_END:

section .text

extern term_puts
extern gdt_fill
extern timedelay_exp
extern term_put_uint

global gdt_init
gdt_init:
	push ebp
	mov ebp, esp
	sub esp, 16

	push _GDT_END
	push _GDT_BEGIN
	call gdt_fill
	add esp, 8
	cmp eax, 0

	jz _gdt_fill_success
	ret

	_gdt_fill_success:
	cli
	mov ax, _GDT_END - _GDT_BEGIN - 1
	mov [gdtr], ax
	mov dword [gdtr+2], _GDT_BEGIN

	xor eax, eax


	lgdt [gdtr]
	call 0x10:flush_gdt ; 0x10: offset of code segment (index 2, type 0 gdt, rpl 0)

	mov esp, ebp
	pop ebp

	mov eax, 0
	ret

flush_gdt:
	mov ax, 0x08 ; 0x08: offset of data segment (index 1, type 0 gdt, rpl 0)
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	ret

