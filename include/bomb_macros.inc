// Stop machine
// TODO: add some red LEDs
	.macro bomb
	wfe
	b	.-4
	.endm
