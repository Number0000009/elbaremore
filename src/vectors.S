#include <global.inc>
#include <uart_macros.inc>
#include <bomb_macros.inc>

// TODO: unhardcode this
// TODO: is Trusted DRAM OK, or should it be Trusted SRAM?
EL3_STACK_ADDR = 0x06000000

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
	b.eq	.rmv_call

	cmp	x10, #ESR_ISS_RMV_RETURN
	b.eq	.rmv_return

	b	.default

.rmv_return:
	writeln rmv_return
	ldr	x0, [sp, #0]
	prhex64 x0
	writeln crlf

// return_from_sel2
// restore context
	ldp	x0, x1, [sp, #80]
	ldp	x2, x3, [sp, #96]
	ldr	x30,	[sp, #112]
	msr	SCR_EL3, x0
	msr	SCTLR_EL2, x1
	msr	SPSR_EL3, x2
	msr	ELR_EL3, x3

	ldp	x0, x1, [sp, #0]
	ldp	x2, x3, [sp, #16]
	ldp	x4, x5, [sp, #32]
	ldp	x6, x7, [sp, #48]
	ldp	x8, x9, [sp, #64]
// TODO: is this enough?

	msr	DAIFclr, #0xf
	eret

// Must not reach here
	writeln unreachable
	bomb

.rmv_call:
// TODO: not the whole context, just per SMCCC + sysregs
	ldr	x9, =EL3_STACK_ADDR
	mov	sp, x9
	stp	x0, x1, [sp, #0]
	stp	x2, x3, [sp, #16]
	stp	x4, x5, [sp, #32]
	stp	x6, x7, [sp, #48]
	stp	x8, x9, [sp, #64]
// TODO: is this enough?

	mrs	x0, SCR_EL3
	mrs	x1, SCTLR_EL2
	mrs	x2, SPSR_EL3
	mrs	x3, ELR_EL3
	stp	x0, x1, [sp, #80]
	stp	x2, x3, [sp, #96]
	str	x30,	[sp, #112]

	writeln rmv_call
	ldr	x0, [sp, #0]
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
	eret

// Must not reach here
	writeln unreachable
	bomb

// ------------------------------
// This is executed at Secure EL2
sel2_entry_point:
	writeln hi_from_sel2
	mov	x0, 0x42
	smc	#ESR_ISS_RMV_RETURN

// Must not reach here
	writeln unreachable
	bomb

.section ".rodata"
abt_sync_sp0:
	.asciz "Current EL with SP0: Synchronous abort!\r\n"
abt_irq_sp0:
	.asciz "Current EL with SP0: IRQ/vIRQ!\r\n"
abt_fiq_sp0:
	.asciz "Current EL with SP0: FIQ/vFIQ!\r\n"
abt_serror_sp0:
	.asciz "Current EL with SP0: SError/vSError!\r\n"

abt_sync_spx:
	.asciz "Current EL with SPx: Synchronous abort!\r\n"
abt_irq_spx:
	.asciz "Current EL with SPx: IRQ/vIRQ!\r\n"
abt_fiq_spx:
	.asciz "Current EL with SPx: FIQ/vFIQ!\r\n"
abt_serror_spx:
	.asciz "Current EL with SPx: SError/vSError!\r\n"

abt_sync_lel:
	.asciz "Lower EL using AArch64: Synchronous abort!\r\n"
abt_irq_lel:
	.asciz "Lower EL using AArch64: IRQ/vIRQ!\r\n"
abt_fiq_lel:
	.asciz "Lower EL using AArch64: FIQ/vFIQ!\r\n"
abt_serror_lel:
	.asciz "Lower EL using AArch64: SError/vSError!\r\n"

abt_sync_lel_a32:
	.asciz "Lower EL using AArch32: Synchronous abort!\r\n"
abt_irq_lel_a32:
	.asciz "Lower EL using AArch32: IRQ/vIRQ!\r\n"
abt_fiq_lel_a32:
	.asciz "Lower EL using AArch32: FIQ/vFIQ!\r\n"
abt_serror_lel_a32:
	.asciz "Lower EL using AArch32: SError/vSError!\r\n"

rmv_call:
	.asciz "RMV call X0=0x"
hi_from_sel2:
	.asciz "Hi from S-EL2\r\n"
rmv_return:
	.asciz "Bye from S-EL2\r\n"
unreachable:
	.asciz "What r u doing here, bro?\r\n"
