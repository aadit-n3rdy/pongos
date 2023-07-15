CC:=i686-elf-gcc

AS:=nasm -felf32

CFLAGS:=-g -Wall -ffreestanding -Wextra -std=c99 -Iinclude

SRC_C:=$(wildcard src/*.c)
SRC_S:=$(wildcard src/*.asm)

OBJ_C:=$(addsuffix .o,$(patsubst src/%,obj/%,$(SRC_C)))
OBJ_S:=$(addsuffix .o,$(patsubst src/%,obj/%,$(SRC_S)))

OUT_ELF := out/clos.elf
OUT_BIN := out/clos.bin

.PHONY: qemu qemu_kernel multiboot clean

out/clos.iso: $(OUT_BIN) $(OUT_ELF) multiboot
	cp $(OUT_BIN) isodir/boot/
	grub-mkrescue -o out/clos.iso isodir

qemu: multiboot out/clos.iso $(OUT_ELF)
	qemu-system-i386 -enable-kvm -no-reboot -cdrom out/clos.iso

qemu_kernel: multiboot out/clos.elf $(OUT_ELF)
	qemu-system-i386 -enable-kvm -no-reboot -kernel out/clos.elf

bochs: out/clos.iso
	bochs -q -f bochsrc

multiboot: out/clos.elf
	./check_multiboot

$(OUT_ELF): $(OBJ_C) $(OBJ_S)
	$(CC) -g -T linker.ld -o $@ -ffreestanding -O2 -nostdlib $(OBJ_C) $(OBJ_S) -lgcc

$(OUT_BIN): $(OBJ_C) $(OBJ_S)
	$(CC) -g -T linker.ld -o $@ -ffreestanding -O2 -nostdlib $(OBJ_C) $(OBJ_S) -lgcc

obj/%.c.o: src/%.c
	$(CC) $(CFLAGS) -o $@ -c $<

obj/%.asm.o: src/%.asm
	$(AS) -o $@ $<

clean:
	- rm -f $(OUT_BIN) $(OUT_ELF) out/*.iso obj/*.o $(patsubst out/%,isodir/boot/%,$(OUT_ELF) $(OUT_BIN))

