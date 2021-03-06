#include <global.inc>
#include <uart_macros.inc>
#include <bomb_macros.inc>
#include <cpuid_macros.inc>

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

	allocate_stack EL3_STACK_TOP+1 EL3_STACK_SIZE, x0
	mov	sp, x0

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

	ldr	x1, =MAILBOX
	sevl
.wait:
	wfe
	ldr	x0, [x1]
	cbz	x0, .wait
	msr	ELR_EL3, x0
	eret

primary_cpu_continue:
	writeln current_el_msg

	mrs	x0, CurrentEL
	ubfm	w0, w0, #2, #31
	prshex64 x0
	writecrlf

// Relocate kernel

	ldr	x2, =(kernel_image_end)
	ldr	x0, =(kernel_image_start)

// length
	sub	x2, x2, x0

	ldr	x0, =(kernel_image_start - 16)
	ldr	x1, =(KERNEL_ADDR - 16)

	writeln relocate_kernel_from_msg
	prshex64 x0
	writecrlf
	writeln relocate_kernel_to_msg
	pshex64 KERNEL_ADDR
	writecrlf

	bl memcpy

// Relocate DTB
	ldr	x2, =(dtb_image_end)
	ldr	x0, =(dtb_image_start)

// length
	sub	x2, x2, x0

	ldr	x0, =(dtb_image_start - 16)
	ldr	x1, =(DTB_ADDR - 16)

	writeln relocate_dtb_from_msg
	prshex64 x0
	writecrlf
	writeln relocate_dtb_to_msg
	pshex64 DTB_ADDR
	writecrlf

	bl memcpy

	mov	x1, #GIC_RDIST_BASE
.gicv3_wakeup:
	ldr	w0, [x1, #GICR_WAKER]
	and	w0, w0, ~GICR_WAKER_ProcessorSleep
	str	w0, [x1, #GICR_WAKER]

	ldr	w2, [x1, #GICR_TYPER]

// SGI
	add	x1, x1, #0x10000
	mvn	w0, wzr
	str	w0, [x1, #GIC_IGROUP0]

	mov	w0, wzr
	str	w0, [x1, #GIC_IGRPMOD0]

	add	x1, x1, #0x10000

	tbz	x2, #GICR_TYPER_Last_BIT, .gicv3_wakeup

	mov	x1, #GIC_DIST_BASE
	ldr	w2, [x1, #GICD_TYPER]

	and	x2, x2, #GICD_TYPER_ITLineNumber

	sub	x2, x2, #1
	mov	x4, x1
.gicv3_dwakeup:
	add	x1, x4, x2, lsl #2

	mvn	w0, wzr
	str	w0, [x1, #GIC_IGROUP0]

	mov	w0, wzr
	str	w0, [x1, #GIC_IGRPMOD0]
	sub	x2, x2, #1
	cbnz	x2, .gicv3_dwakeup

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

	writeln enter_kernel_msg
	ldr	x0, =DTB_ADDR
	mov	x1, xzr
	mov	x2, xzr
	mov	x3, xzr

	eret

// Must not reach here
	writeln unreachable_msg
	bomb



// memcpy
// from x0 to x1 of x2 bytes
memcpy:
	stp	x0, x1, [sp, #-16]!
	stp	x2, x3, [sp, #-16]!
	stp	x4, x5, [sp, #-16]!

// length
	mov	x5, x2
// in 2 x words
	lsr	x2, x2, #4

// tail in bytes
	sub	x5, x5, x2, lsl #4

.memcpy1:
	ldp	x3, x4, [x0, #16]!
	stp	x3, x4, [x1, #16]!
	sub	x2, x2, #1
	cbnz	x2, .memcpy1

	cbz	x5, .memcpy_exit
	add	x0, x0, #15
	add	x1, x1, #15
	mov	x2, x5
.memcpy2:
	ldrb	w3, [x0, #1]!
	strb	w3, [x1, #1]!
	sub	x2, x2, #1
	cbnz	x2, .memcpy2

.memcpy_exit:
	ldp	x4, x5, [sp], #16
	ldp	x2, x3, [sp], #16
	ldp	x0, x1, [sp], #16

	ret

.section ".rodata"
#include <strings.inc>
