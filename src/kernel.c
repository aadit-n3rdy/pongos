
#include "terminal.h"
#include "util.h"
#include "gdt.h"
#include "idt.h"

void kernel_main() {
	term_puts("Hello World!!\n01234\n");

	if (get_msw() & 1) {
		term_puts("PROTECTED MODE\n");
	} else {
		term_puts("STILL IN REAL MODE, exiting...\n");
		return;
	}

	gdt_init();

	term_puts("huh, inited gdt?\n");

	term_puts("Kernel code desc: 0x");
	term_put_uint(SEGDESC_KERNEL_CODE, 16);
	term_puts("\n");

	term_puts("Kernel data desc: 0x");
	term_put_uint(SEGDESC_KERNEL_DATA, 16);
	term_puts("\n\n");

	idt_init();

	term_puts("\nhuh, inited idt? maybe ill try triggering an int\n");
	__asm__ ("int $0x10");
	term_puts("Ok lets hope that worked\n\n");

	term_puts("Exiting kernel...\n");
}
