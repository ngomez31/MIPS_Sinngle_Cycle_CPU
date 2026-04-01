// ------------------------------------------------------------
// Module: MIPS_PC_4
// Description:
//   Computes the next sequential instruction address by
//   adding 4 to the current PC value.
//
// Input:
//   A : Current program counter (PC)
//
// Output:
//   Y : PC + 4
//
// Notes:
//   - MIPS instructions are 32 bits (4 bytes) wide
//   - Advancing to the next instruction requires adding 4
// ------------------------------------------------------------

module MIPS_PC_4 (
    input  logic [31:0] A,   // Current PC
    output logic [31:0] Y    // PC + 4
);

    assign Y = A + 32'd4;

endmodule