rmm_call_msg:
	.asciz "RMM call X0=0x"
rmm_return_msg:
	.asciz "Return from RMM call\r\n"
call_read_msg:
	.asciz "RMM.Read\r\n"
call_write_msg:
	.asciz "RMM.Write\r\n"
call_unknown_msg:
	.asciz "Unknown RMM call\r\n"
unreachable_msg:
	.asciz "*** Reached the unreacheable ***\r\n"
crlf_msg:
	.asciz "\r\n"
current_el_msg:
	.asciz "Current EL = EL"
relocate_kernel_from_msg:
	.asciz "Relocating kernel from 0x"
relocate_kernel_to_msg:
	.asciz "\tto 0x"
relocate_dtb_from_msg:
	.asciz "Relocating DTB from 0x"
relocate_dtb_to_msg:
	.asciz "\tto 0x"
enter_kernel_msg:
	.asciz "Booting Linux\r\n"
