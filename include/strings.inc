rmm_call:
	.asciz "RMM call X0=0x"
rmm_return:
	.asciz "Return from RMM call\r\n"
call_read:
	.asciz "RMM.Read\r\n"
call_write:
	.asciz "RMM.Write\r\n"
call_unknown:
	.asciz "Unknown RMM call\r\n"

// global strings

	.global unreachable
unreachable:
	.asciz "*** Reached the unreacheable ***\r\n"

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
