/*
 * Minimal PL011 UART
 * Per ARM DDI 0183F
 */

#include <platform.inc>

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
