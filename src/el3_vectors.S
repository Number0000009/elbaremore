#include <global.inc>
#include <uart_macros.inc>
#include <cpuid_macros.inc>
#include <bomb_macros.inc>
#include <vectors.inc>
#include <handlers.inc>

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
// Validate SMC call issuer
// 1. is this an SMC call?
	mrs	x9, ESR_EL3
	and	x10, x9, #ESR_EC

	ldr	x11, =ESR_EC_SMC
	cmp	x11, x10
	b.ne	.default		// Nope

// 2. #imm16 == ESR_ISS_RMM?
	and	x10, x9, #ESR_ISS
	cmp	x10, #ESR_ISS_RMM
	b.ne	.is_not_rmm_call	// SMC, but not to RMM
//is_rmm_call:

	b	.rmm_call_handler

.is_not_rmm_call:
	cmp	x10, #ESR_ISS_RMM_RETURN
	b.eq	.rmm_return

	b	.default

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

.section ".rodata"
#include <strings.inc>