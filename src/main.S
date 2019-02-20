#include <uart_macros.inc>
#include <bomb_macros.inc>

// TODO: unhardcode this
KERNEL_ADDR = 0x80000000
DTB_ADDR = 0x80800000

KERNEL_ENTRY_POINT = 0x80080000

	.global main
main:
// Park secondary cores
	mrs	x0, MPIDR_EL1
	tst	x0, #0x0f	// not b0000 (not a primary CPU) - goto stop
	b.eq	primary_cpu_continue

// TODO: read mailbox
	bomb

primary_cpu_continue:
	adr	x0, el3_vectors
	msr	VBAR_EL3, x0
	isb

	writeln current_el

// print current EL
	mrs	x0, CurrentEL
	ubfm	w0, w0, #2, #31
	add	w0, w0, '0'
	bl	putch
	writeln crlf

// Relocate kernel
	writeln relocate_kernel_from
	phex64 kernel_image
	writeln crlf

	writeln relocate_kernel_to
	phex64 KERNEL_ADDR
	writeln crlf

// TODO: relocate

// Relocate DTB
	writeln relocate_dtb_from
	phex64 dtb_image
	writeln crlf

	writeln relocate_dtb_to
	phex64 DTB_ADDR
	writeln crlf

// TODO: relocate

/*
 * Per linux/Documentation/arm64/booting.txt
 * jump into kernel
 * x0: FDT
 * x1 = 0, x2 = 0, x3 = 0: args
 * Destination EL = EL2
 *
 * For systems with a GICv3 interrupt controller to be used in v3 mode:
 * - If EL3 is present:
 *   ICC_SRE_EL3.Enable (bit 3) must be initialiased to 0b1.
 *   ICC_SRE_EL3.SRE (bit 0) must be initialised to 0b1.
 * - If the kernel is entered at EL1:
 *   ICC.SRE_EL2.Enable (bit 3) must be initialised to 0b1
 *   ICC_SRE_EL2.SRE (bit 0) must be initialised to 0b1.
 * - The DT or ACPI tables must describe a GICv3 interrupt controller.
*/
	writeln enter

	mov	x0, xzr
// TODO: let's combine this together later
// Enable ICC_SRE_EL2 access from EL2
	orr	x0, x0, ICC_SRE_EL3_Enable
// Enable System register interface to the ICC_* for EL3 and ICH_* from EL2 and EL1
	orr	x0, x0, ICC_SRE_EL3_SRE
	msr	ICC_SRE_EL3, x0

// TODO: setup scr_el3

	ldr	x0, =SPSR_KERNEL
	msr	spsr_el3, x0

	ldr	x0, =KERNEL_ENTRY_POINT
	msr	elr_el3, x0

	ldr	x0, =DTB_ADDR
	mov	x1, xzr
	mov	x2, xzr
	mov	x3, xzr

	eret

// End
	bomb

.section ".rodata"
current_el:
	.asciz "Current EL = EL"
crlf:
	.asciz "\r\n"
relocate_kernel_from:
	.asciz "Relocating kernel from 0x"
relocate_kernel_to:
	.asciz "\tto 0x"
relocate_dtb_from:
	.asciz "Relocating DTB from 0x"
relocate_dtb_to:
	.asciz "\tto 0x"
enter:
	.asciz "Jump into the fire\r\n"
