#include <global.inc>

// Print asciiz line
// Input: addr - asciz string address
	.macro writeln, addr
	stp	x0, x1, [sp, #-16]!
	str	lr, 	[sp, #-8]!

	adr	x1, \addr
99:
	ldrb	w0, [x1], #1
	cbz	w0, 98f
	bl	putch
	b	99b
98:
	ldr	lr, [sp], #8
	ldp	x0, x1, [sp], #16
	.endm

// Print 64-bit hex integer in long form i.e. 0042 - > 0042
// Input: number - 64-bit integer register to output
	.macro hex64, number

	stp	x0, x1, [sp, #-16]!
	stp	x2, lr, [sp, #-16]!

	mov	x1, \number
	mov	x2, #64/4
1:
	orr	x1, xzr, x1, ror #60
	and	x0, x1, #0xf
	cmp	x0, #0xa

	add	x0, x0, #'0'
	blo	2f
	add	x0, x0, #'a' - 10 - '0'
2:
	bl	putch
	sub	x2, x2, #1
	cbnz	x2, 1b

	ldp	x2, lr, [sp], #16
	ldp	x0, x1, [sp], #16
	.endm

// Print 64-bit hex integer in long form i.e. 0042 - > 0042
// Input: number - 64-bit integer to output
	.macro phex64, number
	str	x0, [sp, #-8]!

	ldr	x0, =\number
	hex64 x0

	ldr	x0, [sp], #8
	.endm

// Print 64-bit hex integer in long form i.e. 0042 - > 0042
// Input: number - 64-bit integer register to output
	.macro prhex64, number
	str	x0, [sp, #-8]!

	mov	x0, \number
	hex64 x0

	ldr	x0, [sp], #8
	.endm

// Print CR-LF
// Input:
	.macro writecrlf
	writeln crlf
	.endm
