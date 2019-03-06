// Return processor id
// Input:
// Corrupts: \ret
// TODO: Only supports MPIDR_EL1.Aff0
	.macro cpuid, ret
	mrs	\ret, MPIDR_EL1
	and	\ret, \ret, #0x0f
	.endm

/* Allocate per cpu id stacks
 * BOTTOM			  TOP
 * o-------o-------o-------o-------o
 * ^\_____/^\_____/^\_____/^\_____/^
 *  id = 3     2       1       0
 */
 // Input: top - stack top, size - stack size
 // Outout: \out - stack pointer
 // Corrupts: \out, x10, x11
	.macro allocate_stack top, size, out
	mov	\out, \top
	mov	w11, \size
	cpuid x10
	umsubl	\out, w10, w11, \out	// out = top - (cpu id * size)
	.endm
