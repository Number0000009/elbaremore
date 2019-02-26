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
