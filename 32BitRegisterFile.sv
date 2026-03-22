// ------------------------------------------------------------
// Module: MiPSRegFile
// Description:
//   This module implements a 32-bit MIPS register file.
//
//   - 32 registers total
//   - Each register is 32 bits wide
//   - Two read ports  (RD1 and RD2)
//   - One write port (WD3)
//   - Register 0 is hardwired to zero
//
// Inputs:
//   clk : Clock signal
//   WE3 : Write enable for the write port
//   A1  : Read address for output RD1
//   A2  : Read address for output RD2
//   A3  : Write address for input WD3
//   WD3 : Data to be written into the register file
//
// Outputs:
//   RD1 : Data read from register A1
//   RD2 : Data read from register A2
//
// Notes:
//   1. Reads are asynchronous, meaning RD1 and RD2 update
//      immediately when A1 or A2 changes.
//   2. Writes are synchronous, meaning data is written only
//      on the rising edge of the clock.
//   3. Register 0 always returns 0 and cannot be overwritten,
//      matching standard MIPS behavior.
// ------------------------------------------------------------

module MiPSRegFile (
    input  logic        clk,   // Clock signal
    input  logic        WE3,   // Write enable
    input  logic [4:0]  A1,    // Read address 1
    input  logic [4:0]  A2,    // Read address 2
    input  logic [4:0]  A3,    // Write address
    input  logic [31:0] WD3,   // Write data
    output logic [31:0] RD1,   // Read data 1
    output logic [31:0] RD2    // Read data 2
);

    // --------------------------------------------------------
    // Register storage:
    // 32 registers, each 32 bits wide
    // rf[0] through rf[31]
    // --------------------------------------------------------
    logic [31:0] rf [31:0];

    // --------------------------------------------------------
    // Asynchronous read logic
    //
    // If the read address is 0, return 0 directly instead of
    // reading from rf[0]. This guarantees that register 0
    // always behaves as the MIPS $zero register.
    // --------------------------------------------------------
    assign RD1 = (A1 == 5'd0) ? 32'd0 : rf[A1];
    assign RD2 = (A2 == 5'd0) ? 32'd0 : rf[A2];

    // --------------------------------------------------------
    // Synchronous write logic
    //
    // On each rising clock edge:
    //   - If WE3 is asserted, write WD3 into register rf[A3]
    //   - Ignore the write if A3 = 0 so that register 0
    //     remains permanently equal to zero
    // --------------------------------------------------------
    always_ff @(posedge clk) begin
        if (WE3 && (A3 != 5'd0))
            rf[A3] <= WD3;
    end

endmodule