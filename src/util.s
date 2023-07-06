
section .text

global get_msw
get_msw:
	push ebp
	mov ebp, esp

	smsw eax

	pop ebp
	ret
