module tb_MIPS_Top;

    logic clk;
    logic reset;
    logic [31:0] pc;
    logic [31:0] instr;
    logic [31:0] alu_out;
    logic [31:0] write_data;
    logic [31:0] read_data;
    logic memwrite;

    // Instantiate top-level CPU
    MIPS_Top dut (
        .clk        (clk),
        .reset      (reset),
        .pc         (pc),
        .instr      (instr),
        .alu_out    (alu_out),
        .write_data (write_data),
        .read_data  (read_data),
        .memwrite   (memwrite)
    );

    // Clock generation: 10 time unit period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset sequence
    initial begin
        reset = 1;
        #12;
        reset = 0;
    end

    // --------------------------------------------------------
    // Part C success check
    // Expected final store:
    //   sw $8, 16($0)
    // So when memwrite is asserted, we check:
    //   alu_out    = 16
    //   write_data = -6 (0xFFFFFFFA)
    // --------------------------------------------------------
    always @(negedge clk) begin
        if (memwrite) begin
            if (alu_out === 32'd16 && write_data === 32'hFFFFFFFA) begin
                $display("Simulation succeeded.");
                $stop;
            end
        end
    end

endmodule