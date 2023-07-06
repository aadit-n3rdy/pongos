
#include "terminal.h"
#include "util.h"
#include "gdt.h"

extern char *somming;

int fkall_func(int a);

void kernel_main() {
	term_puts("Hello World!!\n01234\n");

	term_put_uint(gdt_init(), 16);
	term_putchar(TERM_DEFAULT_BG, TERM_DEFAULT_FG, '\n');

	unsigned int msw = get_msw();
	if (msw & 1) {
		term_puts("PROTECTED MODE\n");
	} else {
		term_puts("STILL IN REAL MODE, exiting...\n");
		return;
	}
}
