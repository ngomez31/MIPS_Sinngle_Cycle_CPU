// ------------------------------------------------------------
// Module: Sign_Extend_32
// Description:
//   This module performs sign extension from 16 bits to 32 bits
//   for MIPS immediate values.
//
// Input:
//   A : 16-bit immediate field from instruction
//
// Output:
//   Y : 32-bit sign-extended value
//
// Notes:
//   - If A[15] = 0, the upper 16 bits are filled with 0s
//   - If A[15] = 1, the upper 16 bits are filled with 1s
//   - Used for instructions such as:
//       addi, lw, sw, beq, slti
// ------------------------------------------------------------
module Sign_Extend_32( 
	input  logic  [15:0] A,
	output logic  [31:0] Y
);

	//Replicate the sign bit A[15] into the upper 16 bits
	assign Y = {{16[A[15]},A};
endmodule