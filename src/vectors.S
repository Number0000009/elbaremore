#include <global.inc>
#include <uart_macros.inc>
#include <bomb_macros.inc>

// TODO: this should be living in Trusted Boot ROM
	.global el3_vectors

// 0 - 0x200
	.balign 0x800
el3_vectors:
.balign 0x80
el3_vector_sync_sp0:
	writeln abt_sync_sp0
	bomb

.balign 0x80
el3_vector_irq_sp0:
	writeln abt_irq_sp0
	bomb

.balign 0x80
el3_vector_fiq_sp0:
	writeln abt_fiq_sp0
	bomb

.balign 0x80
el3_vector_serror_sp0:
	writeln abt_serror_sp0
	bomb

// 0x200 - 0x400
.balign 0x80
el3_vector_sync_spx:
	writeln abt_sync_spx
	bomb

.balign 0x80
el3_vector_irq_spx:
	writeln abt_irq_spx
	bomb

.balign 0x80
el3_vector_fiq_spx:
	writeln abt_fiq_spx
	bomb

.balign 0x80
el3_vector_serror_spx:
	writeln abt_serror_spx
	bomb

// 0x400 - 0x600
.balign 0x80
el3_vector_sync_lel:
	writeln abt_sync_lel
	bomb

.balign 0x80
el3_vector_irq_lel:
	writeln abt_irq_lel
	bomb

.balign 0x80
el3_vector_fiq_lel:
	writeln abt_fiq_lel
	bomb

.balign 0x80
el3_vector_serror_lel:
	writeln abt_serror_lel
	bomb

// 0x600 - 0x800
.balign 0x80
el3_vector_sync_lel_a32:
	writeln abt_sync_lel_a32
	bomb

.balign 0x80
el3_vector_irq_lel_a32:
	writeln abt_irq_lel_a32
	bomb

.balign 0x80
el3_vector_fiq_lel_a32:
	writeln abt_fiq_lel_a32
	bomb

.balign 0x80
el3_vector_serror_lel_32:
	writeln abt_serror_lel_a32
	bomb

.section ".rodata"
abt_sync_sp0:
	.asciz "Current EL with SP0: Synchronous abort!\r\n"
abt_irq_sp0:
	.asciz "Current EL with SP0: IRQ/vIRQ!\r\n"
abt_fiq_sp0:
	.asciz "Current EL with SP0: FIQ/vFIQ!\r\n"
abt_serror_sp0:
	.asciz "Current EL with SP0: SError/vSError!\r\n"

abt_sync_spx:
	.asciz "Current EL with SPx: Synchronous abort!\r\n"
abt_irq_spx:
	.asciz "Current EL with SPx: IRQ/vIRQ!\r\n"
abt_fiq_spx:
	.asciz "Current EL with SPx: FIQ/vFIQ!\r\n"
abt_serror_spx:
	.asciz "Current EL with SPx: SError/vSError!\r\n"

abt_sync_lel:
	.asciz "Lower EL using AArch64: Synchronous abort!\r\n"
abt_irq_lel:
	.asciz "Lower EL using AArch64: IRQ/vIRQ!\r\n"
abt_fiq_lel:
	.asciz "Lower EL using AArch64: FIQ/vFIQ!\r\n"
abt_serror_lel:
	.asciz "Lower EL using AArch64: SError/vSError!\r\n"

abt_sync_lel_a32:
	.asciz "Lower EL using AArch32: Synchronous abort!\r\n"
abt_irq_lel_a32:
	.asciz "Lower EL using AArch32: IRQ/vIRQ!\r\n"
abt_fiq_lel_a32:
	.asciz "Lower EL using AArch32: FIQ/vFIQ!\r\n"
abt_serror_lel_a32:
	.asciz "Lower EL using AArch32: SError/vSError!\r\n"
