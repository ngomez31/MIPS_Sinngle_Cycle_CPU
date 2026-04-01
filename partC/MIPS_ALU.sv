// ------------------------------------------------------------
// Module: MIPS_ALU
// Description:
//   32-bit ALU for a MIPS processor
//
// Inputs:
//   A    : First 32-bit operand
//   B    : Second 32-bit operand
//   F    : 3-bit ALU control signal
//
// Outputs:
//   Y    : 32-bit ALU result
//   zero : Set to 1 when Y == 0
//
// Supported operations:
//   F = 000 -> AND
//   F = 001 -> OR
//   F = 010 -> ADD
//   F = 110 -> SUB
//   F = 111 -> SLT  (signed set-on-less-than)
//
// Notes:
//   - SUB and SLT are both implemented using A - B
//   - SLT must account for signed overflow
// ------------------------------------------------------------

module MIPS_ALU(
	input  logic [31:0] A,
    	input  logic [31:0] B,
    	input  logic [2:0]  F,
    	output logic [31:0] Y,
    	output logic        zero
);

    	logic [31:0] BB;         // Possibly inverted B input
    	logic [31:0] Sum;        // Output of adder
    	logic        Cout;       // Carry-out from adder
    	logic        Overflow;   // Signed overflow flag
    	logic        Less;       // Result for SLT
	logic        LessU;      // Result for SLTU (unsigned set-on-less-than)

    	// --------------------------------------------------------
    	// For subtraction and SLT, invert B and add 1
    	// F[2] = 1 for SUB (110) and SLT (111)
    	// --------------------------------------------------------
    	assign BB = F[2] ? ~B : B;

    	// Adder performs:
    	//   A + B      when F[2] = 0
    	//   A + ~B + 1 when F[2] = 1  -> A - B
    	adder #(32) myadder (
        	.a   (A),
        	.b   (BB),
        	.cin (F[2]),
        	.s   (Sum),
        	.cout(Cout)
    	);

    	// --------------------------------------------------------
    	// Signed overflow detection
    	//
    	// Overflow occurs when:
    	//   - adding two positives gives a negative
    	//   - adding two negatives gives a positive
    	//
    	// Since subtraction is implemented as A + ~B + 1,
    	// this formula still works with the adder inputs.
    	// --------------------------------------------------------
    	assign Overflow = ~(A[31] ^ BB[31]) & (A[31] ^ Sum[31]);

    	// --------------------------------------------------------
    	// Signed SLT result
    	//
    	// For signed comparison:
    	//   Less = sign of subtraction corrected for overflow
    	// --------------------------------------------------------
    	assign Less = Sum[31] ^ Overflow;

    	// --------------------------------------------------------
	// Part C Modification
    	// Unsigned SLTU result
    	//
    	// For unsigned comparison:
    	//   LessU = 1 when A < B using unsigned interpretation
    	// --------------------------------------------------------
    	assign LessU = (A < B);

    	// --------------------------------------------------------
    	// ALU result selection
    	// --------------------------------------------------------
    	always_comb begin
        	case (F)
            	3'b000: Y = A & B;               // AND
            	3'b001: Y = A | B;               // OR
            	3'b011: Y = {31'b0, LessU};      // SLTU - Part C Modification
            	3'b010: Y = Sum;                 // ADD
            	3'b110: Y = Sum;                 // SUB
            	3'b111: Y = {31'b0, Less};       // SLT
            	default: Y = 32'b0;              // Default safe value
        	endcase
    	end

    	// --------------------------------------------------------
    	// Zero flag
    	// Asserted when ALU result is zero
    	// --------------------------------------------------------
    	assign zero = (Y == 32'b0);

endmodule


// ------------------------------------------------------------
// Module: adder
// Description:
//   Parameterized N-bit adder
// ------------------------------------------------------------
module adder #(parameter N = 32) (
	input  logic [N-1:0] a,
    	input  logic [N-1:0] b,
    	input  logic         cin,
    	output logic [N-1:0] s,
    	output logic         cout
);

    	assign {cout, s} = a + b + cin;

endmodule
