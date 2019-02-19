#include <global.inc>

// Print asciiz line
// Input: x0 - asciz string address
// Corrupts: x0, x1, x2, x3, x29
	.macro writeln, addr
	mov	x29, lr
	adr	x3, \addr
99:
	ldrb	w0, [x3], #1
	cbz	w0, 98f
	bl	putch
	b	99b
98:
	mov	lr, x29
	.endm
