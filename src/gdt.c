
#include "gdt.h"
#include "terminal.h"

int gdt_encode_entry(unsigned char *res, struct gdt_entry e)  {
	res[7] = ((unsigned long int)e.base >> 24) & 0xff;
	res[6] = ((e.flags & 15) << 4) | (((unsigned long int)e.limit >> 16) & 15);
	res[5] = e.access;
	res[4] = ((unsigned long int)e.base >> 16) & 0xff;
	res[3] = ((unsigned long int)e.base >> 8) & 0xff;
	res[2] = (unsigned long int)e.base & 0xff;
	res[1] = ((unsigned long int)e.limit >> 8) & 0xff;
	res[0] = (unsigned long int)e.limit & 0xff;
	return 0;
}

void gdt_fill(void *gdt_begin, void *gdt_end) {
	term_puts("Filling gdt\n");
	term_put_uint((gdt_end - gdt_begin)/(sizeof(int)), 10);
	term_puts("\n");
	struct gdt_entry gdt_entries[] = {
		{0, 0, 0, 0},
		// kernel data
		{0, (void*)0xfffff, 12, 0x92},

		// kernel code
		{0, (void*)0xfffff, 12, 0x9A},

		// user data
		{0, (void*)0xfffff, 12, 0xF2},

		// user code
		{0, (void*)0xfffff, 12, 0xFA},
		
		// task 
		// TODO: Set VALID TSS
		{0, 0, 0, 0x89}
	};
}
