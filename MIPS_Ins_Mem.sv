// ------------------------------------------------------------
// Module: MIPS_Ins_Mem
// Description:
//   This module implements a simple 32-word instruction memory
//   for a 32-bit MIPS processor.
//
//   - Input  A  : 32-bit byte address from the PC
//   - Output RD : 32-bit instruction stored at that address
//
// Notes:
//   1. Each memory location stores one 32-bit instruction.
//   2. Since MIPS instructions are word-aligned (4 bytes each),
//      the lower 2 bits of the address are ignored.
//   3. A[6:2] is used as the memory index because:
//         - A[1:0] select bytes within a word, so they are dropped
//         - 5 bits (6:2) can address 32 memory locations
// ------------------------------------------------------------

module MIPS_Ins_Mem(
    input  logic [31:0] A,   // Byte address from Program Counter (PC)
    output logic [31:0] RD   // Instruction read from memory
);

    // 32-word memory, each word is 32 bits wide
    logic [31:0] mem [0:31];

    // --------------------------------------------------------
    // Instruction memory initialization
    // These values represent a small MIPS test program.
    // Each entry is one 32-bit machine instruction.
    // --------------------------------------------------------
    initial begin
        mem[0]  = 32'h20020005; // addi $2, $0, 5
        mem[1]  = 32'h2003000c; // addi $3, $0, 12
        mem[2]  = 32'h2067fff7; // addi $7, $3, -9
        mem[3]  = 32'h00e22025; // or   $4, $7, $2
        mem[4]  = 32'h00642824; // and  $5, $3, $4
        mem[5]  = 32'h00a42820; // add  $5, $5, $4
        mem[6]  = 32'h10a7000a; // beq  $5, $7, 10
        mem[7]  = 32'h0064202a; // slt  $4, $3, $4
        mem[8]  = 32'h10800001; // beq  $4, $0, 1
        mem[9]  = 32'h20050000; // addi $5, $0, 0
        mem[10] = 32'h00e2202a; // slt  $4, $7, $2
        mem[11] = 32'h00853820; // add  $7, $4, $5
        mem[12] = 32'h00e23822; // sub  $7, $7, $2
        mem[13] = 32'hac670044; // sw   $7, 68($3)
        mem[14] = 32'h8c020050; // lw   $2, 80($0)
        mem[15] = 32'h08000011; // j    17
        mem[16] = 32'h20020001; // addi $2, $0, 1
        mem[17] = 32'hac020054; // sw   $2, 84($0)
    end

    // --------------------------------------------------------
    // Asynchronous read:
    // Convert the byte address A into a word index by using A[6:2]
    // Example:
    //   A = 0x00000000 -> mem[0]
    //   A = 0x00000004 -> mem[1]
    //   A = 0x00000008 -> mem[2]
    // --------------------------------------------------------
    assign RD = mem[A[6:2]];

endmodule