/*
 * Minimal PL011 UART
 * Per ARM DDI 0183F
 */

#include <platform.inc>
#include <global.inc>

// Transmit a character at default baud rate and flow control
// Input: w0 - char
	.global putch
putch:
	stp	x0, x1, [sp, #-16]!
	str	x2,	[sp, #-8]!

	mov	x1, #PL011_UART0_BASE
1:
	ldrb	w2, [x1, #PL011_UARTFR]
	and	w2, w2, #PL011_UART_TXFE
	cbz	w2, 1b
	strb	w0, [x1, #PL011_UARTDR]

	ldr	x2,	[sp], #8
	ldp	x0, x1, [sp], #16
	ret
