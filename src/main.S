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
	adr	x0, hello_world
	bl	writeln

	ldr	x0, =0x1a2b3c4d5e6f7788
	bl	phex64
	b	.

.section ".rodata"
hello_world:
	.asciz "TEST test TeSt\r\n"
