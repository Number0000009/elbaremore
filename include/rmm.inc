// This is executed at Secure EL2
// TODO: this is S-EL2 RMM, impement it
sel2_entry_point:
// TODO: what context should look like?
	stp	x0, x1, [sp, #-16]!
	stp	x2, x3, [sp, #-16]!
	stp	x4, x5, [sp, #-16]!
	stp	x6, x7, [sp, #-16]!
	str	x8,	[sp, #-8]!

	writeln hi_from_sel2

	ldr	x8,	[sp], #8
	ldp	x6, x7, [sp], #16
	ldp	x4, x5, [sp], #16
	ldp	x2, x3, [sp], #16
	ldp	x0, x1, [sp], #16

	add	x0, x0, #1
// End of RMM
	smc	#ESR_ISS_RMM_RETURN

// Must not reach here
	writeln unreachable
	bomb