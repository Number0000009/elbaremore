/*
 * Minimal PL011 UART
 * Per ARM DDI 0183F
 */

#include <platform.inc>
#include <global.inc>

// Transmit a character at default baud rate, 8n1
// Input: w0 - char
// Corrupts: x1, x2
	.global putch
putch:
	mov	x1, #PL011_UART0_BASE
1:
	ldrb	w2, [x1, #PL011_UARTFR]
	ands	w2, w2, #PL011_UART_TXFE
	b.eq	1b
	strb	w0, [x1, #PL011_UARTDR]
	ret

// Print asciiz line
// Input: x0 - asciz string address
// Corrupts: x0, x1, x2, x3, x29
	.global writeln
writeln:
	mov	x29, lr
	mov	x3, x0
1:
	ldrb	w0, [x3], #1
	cbz	w0, 2f
	bl	putch
	b	1b
2:
	ret	x29

// Print 64-bit hex integer in long form i.e. 0042 - > 0042
// Input: x0 - 64-bit integer to output
// Corrupts x0, x1, x2, x3, x27, x28, x29
	.global phex64
phex64:
	mov	x29, lr
	mov	x28, #64/4
	mov	x27, x0
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
	ret	x29
