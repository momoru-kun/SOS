# SOS
Small OS Project 

This is my old(2017) project where i want to code my own module kernel(Not even close yet) and, maybe, Operation System

## Build and run

> How to build cross-compiler for i686-elf described here: https://wiki.osdev.org/GCC_Cross-Compiler

Building the kernel requires GNU Make, an `arch` (at the moment only i686-elf) GCC toolchain with
target `libgcc`, and NASM. If the compiler is in `PATH`, run `make kernel`.
For a toolchain installed in `~/opt/cross`, use its full prefix:

```sh
make -j4 kernel CROSS_COMPILE="/path/to/cross/compiler/{PREFIX}-"
make run CROSS_COMPILE="/path/to/cross/compiler/{PREFIX}-"
```

> For me it's `make -j4 kernel CROSS_COMPILE="${HOME}/opt/cross/bin/i686-elf-"`

- `make` and `make kernel` build `build/kernel.elf`.
- `make run` boots the Multiboot kernel directly with `qemu-system-i386`.
- `make iso` builds `build/SOS.iso` in a Debian container with GRUB BIOS
  modules (platform `i386-pc`) and `xorriso`. Start Docker before running it.
- `make run-iso` builds the ISO and boots it through GRUB in QEMU.
- `make clean` removes `build/`.

Set `QEMU` to use a different QEMU binary and `QEMUFLAGS` to pass extra
options. After changing the compiler or build flags, run `make clean`
before rebuilding.

Realized:
1. System boot-up with GRUB(Multiboot)
2. Base TTY => Inkerner
3. Memory paging
4. Interrupts => Keyboard, timer, etc.
5. RTC clock
6. Heap (Some dyn. memory)
7. PCI Scanning

Planned:
1. Work with PCI and SATA(through PCI bus)
2. Threading and Thread Safety(Mutexes, locks, semaphores)
3. Multitasking based on Bidirectional listings and timer interrupt
4. Some File Systems support
5. VGA Support on kernel level
6. Modules loader
