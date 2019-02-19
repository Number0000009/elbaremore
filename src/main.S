	.global main
main:
// Park secondary cores
	mrs	x0, mpidr_el1
	tst	x0, #0x0f	// not b0000 (not a primary CPU) - goto stop
	b.eq	primary_cpu_continue

// TODO: read mailbox
	wfe
	b	.-4

primary_cpu_continue:
	adr	x0, current_el
	bl	writeln

// print current EL
	mrs	x0, CurrentEL
	ubfm	w0, w0, #2, #31
	add	w0, w0, '0'
	bl	putch
	b	eol

.section ".rodata"
current_el:
	.asciz "Current EL = EL"
