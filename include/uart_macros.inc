/*
 * Minimal PL011 UART
 * Per ARM DDI 0183F
 */

#define PL011_UARTDR		0x00
#define PL011_UARTFR		0x18
#define PL011_UART_TXFE		(1<<7)
#define PL011_UART0_BASE	0x1c090000

// Transmit a character at default baud rate and flow control
// Input: char - char
	.macro putch, char

	stp	x1, x2, [sp, #-16]!
	str	x0,	[sp, #-8]!

	mov	w0, \char

	mov	x1, #PL011_UART0_BASE
100:
	ldrb	w2, [x1, #PL011_UARTFR]
	and	w2, w2, #PL011_UART_TXFE
	cbz	w2, 100b

	strb	w0, [x1, #PL011_UARTDR]

	ldr	x0,	[sp], #8
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

// Print hex number of len digits
// Input: number - integer hex number, len - number of digits
	.macro prhex, number, len

	.if \number == \len
	.error	"This combo isn't supported"
	.endif

	stp	x0, x1, [sp, #-16]!
	str	x2,	[sp, #-8]!

	eor	x2, \len, \number
	.if	\len != x2
	eor	x0, x2, \len
	eor	x1, x2, x0
	.else
	eor	x1, x2, \number
	eor	x0, x2, x1
	.endif
97:
	orr	x0, xzr, x0, ror #60
	and	x2, x0, #0xf
	cmp	x2, #0xa

	add	x2, x2, #'0'
	blo	96f
	add	x2, x2, #'a' - 10 - '0'
96:
	putch w2
	sub	x1, x1, #1
	cbnz	x1, 97b

	ldr	x2,	[sp], #8
	ldp	x0, x1, [sp], #16

	.endm

// Print 64-bit hex integer in long form i.e. 0042 - > 0042
// Input: number - 64-bit integer register to output
	.macro prlhex64, number

	stp	x0, x1, [sp, #-16]!

	mov	x1, \number
	mov	x0, #64/4

	prhex x1, x0

	ldp	x0, x1, [sp], #16
	.endm

// Print 64-bit hex integer in short form i.e. 0042 - > 42
// Input: number - 64-bit integer register to output
	.macro prshex64, number

	stp	x0, x1, [sp, #-16]!
	str	x2,	[sp, #-8]!

	mov	x2, \number
	mov	x1, #64/4

	clz	x0, x2
	lsr	x0, x0, #2
	sub	x1, x1, x0
	lsl	x0, x0, #2
	lsl	x2, x2, x0

	prhex x2, x1

	ldr	x2,	[sp], #8
	ldp	x0, x1, [sp], #16
	.endm

// Print 64-bit hex integer in long form i.e. 0042 - > 0042
// Input: number - 64-bit integer to output
	.macro plhex64, number
	str	x0, [sp, #-8]!

	ldr	x0, =\number
	prlhex64 x0

	ldr	x0, [sp], #8
	.endm

// Print 64-bit hex integer in short form i.e. 0042 - > 42
// Input: number - 64-bit integer to output
	.macro pshex64, number
	str	x0, [sp, #-8]!

	ldr	x0, =\number
	prshex64 x0

	ldr	x0, [sp], #8
	.endm

// Print CR-LF
// Input:
	.macro writecrlf
	writeln crlf_msg
	.endm
