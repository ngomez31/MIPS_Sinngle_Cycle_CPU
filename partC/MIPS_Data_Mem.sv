// ------------------------------------------------------------
// Module: MIPS_Data_Mem
// Description:
//   This module implements a simple 32-word data memory
//   for a 32-bit MIPS processor.
//
//   - Supports one write port
//   - Supports one read port
//   - Memory is word-addressed
//
// Inputs:
//   clk : Clock signal
//   WE  : Write enable
//   A   : 32-bit byte address
//   WD  : 32-bit write data
//
// Outputs:
//   RD  : 32-bit data read from memory
//
// Notes:
//   1. Each memory location stores one 32-bit word.
//   2. Since MIPS accesses words on 4-byte boundaries,
//      the lower 2 bits of the address are ignored.
//   3. A[6:2] is used as the memory index because:
//         - A[1:0] select bytes within a word, so they are dropped
//         - 5 bits are enough to address 32 words
//   4. Reads are asynchronous.
//   5. Writes occur on the rising edge of the clock.
// ------------------------------------------------------------
module MIPS_Data_Mem(
    input  logic        clk,   // Clock signal
    input  logic        WE,    // Write enable
    input  logic [31:0] A,     // Byte address
    input  logic [31:0] WD,    // Write data
    output logic [31:0] RD     // Read data
);

    // --------------------------------------------------------
    // Data memory array:
    // 32 memory locations, each 32 bits wide
    // --------------------------------------------------------
	logic [31:0] mem [0:31];

    // --------------------------------------------------------
    // Asynchronous read:
    // Convert byte address A into a word index using A[6:2]
    // Example:
    //   A = 0x00000000 -> mem[0]
    //   A = 0x00000004 -> mem[1]
    //   A = 0x00000008 -> mem[2]
    // --------------------------------------------------------
	assign RD = mem[A[6:2]];

    // --------------------------------------------------------
    // Synchronous write:
    // On the rising edge of the clock, if WE is asserted,
    // store WD into the memory location selected by A[6:2]
    // --------------------------------------------------------
	always @(posedge clk) 
	  begin
	    if (WE)
               mem[A[6:2]] <= WD;
	  end
endmodule
