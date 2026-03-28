// ------------------------------------------------------------
// Module: MIPS_Top
// Description:
//   Top-level module for the single-cycle 32-bit MIPS CPU.
//
//   This module connects:
//   - the control unit
//   - the datapath
//
// Inputs:
//   clk   : Clock signal
//   reset : Reset signal
//
// Outputs:
//   pc         : Current program counter
//   instr      : Current instruction
//   alu_out    : ALU result
//   write_data : Data written to data memory
//   read_data  : Data read from data memory
//   memwrite   : Data memory write enable
//
// Notes:
//   - The opcode field instr[31:26] and function field
//     instr[5:0] are sent into the control unit
//   - The control unit generates the control signals
//   - The datapath executes the instruction using those signals
// ------------------------------------------------------------
module MIPS_Top (
	input  logic	    clk,
	input  logic	    reset,
	output logic [31:0] pc,
	output logic [31:0] instr,
	output logic [31:0] alu_out,
	output logic [31:0] write_data,
	output logic [31:0] read_data,
	output logic 	    memwrite
);
	
	// --------------------------------------------------------
    	// Internal control signals
    	// --------------------------------------------------------
	logic [2:0] ALUControl;
    	logic       MemToReg;
    	logic       Branch;
    	logic       ALUSrc;
    	logic       RegDst;
   	logic       RegWrite;
    	logic       Jump;
    	logic       zero;
	
	// --------------------------------------------------------
    	// Control Unit
    	// Generates the control signals from the instruction fields
    	// --------------------------------------------------------
    	MIPS_Control_Unit control_unit (
        	.Op         (instr[31:26]),
        	.func       (instr[5:0]),
        	.ALUControl (ALUControl),
        	.MemToReg   (MemToReg),
        	.MemWrite   (memwrite),
        	.Branch     (Branch),
        	.ALUSrc     (ALUSrc),
        	.RegDst     (RegDst),
        	.RegWrite   (RegWrite),
        	.Jump       (Jump)
	);

	// --------------------------------------------------------
    	// Datapath
    	// Executes the instruction using the control signals
    	// --------------------------------------------------------
	MIPS_Datapath datapath(
		.clk		(clk),
		.reset		(reset),
		.MemToReg	(MemToReg),
		.Branch		(Branch),
		.ALUSrc		(ALUSrc),
		.RegDst		(RegDst),
		.RegWrite	(RegWrite),
		.Jump		(Jump),
		.MemWrite	(memwrite),
		.ALUControl	(ALUControl),
		.zero		(zero),
		.pc		(pc),
		.instr		(instr),
		.alu_out	(alu_out),
		.write_data	(write_data),
		.read_data	(read_data)
	);
endmodule
