#include <uart_macros.inc>
#include <bomb_macros.inc>

// TODO: unhardcode this
KERNEL_ADDR = 0x80080000
DTB_ADDR = 0x88000000

KERNEL_ENTRY_POINT = KERNEL_ADDR

// Taken from foundation-v8-spin-table.dtsi
MAILBOX = 0x8000fff8

	.global main
main:
	adr	x0, el3_vectors
	msr	VBAR_EL3, x0
	isb

	ldr	x0, =MAILBOX
	str	xzr, [x0]

// TODO: dmb?

	mrs	x0, ICC_SRE_EL3
// TODO: let's combine this together later
// Enable ICC_SRE_EL2 access from EL2
	orr	x0, x0, ICC_SRE_EL3_Enable
// Enable System register interface to the ICC_* for EL3 and ICH_* from EL2 and EL1
	orr	x0, x0, ICC_SRE_EL3_SRE
	msr	ICC_SRE_EL3, x0
	isb

	mov	x0, xzr
	msr	ICC_CTLR_EL3, x0
	isb

	orr	x0, x0, SCR_RW
	orr	x0, x0, SCR_NS

// check if PAC is implemented
	mrs	x1, ID_AA64ISAR1_EL1
	ldr	x2, =API_APA_GPI_GPA
	and	x1, x1, x2
	cbz	x1, .no_pac

	orr	x0, x0, SCR_APK
	orr	x0, x0, SCR_API
.no_pac:
	msr	SCR_EL3, x0

	ldr	x0, =SPSR_KERNEL
	msr	SPSR_EL3, x0

	mrs	x0, MPIDR_EL1
	tst	x0, #0x0f	// primary core = 0b0000
	b.eq	primary_cpu_continue

	ldr	x0, =.el2_continue
	msr	ELR_EL3, x0
	eret

.el2_continue:
	ldr	x1, =MAILBOX
	sevl
.wait:
	wfe
	ldr	x0, [x1]
	cbz	x0, .wait
	br	x0

primary_cpu_continue:
	writeln current_el

// print current EL
	mrs	x0, CurrentEL
	ubfm	w0, w0, #2, #31
	add	w0, w0, '0'
	bl	putch
	writecrlf

// Relocate kernel
	writeln relocate_kernel_from
	phex64 kernel_image_start
	writecrlf

	writeln relocate_kernel_to
	phex64 KERNEL_ADDR
	writecrlf

// TODO: relocate. fix tail
	ldr	x2, =(kernel_image_end)
	ldr	x0, =(kernel_image_start)
	sub	x2, x2, x0
	lsr	x2, x2, #4

	ldr	x0, =(kernel_image_start - 16)
	ldr	x1, =(KERNEL_ADDR - 16)
reloc1:
	ldp	x3, x4, [x0, #16]!
	stp	x3, x4, [x1, #16]!
	subs	x2, x2, #1
	b.ne	reloc1

// Relocate DTB
	writeln relocate_dtb_from
	phex64 dtb_image_start
	writecrlf

	writeln relocate_dtb_to
	phex64 DTB_ADDR
	writecrlf

// TODO: relocate. fix tail
	ldr	x2, =(dtb_image_end)
	ldr	x0, =(dtb_image_start)
	sub	x2, x2, x0
	lsr	x2, x2, #4

	ldr	x0, =(dtb_image_start - 16)
	ldr	x1, =(DTB_ADDR - 16)
reloc2:
	ldp	x3, x4, [x0, #16]!
	stp	x3, x4, [x1, #16]!
	subs	x2, x2, #1
	b.ne	reloc2

	mov	x1, #GIC_RDIST_BASE
.gicv3_wakeup:
	ldr	w0, [x1, #GICR_WAKER]
	and	w0, w0, ~GICR_WAKER_ProcessorSleep
	str	w0, [x1, #GICR_WAKER]

	ldr	w2, [x1, #GICR_TYPER]

// SGI
	add	x1, x1, #0x10000
	mvn	w0, wzr
	str	w0, [x1, #GICR_IGROUP0]

	mov	w0, wzr
	str	w0, [x1, #GICR_IGRPMOD0]

	add	x1, x1, #0x10000

	tbz	x2, #GICR_TYPER_Last_BIT, .gicv3_wakeup

	ldr	x0, =KERNEL_ENTRY_POINT
	msr	ELR_EL3, x0

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

	writeln enter_kernel
	ldr	x0, =DTB_ADDR
	mov	x1, xzr
	mov	x2, xzr
	mov	x3, xzr

	eret

// Must not reach here
	writeln unreachable
	bomb

.section ".rodata"
current_el:
	.asciz "Current EL = EL"
relocate_kernel_from:
	.asciz "Relocating kernel from 0x"
relocate_kernel_to:
	.asciz "\tto 0x"
relocate_dtb_from:
	.asciz "Relocating DTB from 0x"
relocate_dtb_to:
	.asciz "\tto 0x"
enter_kernel:
	.asciz "Booting Linux\r\n"

	.global crlf
crlf:
	.asciz "\r\n"
