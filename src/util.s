
.section .text

.global get_msw
.type get_msw, @function
get_msw:
	push %ebp
	movl %esp, %ebp

	smsw %eax

	popl %ebp
	ret
.size get_msw, . - get_msw
