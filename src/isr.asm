
extern term_puts
extern term_put_uint

%macro isr_stub_err 1
isr_stub_%+%1:
	cli

	push default_message
	call term_puts
	add esp, 4

	mov eax, isr_msgs
	add eax, 3*%1
	push eax
	call term_puts
	add esp, 4

	push newline
	call term_puts
	add esp, 4

	push err_message
	call term_puts
	add esp, 4

	mov ecx, [esp+8]
	push dword 16
	push ecx
	call term_put_uint
	add esp, 8

	hlt
	iret
%endmacro

%macro isr_stub_noerr 1
isr_stub_%+%1:
	cli

	pop ecx

	push default_message
	call term_puts
	add esp, 4

	mov eax, isr_msgs
	add eax, 3*%1
	push eax
	call term_puts
	add esp, 4

	push newline
	call term_puts
	add esp, 4

	hlt
	iret
%endmacro

%macro dstr 1
db %1, 0
%endmacro

section .data

default_message: db 'EXCEPTION: ', 0
err_message: db 'ERROR CODE: 0x', 0
newline db 10, 0
default_isr_message: db 'Interrupt!', 10, 0

isr_msgs:
dstr 'DE'
dstr 'DB'
dstr '02'
dstr 'BP'
dstr 'OF'
dstr 'BR'
dstr 'UD'
dstr 'NM'
dstr 'DF'
dstr '09'
dstr 'TS'
dstr 'NP'
dstr 'SS'
dstr 'GP'
dstr 'PF'
dstr '0F'
dstr 'MF'
dstr 'AC'
dstr 'MC'
dstr 'XF'
dstr 'VE'
dstr 'CP'
dstr '16'
dstr '17'
dstr '18'
dstr '19'
dstr '1A'
dstr '1B'
dstr 'HV'
dstr 'VC'
dstr 'SX'
dstr '1F'

global ISR_TABLE
ISR_TABLE:
%assign i 0
%rep 32
	dd isr_stub_%+i
	%assign i i+1
%endrep
%rep 256-32
	dd isr_default
%endrep

section .text
isr_stub_noerr 0
isr_stub_noerr 1
isr_stub_noerr 2
isr_stub_noerr 3
isr_stub_noerr 4
isr_stub_noerr 5
isr_stub_noerr 6
isr_stub_noerr 7
isr_stub_err   8
isr_stub_noerr 9
isr_stub_err   10
isr_stub_err   11
isr_stub_err   12
isr_stub_err   13
isr_stub_err   14
isr_stub_noerr 15
isr_stub_noerr 16
isr_stub_err   17
isr_stub_noerr 18
isr_stub_noerr 19
isr_stub_noerr 20
isr_stub_err   21
isr_stub_noerr 22
isr_stub_noerr 23
isr_stub_noerr 24
isr_stub_noerr 25
isr_stub_noerr 26
isr_stub_noerr 27
isr_stub_noerr 28
isr_stub_err   29
isr_stub_err   30
isr_stub_noerr 31

isr_default:
xchg bx, bx
	cli

	push ebp
	mov ebp, esp

	push default_isr_message
	call term_puts
	add esp, 4

	pop ebp
	sti
	iret
