#include <rmm.inc>

/* Setup per cpu id storage frame
 * This is not a stack as it grows from start to end:
 * START			  END
 * o-------o-------o-------o-------o
 * ^\_____/^\_____/^\_____/^\_____/^
 *  id = 0     1       2       3
 */
 // Corrupts: x9, x10, x11, sp
	.macro setup_storage
	mov	x9, #EL3_STORAGE_START
	cpuid x10
	mov	w11,#EL3_FRAME_SIZE
	umaddl	x9, w10, w11, x9	// x9 = x9 + (w10 * w11)
	mov	sp, x9
	.endm

.rmm_return:
	mov	x9, x0
	mov	x10, x1
	mov	x11, x2
	mov	x12, x3

	writeln rmm_return
	mov	x0, x9
	prhex64 x0
	writeln crlf

// return_from_sel2
// restore context minus x0-x3, x0-x3 come from SMC call args
// TODO: what context should look like?
	ldp	x0, x1, [sp, #80]
	ldp	x2, x3, [sp, #96]
	ldp	x4, x5, [sp, #112]
	ldr	x30,	[sp, #128]
	msr	SCR_EL3, x0
	msr	SCTLR_EL2, x1
	msr	SPSR_EL3, x2
	msr	ELR_EL3, x3
	msr	SPSR_EL2, x4
	msr	ELR_EL2, x5

	mov	x0, x9
	mov	x1, x10
	mov	x2, x11
	mov	x3, x12

	ldp	x4, x5, [sp, #32]
	ldp	x6, x7, [sp, #48]
	ldp	x8, x9, [sp, #64]

	msr	DAIFclr, #0xf
	eret

// Must not reach here
	writeln unreachable
	bomb

.rmm_call_handler:
// TODO: what context should look like?
	stp	x0, x1, [sp, #0]
	stp	x2, x3, [sp, #16]
	stp	x4, x5, [sp, #32]
	stp	x6, x7, [sp, #48]
	stp	x8, x9, [sp, #64]
	mrs	x0, SCR_EL3
	mrs	x1, SCTLR_EL2
	mrs	x2, SPSR_EL3
	mrs	x3, ELR_EL3
	mrs	x4, SPSR_EL2
	mrs	x5, ELR_EL2
	stp	x0, x1, [sp, #80]
	stp	x2, x3, [sp, #96]
	stp	x4, x5, [sp, #112]
	str	x30,	[sp, #128]

	writeln rmm_call
	ldr	x0, [sp, #0]	// X0
	prhex64 x0
	writeln crlf

// No exit from there
	b	goto_sel2

// Must not reach here
	writeln unreachable
	bomb

goto_sel2:
	mov	x0, xzr
	bic	x0, x0, SCR_NS		// Secure, probably redundant
	orr	x0, x0, SCR_EEL2	// SEL2
	msr	SCR_EL3, x0

	mov	x0, xzr
	msr	SCTLR_EL2, x0

// TODO: is SPSR_SEL2 different from SPSR_KERNEL?
	ldr	x0, =SPSR_SEL2
	msr	SPSR_EL3, x0

	ldr	x0, =sel2_entry_point
	msr	ELR_EL3, x0

// Restore x0-x3 of RMC call
	ldp	x0, x1, [sp, #0]
	ldp	x2, x3, [sp, #16]

	eret

// Must not reach here
	writeln unreachable
	bomb
