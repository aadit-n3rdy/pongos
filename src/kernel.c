
#include "terminal.h"
#include "util.h"
#include "gdt.h"

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

	term_puts("Exiting kernel...");
}
