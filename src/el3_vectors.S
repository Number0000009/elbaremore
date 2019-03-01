#include <global.inc>
#include <uart_macros.inc>
#include <cpuid_macros.inc>
#include <bomb_macros.inc>
#include <vectors.inc>

// TODO: unhardcode this
// TODO: is Trusted DRAM OK, or should it be Trusted SRAM?
EL3_STORAGE_START = 0x06000000
// TODO: is this enough?
EL3_FRAME_SIZE = 0x1000

// TODO: this should be living in Trusted Boot ROM
	.global el3_vectors

// 0 - 0x200
	.balign 0x800
el3_vectors:
.balign 0x80
el3_vector_sync_sp0:
	writeln abt_sync_sp0
	bomb

.balign 0x80
el3_vector_irq_sp0:
	writeln abt_irq_sp0
	bomb

.balign 0x80
el3_vector_fiq_sp0:
	writeln abt_fiq_sp0
	bomb

.balign 0x80
el3_vector_serror_sp0:
	writeln abt_serror_sp0
	bomb

// 0x200 - 0x400
.balign 0x80
el3_vector_sync_spx:
	writeln abt_sync_spx
	bomb

.balign 0x80
el3_vector_irq_spx:
	writeln abt_irq_spx
	bomb

.balign 0x80
el3_vector_fiq_spx:
	writeln abt_fiq_spx
	bomb

.balign 0x80
el3_vector_serror_spx:
	writeln abt_serror_spx
	bomb

// 0x400 - 0x600
.balign 0x80
el3_vector_sync_lel:
	msr	DAIFset, #0xf

// Per ARM DEN 0070A X9...X15 are temporary registers
	mrs	x9, ESR_EL3
	and	x10, x9, #ESR_EC

	ldr	x11, =ESR_EC_SMC
	cmp	x11, x10
	b.ne	.default

	and	x10, x9, #ESR_ISS
	cmp	x10, #ESR_ISS_RMV
	b.ne	.is_not_rmv_call
//is_rmv_call:

/* Setup per cpu id storage frame
 * This is not a stack as it grows from start to end:
 * START			  END
 * o-------o-------o-------o-------o
 * ^\_____/^\_____/^\_____/^\_____/^
 *  id = 0     1       2       3
 */
	mov	x9, #EL3_STORAGE_START
	cpuid x10
	mov	w11,#EL3_FRAME_SIZE
	umaddl	x9, w10, w11, x9	// x9 = x9 + (w10 * w11)
	mov	sp, x9

	b	.rmv_call_handler

.is_not_rmv_call:
	cmp	x10, #ESR_ISS_RMV_RETURN
	b.eq	.rmv_return

	b	.default

.rmv_return:
	mov	x9, x0
	mov	x10, x1
	mov	x11, x2
	mov	x12, x3

	writeln rmv_return

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

.rmv_call_handler:
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

	writeln rmv_call
	ldr	x0, [sp, #0]	// X0
	prhex64 x0
	writeln crlf

// No exit from there
	b	goto_sel2

// Must not reach here
	writeln unreachable
	bomb

.default:
	writeln abt_sync_lel
	bomb

.balign 0x80
el3_vector_irq_lel:
	writeln abt_irq_lel
	bomb

.balign 0x80
el3_vector_fiq_lel:
	writeln abt_fiq_lel
	bomb

.balign 0x80
el3_vector_serror_lel:
	writeln abt_serror_lel
	bomb

// 0x600 - 0x800
.balign 0x80
el3_vector_sync_lel_a32:
	writeln abt_sync_lel_a32
	bomb

.balign 0x80
el3_vector_irq_lel_a32:
	writeln abt_irq_lel_a32
	bomb

.balign 0x80
el3_vector_fiq_lel_a32:
	writeln abt_fiq_lel_a32
	bomb

.balign 0x80
el3_vector_serror_lel_32:
	writeln abt_serror_lel_a32
	bomb

// -----------------------------------------------------------------------------
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

// ------------------------------
// This is executed at Secure EL2
// TODO: this is S-EL2 RMM, impement it
sel2_rmm_starts_here:
sel2_entry_point:
	mov	x9, x0
	mov	x10, x1
	mov	x11, x2
	mov	x12, x3

	writeln hi_from_sel2

	mov	x0, x9
	mov	x1, x10
	mov	x2, x11
	mov	x3, x12

	add	x0, x0, #1
// End of RMM
	smc	#ESR_ISS_RMV_RETURN

// Must not reach here
	writeln unreachable
	bomb

.section ".rodata"
rmv_call:
	.asciz "RMV call X0=0x"
hi_from_sel2:
	.asciz "Hi from S-EL2\r\n"
rmv_return:
	.asciz "Bye from S-EL2\r\n"

	.global unreachable
unreachable:
	.asciz "What r u doing here, bro?\r\n"
