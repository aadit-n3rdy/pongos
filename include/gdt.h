#ifndef CLOS_GDT_H
#define CLOS_GDT_H

struct gdt_entry {
	void *base;
	void *limit;
	unsigned char flags;
	unsigned char access;
};

//extern void *_GDT;
//extern void *_GDT_END;

int gdt_encode_entry(unsigned char *res, struct gdt_entry e);

int gdt_init();

#endif
