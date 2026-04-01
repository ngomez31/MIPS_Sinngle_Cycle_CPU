// ------------------------------------------------------------
// Module: MIPS_SL2_32
// Description:
//   This module shifts a 32-bit input left by 2 bits.
//
// Input:
//   A : 32-bit input value
//
// Output:
//   Y : 32-bit value equal to A shifted left by 2
//
// Notes:
//   - Used in MIPS branch address calculation
//   - Branch immediates represent word offsets
//   - Shifting left by 2 converts the offset to a byte address
// ------------------------------------------------------------
module MIPS_SL2_32(
	input  logic [31:0] A, // 32-bit input
	output logic [31:0] Y  // Shifted output
);

	assign Y = {A[29:0], 2'b00};
endmodule
