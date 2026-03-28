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
        	.clk(clk),
        	.reset(reset),
        	.pc(pc),
        	.instr(instr),
        	.alu_out(alu_out),
        	.write_data(write_data),
        	.read_data(read_data),
        	.memwrite(memwrite)
    	);

    	// Clock generation: 10 time unit period
    	initial begin
        	clk = 0;
        	forever #5 clk = ~clk;
    	end

    	// Reset and simulation control
    	initial begin
        	reset = 1;
        	#12;
        	reset = 0;

        	// let CPU run for a while
        	#300;

        	$stop;
    	end

endmodule