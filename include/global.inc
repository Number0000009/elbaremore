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
#define SPSR_SEL2	(SPSR_A | SPSR_D | SPSR_I | SPSR_F | SPSR_EL2H)

#define ESR_EC		(0b111111 << 26)
#define ESR_ISS		(0b111111111111111111111111 << 0)
#define ESR_EC_SMC	(0b010111 << 26)
// RMV call
#define ESR_ISS_RMV		666
// RMV request completed in S-EL2
#define ESR_ISS_RMV_RETURN	777

// Taken from boot-wrapper arch/aarch64/include/asm/gic-v3.h
#define ICC_SRE_EL3	S3_6_C12_C12_5
#define ICC_CTLR_EL3	S3_6_C12_C12_4

// Per boot-wrapper/gic-v3.c
#define GICR_WAKER		0x14
#define GICR_IGROUP0		0x80
#define GICR_IGRPMOD0		0xD00

#define GICR_WAKER_ProcessorSleep	(1 << 1)

// from arch/arm64/boot/dts/arm/foundation-v8-gicv3.dts
#define GIC_RDIST_BASE		0x2f100000

#define GIC_RDIST_WAKER		(GIC_RDIST_BASE + GICR_WAKER)

#define ICC_SRE_EL3_Enable	(1 << 3)	/* EL2 accesses to ICC_SRE_EL1
						 * and ICC_SRE_EL2 do not
						 * trap to EL3. */
#define ICC_SRE_EL3_SRE		(1 << 0)	/* The System register
						 * interface to the ICH_*
						 * registers and the EL1, EL2,
						 * and EL3 ICC_* registers is
						 * enabled for EL3. */

#define SCR_RW		(1 << 10)	/* The next lower level is AArch64. */
#define SCR_NS		(1 << 0)	/* Exception levels lower than
					 * EL3 are in Non-secure state. */
#define SCR_EEL2	(1 << 18)	/* All behaviors associated with
					 * Secure EL2 are enabled */
#define SCTLR_M		(1 << 0)	/* MMU disabled */
