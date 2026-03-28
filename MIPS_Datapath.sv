// ------------------------------------------------------------
// Module: MIPS_Datapath
// Description:
//   Single-cycle 32-bit MIPS datapath.
//
// Inputs:
//   clk        : Clock
//   reset      : Reset signal for PC
//   MemToReg   : Selects memory data for write-back
//   Branch     : Enables branch decision logic
//   ALUSrc     : Selects ALU second operand
//   RegDst     : Selects destination register
//   RegWrite   : Enables register file write
//   Jump       : Enables jump PC selection
//   MemWrite   : Enables data memory write
//   ALUControl : ALU operation select
//
// Outputs:
//   zero       : ALU zero flag
//   pc         : Current program counter
//   instr      : Current instruction
//   aluout     : ALU result
//   writedata  : Data written to memory
//   readdata   : Data read from memory
//
// Notes:
//   - This datapath assumes the control unit is external
//   - PC updates on the rising edge of the clock
// ------------------------------------------------------------

module MIPS_Datapath (
	input  logic        clk,
    	input  logic        reset,
    	input  logic        MemToReg,
    	input  logic        Branch,
    	input  logic        ALUSrc,
    	input  logic        RegDst,
    	input  logic        RegWrite,
    	input  logic        Jump,
    	input  logic        MemWrite,
    	input  logic [2:0]  ALUControl,

    	output logic        zero,
    	output logic [31:0] pc,
    	output logic [31:0] instr,
    	output logic [31:0] alu_out,
    	output logic [31:0] write_data,
    	output logic [31:0] read_data
);

    	// --------------------------------------------------------
    	// Internal signals
    	// --------------------------------------------------------
    	logic [31:0] pc_next;
    	logic [31:0] pc_plus4;
    	logic [31:0] pc_branch;
    	logic [31:0] sign_imm;
    	logic [31:0] sign_immsh;
    	logic [31:0] src_a;
    	logic [31:0] src_b;
    	logic [31:0] result;
    	logic [31:0] rd1;
    	logic [31:0] rd2;
    	logic [27:0] jump_shift;
    	logic [31:0] jump_addr;
    	logic [31:0] pc_pre_jump;
    	logic [4:0]  write_reg;
    	logic        pc_src;

    	// --------------------------------------------------------
    	// Program Counter register
    	// --------------------------------------------------------
    	always_ff @(posedge clk or posedge reset) 
	  begin
        	if (reset)
            		pc <= 32'b0;
        	else
            		pc <= pc_next;
    	  end

    	// --------------------------------------------------------
    	// Instruction Fetch
    	// --------------------------------------------------------
    	MIPS_Ins_Mem imem (
        	.A  (pc),
        	.RD (instr)
    	);

    	// --------------------------------------------------------
    	// Register File
    	// A1 = rs = instr[25:21]
    	// A2 = rt = instr[20:16]
    	// A3 = chosen destination register
    	// --------------------------------------------------------
    	MiPS_Reg_File regfile (
        	.clk (clk),
        	.WE3 (RegWrite),
        	.A1  (instr[25:21]),
        	.A2  (instr[20:16]),
        	.A3  (write_reg),
        	.WD3 (result),
        	.RD1 (rd1),
        	.RD2 (rd2)
    	);	

    	assign src_a      = rd1;
    	assign write_data = 
		(instr[31:26] == 6'b001000 ||
		 instr[31:26] == 6'b100011 ||
		 instr[31:26] == 6'b000010) ? 32'b0 : rd2;

    	// --------------------------------------------------------
    	// Destination register mux
    	// 0 -> rt  (I-type)
    	// 1 -> rd  (R-type)
    	// --------------------------------------------------------
    	MIPS_mux2 #(5) regdst_mux (
        	.d0 (instr[20:16]),
        	.d1 (instr[15:11]),
        	.s  (RegDst),
        	.y  (write_reg)
    	);
	
	// --------------------------------------------------------
    	// Sign extension of immediate
    	// --------------------------------------------------------
	Sign_Extend_32 signext (
		.A (instr[15:0]),
		.Y (sign_imm)
	);
	
	// --------------------------------------------------------
    	// ALU source mux
    	// 0 -> register data
    	// 1 -> sign-extended immediate
    	// --------------------------------------------------------
	MIPS_Mux2 #(32) alusrc_mux (
		.d0 (rd2),
		.d1 (sign_imm),
		.s  (ALUSrc),
		.y  (src_b)
	);

	// --------------------------------------------------------
    	// ALU
    	// --------------------------------------------------------
	MIPS_ALU alu (
		.A    (src_a),
		.B    (src_b),
		.F    (ALUControl),
		.Y    (alu_out),
		.zero (zero)
	);
	
	// --------------------------------------------------------
    	// Data Memory
    	// --------------------------------------------------------
	MIPS_Data_Mem dmem (
		.clk (clk),
		.WE  (MemWrite),
		.A   (alu_out),
		.WD  (write_data),
		.RD  (read_data)
	);

	// --------------------------------------------------------
    	// Write-back mux
    	// 0 -> ALU result
    	// 1 -> memory read data
    	// --------------------------------------------------------
	MIPS_Mux2 #(32) memtoreg_mux (
		.d0 (alu_out),
		.d1 (read_data),
		.s  (MemToReg),
		.y  (result)
	);

	// --------------------------------------------------------
    	// PC + 4
    	// --------------------------------------------------------
	MIPS_PC_4 pc4_adder (
		.A (pc),
		.Y (pc_plus4)
	);
	
	// --------------------------------------------------------
    	// Shift immediate left by 2 for branch
    	// --------------------------------------------------------
	MIPS_SL2_32 branch_shift (
		.A (sign_imm),
		.Y (sign_immsh)
	);
	
	// --------------------------------------------------------
    	// Branch target address
    	// --------------------------------------------------------
	MIPS_PC_Branch branch_adder (
		.A (pc_plus4),
		.B (sign_immsh),
		.Y (pc_branch)
	);

	// --------------------------------------------------------
    	// Branch decision
    	// For beq: take branch when Branch=1 and zero=1
    	// --------------------------------------------------------
	assign pc_src = Branch & zero;

	// --------------------------------------------------------
    	// Choose between PC+4 and branch target
    	// --------------------------------------------------------
	MIPS_Mux2 #(32) branch_mux (
		.d0 (pc_plus4),
		.d1 (pc_branch),
		.s  (pc_src),
		.y  (pc_pre_jump)
	);

	// --------------------------------------------------------
    	// Jump target generation
    	// jump_addr = {pcplus4[31:28], instr[25:0], 2'b00}
    	// --------------------------------------------------------
	MIPS_SL2_26 jump_shift_unit (
		.A (instr[25:0]),
		.Y (jump_shift)
	);

	assign jump_addr = {pc_plus4[31:28], jump_shift};

	// --------------------------------------------------------
    	// Final PC selection
    	// 0 -> normal/branch path
    	// 1 -> jump target
    	// --------------------------------------------------------
	MIPS_Mux2 #(32) jump_mux (
		.d0 (pc_pre_jump),
		.d1 (jump_addr),
		.s  (Jump),
		.y  (pc_next)
	);
endmodule
	