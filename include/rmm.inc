// This is executed at Secure EL2
// TODO: this is S-EL2 RMM, impement it
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
	smc	#ESR_ISS_RMM_RETURN

// Must not reach here
	writeln unreachable
	bomb