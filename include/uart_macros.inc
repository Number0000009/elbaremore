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

// Print 64-bit hex integer in long form i.e. 0042 - > 0042
// Input: x0 - 64-bit integer to output
// Corrupts x0, x1, x2, x3, x27, x28, x29
	.macro phex64, number
	mov	x29, lr
	mov	x28, #64/4
	ldr	x27, =\number
1:
	orr	x27, xzr, x27, ror #60
	and	x0, x27, #0xf
	cmp	x0, #0xa

	add	x0, x0, #'0'
	blo	2f
	add	x0, x0, #'a' - 10 - '0'
2:
	bl	putch
	sub	x28, x28, #1
	cbnz	x28, 1b

	mov	lr, x29
	.endm
