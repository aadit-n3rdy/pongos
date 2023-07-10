
#include "idt.h"

#include "gdt.h"
#include "isr.h"
#include "terminal.h"

int idt_encode_entry(struct idt_desc *desc, void *isr, unsigned char flags) {
	desc->isr_high = (unsigned int)isr>>16;
	desc->isr_low = (unsigned int)isr & 0xffff;
	desc->reserved = 0;
	desc->segsel = 0x10;
	desc->flags = flags;
	return 0;
}

int idt_fill(struct idt_desc idt[256], void **isr_table) {
	term_puts("Called idt_fill at address: 0x");
	term_put_uint((unsigned int)idt, 16);
	term_puts("\n");
	for (int i = 0; i < 256; i++) {
		idt_encode_entry(idt+i, isr_table[i], 0x8E);
	}
	term_puts("Finished filling idt\n");
	return 0;
}
