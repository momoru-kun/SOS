//kmain.c entry point to kernel
#include <arch/x86/gdt.h>
#include <arch/x86/keyboard.h>
#include <arch/x86/timer.h>
#include <libk/printf.h>
#include <tty.h>
#include <multiboot.h>
#include <paging.h>
#include <kterm.h>

extern void jumpToRing3();

void kmain(int magic, multiboot_info_t *mboot_ptr)
{
	initGDT();
	initIDT();
	init_tty();
	clear_tty();
	printf("AVAL MEM FROM BIOS\n Mem_lower: 0x%x\n Mem_upper: 0x%x\n", mboot_ptr->mem_lower, mboot_ptr->mem_upper);
	printf("Mboot mmap length: %d bytes\n Mboot mmap address: 0x%x\n", mboot_ptr->mmap_length, mboot_ptr->mmap_addr);
	init_timer(50);
	init_keyboard();
	init_paging();
	kterm();
}
