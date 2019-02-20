#define lr x30

// Taken from bootwrapper arch/aarch64/include/asm/cpu.h
#define SPSR_A		(1 << 8)	/* System Error masked */
#define SPSR_D		(1 << 9)	/* Debug masked */
#define SPSR_I		(1 << 7)	/* IRQ masked */
#define SPSR_F		(1 << 6)	/* FIQ masked */
#define SPSR_T		(1 << 5)	/* Thumb */
#define SPSR_EL2H	(9 << 0)	/* EL2 Handler mode */
#define SPSR_HYP	(0x1a << 0)	/* M[3:0] = hyp, M[4] = AArch32 */

#define SPSR_KERNEL	(SPSR_A | SPSR_D | SPSR_I | SPSR_F | SPSR_EL2H)

// Taken from bootwrapper arch/aarch64/include/asm/gic-v3.h
#define ICC_SRE_EL3	S3_6_C12_C12_5

#define ICC_SRE_EL3_Enable	(1 << 3)	/* EL2 accesses to ICC_SRE_EL1
						 * and ICC_SRE_EL2 do not
						 * trap to EL3.
						 */
#define ICC_SRE_EL3_SRE		(1 << 0)	/* The System register
						 * interface to the ICH_*
						 * registers and the EL1, EL2,
						 * and EL3 ICC_* registers is
						 * enabled for EL3.
						 */
