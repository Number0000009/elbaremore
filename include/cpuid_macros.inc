// Return processor id
// Input:
// Corrupts: x0
// TODO: Only supports MPIDR_EL1.Aff0
	.macro cpuid, ret
	mrs	\ret, MPIDR_EL1
	and	\ret, \ret, #0x0f
	.endm
