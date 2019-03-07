/*
 * Minimal PL011 UART
 * Per ARM DDI 0183F
 */

#include <platform.inc>

// Transmit a character at default baud rate and flow control
// Input: char - char
	.macro putch, char

	stp	x1, x2, [sp, #-16]!

	mov	x1, #PL011_UART0_BASE
100:
	ldrb	w2, [x1, #PL011_UARTFR]
	and	w2, w2, #PL011_UART_TXFE
	cbz	w2, 100b

	strb	\char, [x1, #PL011_UARTDR]

	ldp	x1, x2, [sp], #16
	.endm

// Print asciiz line
// Input: addr - asciz string address
	.macro writeln, addr
	stp	x0, x1, [sp, #-16]!

	adr	x1, \addr
99:
	ldrb	w0, [x1], #1
	cbz	w0, 98f
	putch w0
	b	99b
98:
	ldp	x0, x1, [sp], #16
	.endm

// Print 64-bit hex integer in long form i.e. 0042 - > 0042
// Input: number - 64-bit integer register to output
	.macro prhex64, number

	stp	x0, x1, [sp, #-16]!
	str	x2,	[sp, #-8]!

	mov	x1, \number
	mov	x2, #64/4
97:
	orr	x1, xzr, x1, ror #60
	and	x0, x1, #0xf
	cmp	x0, #0xa

	add	x0, x0, #'0'
	blo	96f
	add	x0, x0, #'a' - 10 - '0'
96:
	putch w0
	sub	x2, x2, #1
	cbnz	x2, 97b

	ldr	x2,	[sp], #8
	ldp	x0, x1, [sp], #16
	.endm

// Print 64-bit hex integer in long form i.e. 0042 - > 0042
// Input: number - 64-bit integer to output
	.macro phex64, number
	str	x0, [sp, #-8]!

	ldr	x0, =\number
	prhex64 x0

	ldr	x0, [sp], #8
	.endm

// Print CR-LF
// Input:
	.macro writecrlf
	writeln crlf_msg
	.endm
