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
	b	.
