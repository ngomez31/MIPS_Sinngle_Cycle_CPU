// ------------------------------------------------------------
// Module: MIPS_Control_Unit
// Description:
//   Control unit for a single-cycle 32-bit MIPS processor.
//
// Inputs:
//   Op   : 6-bit opcode field from the instruction
//   func : 6-bit function field (used for R-type instructions)
//
// Outputs:
//   ALUControl     : Selects the ALU operation
//   MemToReg       : Selects memory data for register write-back
//   MemWrite       : Enables data memory write
//   Branch         : Indicates a branch instruction
//   BranchNotEqual : 0 = beq behavior, 1 = bne behavior
//   ALUSrc         : Selects ALU second operand
//   RegDst         : Selects destination register field
//   RegWrite       : Enables register file write
//   Jump           : Indicates a jump instruction
//
// Supported instructions:
//   R-type : add, sub, and, or, slt, sltu
//   I-type : lw, sw, beq, bne, addi, slti, ble
//   J-type : j
// ------------------------------------------------------------

module MIPS_Control_Unit (
    input  logic [5:0] Op,
    input  logic [5:0] func,
    output logic [2:0] ALUControl,
    output logic       MemToReg,
    output logic       MemWrite,
    output logic       Branch,
    output logic       BranchNotEqual,
    output logic       ALUSrc,
    output logic       RegDst,
    output logic       RegWrite,
    output logic       Jump
);

    always_comb begin
        // ----------------------------------------------------
        // Safe defaults
        // ----------------------------------------------------
        ALUControl     = 3'b000;
        MemToReg       = 1'b0;
        MemWrite       = 1'b0;
        Branch         = 1'b0;
        BranchNotEqual = 1'b0;
        ALUSrc         = 1'b0;
        RegDst         = 1'b0;
        RegWrite       = 1'b0;
        Jump           = 1'b0;

        case (Op)

            // ------------------------------------------------
            // R-type instructions
            // opcode = 000000
            // ------------------------------------------------
            6'b000000: begin
                RegWrite = 1'b1;
                RegDst   = 1'b1;
                ALUSrc   = 1'b0;
                MemToReg = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                Jump     = 1'b0;

                case (func)
                    6'b100000: ALUControl = 3'b010; // add
                    6'b100010: ALUControl = 3'b110; // sub
                    6'b100100: ALUControl = 3'b000; // and
                    6'b100101: ALUControl = 3'b001; // or
                    6'b101010: ALUControl = 3'b111; // slt
                    6'b101011: ALUControl = 3'b011; // sltu - Part C Modification
                    default:   ALUControl = 3'b000;
                endcase
            end

            // ------------------------------------------------
            // lw
            // rt = Mem[rs + imm]
            // opcode = 100011
            // ------------------------------------------------
            6'b100011: begin
                RegWrite   = 1'b1;
                RegDst     = 1'b0;
                ALUSrc     = 1'b1;
                MemToReg   = 1'b1;
                MemWrite   = 1'b0;
                Branch     = 1'b0;
                Jump       = 1'b0;
                ALUControl = 3'b010; // add
            end

            // ------------------------------------------------
            // sw
            // Mem[rs + imm] = rt
            // opcode = 101011
            // ------------------------------------------------
            6'b101011: begin
                RegWrite   = 1'b0;
                RegDst     = 1'b0;
                ALUSrc     = 1'b1;
                MemToReg   = 1'b0;
                MemWrite   = 1'b1;
                Branch     = 1'b0;
                Jump       = 1'b0;
                ALUControl = 3'b010; // add
            end

            // ------------------------------------------------
            // beq
            // branch if rs == rt
            // opcode = 000100
            // ------------------------------------------------
            6'b000100: begin
                RegWrite       = 1'b0;
                RegDst         = 1'b0;
                ALUSrc         = 1'b0;
                MemToReg       = 1'b0;
                MemWrite       = 1'b0;
                Branch         = 1'b1;
                BranchNotEqual = 1'b0;   // beq
                Jump           = 1'b0;
                ALUControl     = 3'b110; // subtract for compare
            end

            // ------------------------------------------------
	    // Part B Modification
            // bne
            // branch if rs != rt
            // opcode = 000101
            // ------------------------------------------------
            6'b000101: begin
                RegWrite       = 1'b0;
                RegDst         = 1'b0;
                ALUSrc         = 1'b0;
                MemToReg       = 1'b0;
                MemWrite       = 1'b0;
                Branch         = 1'b1;
                BranchNotEqual = 1'b1;   // bne
                Jump           = 1'b0;
                ALUControl     = 3'b110; // subtract for compare
            end

            // ------------------------------------------------
            // addi
            // rt = rs + imm
            // opcode = 001000
            // ------------------------------------------------
            6'b001000: begin
                RegWrite   = 1'b1;
                RegDst     = 1'b0;
                ALUSrc     = 1'b1;
                MemToReg   = 1'b0;
                MemWrite   = 1'b0;
                Branch     = 1'b0;
                Jump       = 1'b0;
                ALUControl = 3'b010; // add
            end

            // ------------------------------------------------
	    // Part B Modification
            // slti
            // rt = (rs < imm) ? 1 : 0
            // opcode = 001010
            // ------------------------------------------------
            6'b001010: begin
                RegWrite   = 1'b1;
                RegDst     = 1'b0;
                ALUSrc     = 1'b1;
                MemToReg   = 1'b0;
                MemWrite   = 1'b0;
                Branch     = 1'b0;
                Jump       = 1'b0;
                ALUControl = 3'b111; // slt with immediate
            end

	    // ------------------------------------------------
	    // Part C Modification
	    // ble (branch if less or equal)
	    // opcode = 111011
	    // ------------------------------------------------
	    6'b111011: begin
	    RegWrite   = 1'b0;
	    RegDst     = 1'bx;
	    ALUSrc     = 1'b0;
	    MemToReg   = 1'bx;
	    MemWrite   = 1'b0;
	    Branch     = 1'b1;
	    Jump       = 1'b0;
	    ALUControl = 3'b110; // subtract (rs - rt)
	    end

            // ------------------------------------------------
            // j
            // opcode = 000010
            // ------------------------------------------------
            6'b000010: begin
                RegWrite   = 1'b0;
                RegDst     = 1'b0;
                ALUSrc     = 1'b0;
                MemToReg   = 1'b0;
                MemWrite   = 1'b0;
                Branch     = 1'b0;
                Jump       = 1'b1;
                ALUControl = 3'b000;
            end

            // ------------------------------------------------
            // Unsupported instruction
            // ------------------------------------------------
            default: begin
                ALUControl     = 3'b000;
                MemToReg       = 1'b0;
                MemWrite       = 1'b0;
                Branch         = 1'b0;
                BranchNotEqual = 1'b0;
                ALUSrc         = 1'b0;
                RegDst         = 1'b0;
                RegWrite       = 1'b0;
                Jump           = 1'b0;
            end
        endcase
    end

endmodule