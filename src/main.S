#include <uart_macros.inc>
#include <bomb_macros.inc>

	.global main
main:
// Park secondary cores
	mrs	x0, MPIDR_EL1
	tst	x0, #0x0f	// not b0000 (not a primary CPU) - goto stop
	b.eq	primary_cpu_continue

// TODO: read mailbox
	bomb

primary_cpu_continue:
	adr	x0, el3_vectors
	msr	VBAR_EL3, x0
	isb

	writeln current_el

// print current EL
	mrs	x0, CurrentEL
	ubfm	w0, w0, #2, #31
	add	w0, w0, '0'
	bl	putch
	writeln crlf

	hlt #17

// End
	bomb

.section ".rodata"
current_el:
	.asciz "Current EL = EL"
crlf:
	.asciz "\r\n"
