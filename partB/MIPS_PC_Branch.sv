// ------------------------------------------------------------
// Module: MIPS_PC_Branch
// Description:
//   Computes the branch target address for branch instructions.
//
// Inputs:
//   A : PC + 4
//   B : Shifted branch immediate (SignImm << 2)
//
// Output:
//   Y : Branch target address
//
// Notes:
//   - Used for branch instructions such as beq
//   - Branch target = PC + 4 + (sign-extended immediate << 2)
// ------------------------------------------------------------

module MIPS_PC_Branch (
    input  logic [31:0] A,   // PC + 4
    input  logic [31:0] B,   // Shifted branch offset
    output logic [31:0] Y    // Branch target address
);

    assign Y = A + B;

endmodule