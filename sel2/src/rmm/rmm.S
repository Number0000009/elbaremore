#include <rmm_calls.inc>
#include <uart_macros.inc>
#include <bomb_macros.inc>
#include <cpuid_macros.inc>

#define S_X0		0x38

// This is executed at Secure EL2
// TODO: this is S-EL2 RMM, impement it
// TODO: what context should look like?
	stp	x0, x1, [sp, #-16]!
	stp	x2, x3, [sp, #-16]!
	stp	x4, x5, [sp, #-16]!
	stp	x6, x7, [sp, #-16]!
	str	x8,	[sp, #-8]!

	cmp	x10, #ESR_ISS_RMM_READ
	b.eq	.rmm_call_read

	cmp	x10, #ESR_ISS_RMM_WRITE
	b.eq	.rmm_call_write

	b	.rmm_call_unknown

// Must not reach here
	writeln unreachable_msg
	bomb

.rmm_call_return:
// End of RMM
	ldr	x8,	[sp], #8
	ldp	x6, x7, [sp], #16
	ldp	x4, x5, [sp], #16
	ldp	x2, x3, [sp], #16
	ldp	x0, x1, [sp], #16

	smc	#ESR_ISS_RMM_RETURN

.rmm_call_unknown:
	writeln call_unknown_msg
	b	.rmm_call_return

.rmm_call_read:
	writeln call_read_msg

	ldr	x10, =storage
	ldr	x0, [x10]

	b	.rmm_call_return

.rmm_call_write:
	writeln call_write_msg

	ldr	x10, =storage
	mov	x11, #storage_size
	cpuid	x12
	umaddl	x10, w12, w11, x10
	str	x0, [x10]

	mov	x0, xzr
	str	x0, [sp, #S_X0]

	b	.rmm_call_return

#include <strings.inc>

.section ".bss"
storage:
	.space (storage_size * 4)
