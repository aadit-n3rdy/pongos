
#include "terminal.h"
#include "util.h"


void kernel_main() {
	term_puts("Hello World!!\n01234\n");
	unsigned int msw = get_msw();
	if (msw & 1) {
		term_puts("PROTECTED MODE\n");
	} else {
		term_puts("STILL IN REAL MODE, exiting...\n");
		return;
	}
}
