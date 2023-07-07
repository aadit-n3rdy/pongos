CC:=i686-elf-gcc

AS:=nasm -felf32

CFLAGS:=-Wall -ffreestanding -Wextra -std=c99 -Iinclude

SRC_C:=$(wildcard src/*.c)
SRC_S:=$(wildcard src/*.asm)

OBJ_C:=$(addsuffix .o,$(patsubst src/%,obj/%,$(SRC_C)))
OBJ_S:=$(addsuffix .o,$(patsubst src/%,obj/%,$(SRC_S)))

# .PHONY: qemu qemu_kernel multiboot clean

out/clos.iso: out/clos.elf multiboot
	cp out/clos.elf isodir/boot/
	grub-mkrescue -o out/clos.iso isodir

qemu: multiboot out/clos.iso
	qemu-system-i386 -no-reboot -cdrom out/clos.iso

qemu_kernel: multiboot out/clos.elf
	qemu-system-i386 -no-reboot -kernel out/clos.elf

multiboot: out/clos.elf
	./check_multiboot

out/clos.elf: $(OBJ_C) $(OBJ_S)
	$(CC) -T linker.ld -o $@ -ffreestanding -O2 -nostdlib $(OBJ_C) $(OBJ_S) -lgcc

obj/%.c.o: src/%.c
	$(CC) $(CFLAGS) -o $@ -c $<

obj/%.asm.o: src/%.asm
	$(AS) -o $@ $<

clean:
	- rm out/*.elf out/*.iso obj/*.o isodir/boot/clos.elf

