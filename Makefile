CC:=i686-elf-gcc

AS:=i686-elf-as

CFLAGS:=-Wall -ffreestanding -Wextra -std=c99

SRC_C:=$(wildcard src/*.c)
SRC_S:=$(wildcard src/*.s)

OBJ_C:=$(addsuffix .o,$(patsubst src/%,obj/%,$(SRC_C)))
OBJ_S:=$(addsuffix .o,$(patsubst src/%,obj/%,$(SRC_S)))

qemu: multiboot out/clos.iso
	qemu-system-i386 -cdrom out/clos.iso

qemu_kernel: multiboot out/clos.elf
	qemu-system-i386 -kernel out/clos.elf

multiboot: out/clos.elf
	./check_multiboot

out/clos.iso: out/clos.elf multiboot
	cp out/clos.elf isodir/boot/
	grub-mkrescue -o out/clos.iso isodir


out/clos.elf: $(OBJ_C) $(OBJ_S)
	$(CC) -T linker.ld -o $@ -ffreestanding -O2 -nostdlib $(OBJ_C) $(OBJ_S) -lgcc

obj/%.c.o: src/%.c
	$(CC) $(CFLAGS) -o $@ -c $<

obj/%.s.o: src/%.s
	$(AS) -o $@ $<


