rmm_call:
	.asciz "RMM call X0=0x"
hi_from_sel2:
	.asciz "Hi from S-EL2\r\n"
rmm_return:
	.asciz "Bye from S-EL2\r\n"

// global strings

	.global unreachable
unreachable:
	.asciz "What r u doing here, bro?\r\n"

	.global crlf
crlf:
	.asciz "\r\n"

	.global current_el
current_el:
	.asciz "Current EL = EL"

	.global relocate_kernel_from
relocate_kernel_from:
	.asciz "Relocating kernel from 0x"

	.global relocate_kernel_to
relocate_kernel_to:
	.asciz "\tto 0x"

	.global relocate_dtb_from
relocate_dtb_from:
	.asciz "Relocating DTB from 0x"

	.global relocate_dtb_to
relocate_dtb_to:
	.asciz "\tto 0x"

	.global enter_kernel
enter_kernel:
	.asciz "Booting Linux\r\n"
