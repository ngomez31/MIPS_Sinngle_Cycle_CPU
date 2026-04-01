// ------------------------------------------------------------
// Module: MIPS_SL2_26
// Description:
//   This module shifts a 26-bit input left by 2 bits.
//
// Input:
//   A : 26-bit jump target field from instruction
//
// Output:
//   Y : 28-bit shifted result
//
// Notes:
//   - Used for MIPS jump address calculation
//   - The 26-bit jump field represents a word address
//   - Shifting left by 2 converts it into a byte-aligned
//     28-bit address portion
//   - The full jump address is formed by concatenating:
//         {PCPlus4[31:28], Y}
// ------------------------------------------------------------

module MIPS_SL2_26 (
    input  logic [25:0] A,   // 26-bit jump field
    output logic [27:0] Y    // Shifted 28-bit result
);

    assign Y = {A, 2'b00};

endmodule