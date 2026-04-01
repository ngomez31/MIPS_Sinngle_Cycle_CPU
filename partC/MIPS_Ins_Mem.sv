// ------------------------------------------------------------
// Module: MIPS_Ins_Mem
// Description:
//   Simple 32-word instruction memory for a 32-bit MIPS CPU.
//
//   - Input  A  : 32-bit byte address from the PC
//   - Output RD : 32-bit instruction stored at that address
//
// Notes:
//   1. Each memory location stores one 32-bit instruction.
//   2. Since MIPS instructions are word-aligned (4 bytes each),
//      the lower 2 bits of the address are ignored.
//   3. A[6:2] is used as the memory index.
//   4. Program contents are loaded from memfile_c.dat using
//    $readmemh, as required in Part C.
// ------------------------------------------------------------

module MIPS_Ins_Mem(
    input  logic [31:0] A,
    output logic [31:0] RD
);

    // 32-word memory, each word is 32 bits wide
    logic [31:0] mem [0:31];
    integer i;

    // --------------------------------------------------------
    // Initialize instruction memory
    // First clear memory, then load machine code from file
    // --------------------------------------------------------
    initial begin
        for (i = 0; i < 32; i = i + 1)
            mem[i] = 32'h00000000;

        $readmemh("memfile_c.dat", mem); // Part C modification
    end

    // --------------------------------------------------------
    // Asynchronous read
    // A[6:2] converts byte address to word index
    // --------------------------------------------------------
    assign RD = mem[A[6:2]];

endmodule