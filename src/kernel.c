
#include "terminal.h"
#include "util.h"
#include "gdt.h"
#include "idt.h"
#include "io.h"
#include "pic.h"

#include "config.h"

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

	term_puts("\nhuh, inited idt?\n");

#ifdef TEST_INT
	term_puts("Testing interrupts, will exit after this. Should trigger int 0x08 \
with err code 0x10\n");
	__asm__ ("pushl $0x10; int $0x08");
	term_puts("Ok lets hope that worked\n\n");
#endif

#ifdef TEST_HIGHINT
	term_puts("Testing interrupt beyond 32, should continue after this\n");
	__asm__ volatile ("int $0x30");
	term_puts("Ok lets hope that worked\n\n");
#endif

	pic_init();

	term_puts("Done initing PIC\n");
	term_puts("Enabling interrupts\n");
	__asm__ volatile("sti");

	pic_setmask(0xffff ^ (1<<1));

	while(1) {
	}

	term_puts("Exiting kernel\n");
}
