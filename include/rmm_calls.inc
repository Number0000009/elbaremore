// RMM calls table:

// Retrieve X0 from S-EL2
// Returns: X0 = previously written value or garbage if uninitialized
#define ESR_ISS_RMM_READ	777

// Send X0 to S-EL2
// Store X0 into storage
// Returns: X0 = 0 for OK (not that there can be anything else yet)
#define ESR_ISS_RMM_WRITE	666

// RMM request completed in S-EL2 and RMM is returning to EL3
#define ESR_ISS_RMM_RETURN	0
