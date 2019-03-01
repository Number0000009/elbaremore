// Return processor id
// Input:
// Corrupts: \ret
// TODO: Only supports MPIDR_EL1.Aff0
	.macro cpuid, ret
	mrs	\ret, MPIDR_EL1
	and	\ret, \ret, #0x0f
	.endm

/* Setup per cpu id stacks
 * TOP				BOTTOM
 * o-------o-------o-------o-------o
 * ^\_____/^\_____/^\_____/^\_____/^
 *  id = 3     2       1       0
 */
 // Corrupts: x9, x10, x11, sp
	.macro setup_stacks
	mov	x9, #(EL3_STACK_TOP+1)
	cpuid x10
	mov	w11, #EL3_STACK_SIZE
	umsubl	x9, w10, w11, x9	// x9 = x9 - (w10 * w11)
	mov	sp, x9
	.endm
