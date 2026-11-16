CROSS_COMPILE ?= i686-elf-
CC = $(CROSS_COMPILE)gcc
NASM ?= nasm
QEMU ?= qemu-system-i386

C_SOURCES := $(wildcard arch/x86/*.c kernel/*.c)
ASM_SOURCES := $(wildcard arch/x86/*.S)
C_OBJECTS := $(patsubst %.c,build/%.o,$(C_SOURCES))
ASM_OBJECTS := $(patsubst %.S,build/%.S.o,$(ASM_SOURCES))

.PHONY: all kernel iso run run-iso clean all_x86 test_x86
.DELETE_ON_ERROR:

all: kernel

kernel: build/kernel.elf

iso: build/SOS.iso

run: build/kernel.elf
	$(QEMU) $(QEMUFLAGS) -kernel build/kernel.elf

run-iso: build/SOS.iso
	$(QEMU) $(QEMUFLAGS) -cdrom build/SOS.iso

all_x86: iso

test_x86: run-iso

clean:
	rm -rf -- build

build/kernel.elf: $(ASM_OBJECTS) $(C_OBJECTS) arch/x86/linker.ld Makefile
	$(CC) $(LDFLAGS) -nostdlib -no-pie -T arch/x86/linker.ld \
		-o build/kernel.elf $(ASM_OBJECTS) $(C_OBJECTS) -lgcc

build/%.o: %.c Makefile
	@mkdir -p "$(@D)"
	$(CC) -Iinclude $(CPPFLAGS) -std=gnu11 -O0 -Wall -ffreestanding \
		-fno-builtin -nostdinc -fno-stack-protector -fno-pie $(CFLAGS) \
		-MMD -MP -c "$<" -o "$@"

build/%.S.o: %.S Makefile
	@mkdir -p "$(@D)"
	$(NASM) $(NASMFLAGS) -f elf32 -MD "$(@:.o=.d)" -MP "$<" -o "$@"

build/SOS.iso: build/iso/boot/kernel_x86_v0.0.bin build/iso/boot/grub/grub.cfg scripts/build-iso.sh Makefile
	sh scripts/build-iso.sh build/SOS.iso build/iso

build/iso/boot/kernel_x86_v0.0.bin: build/kernel.elf
	@mkdir -p "$(@D)"
	cp "$<" "$@"

build/iso/boot/grub/grub.cfg: grub.cfg
	@mkdir -p "$(@D)"
	cp "$<" "$@"

-include $(C_OBJECTS:.o=.d) $(ASM_OBJECTS:.o=.d)
