// ------------------------------------------------------------
// Module: MIPS_Control_Unit
// Description:
//   This module generates the main control signals for a
//   single-cycle 32-bit MIPS processor.
//
// Inputs:
//   Op   : 6-bit opcode field from the instruction
//   func : 6-bit function field (used for R-type instructions)
//
// Outputs:
//   ALUControl : Selects the ALU operation
//   MemToReg   : Selects memory data for register write-back
//   MemWrite   : Enables data memory write
//   Branch     : Indicates a branch instruction
//   ALUSrc     : Selects ALU second operand
//   RegDst     : Selects destination register field
//   RegWrite   : Enables register file write
//   Jump       : Indicates a jump instruction
//
// Notes:
//   - For R-type instructions, the opcode is 000000 and the
//     func field determines the ALU operation.
//   - For I-type and J-type instructions, the opcode alone
//     determines the required control signals.
// ------------------------------------------------------------

module MIPS_Control_Unit (
    input  logic [5:0] Op,          // Opcode field
    input  logic [5:0] func,        // Function field for R-type
    output logic [2:0] ALUControl,  // ALU operation select
    output logic       MemToReg,    // Write back from memory
    output logic       MemWrite,    // Data memory write enable
    output logic       Branch,      // Branch control signal
    output logic       ALUSrc,      // Select immediate or register input
    output logic       RegDst,      // Select destination register
    output logic       RegWrite,    // Register file write enable
    output logic       Jump         // Jump control signal
);

    // --------------------------------------------------------
    // Combinational control logic
    // Default values are assigned first to prevent latches.
    // Then the control signals are updated based on the opcode.
    // --------------------------------------------------------
    always_comb begin
        // Default control values
        ALUControl = 3'b000;
        MemToReg   = 1'b0;
        MemWrite   = 1'b0;
        Branch     = 1'b0;
        ALUSrc     = 1'b0;
        RegDst     = 1'b0;
        RegWrite   = 1'b0;
        Jump       = 1'b0;

        case (Op)

            // ------------------------------------------------
            // R-type instructions
            // opcode = 000000
            // func field determines exact ALU operation
            // ------------------------------------------------
            6'b000000: begin
                RegWrite = 1'b1;
                RegDst   = 1'b1;
                ALUSrc   = 1'b0;
                MemWrite = 1'b0;
                MemToReg = 1'b0;
                Branch   = 1'b0;
                Jump     = 1'b0;

                case (func)
                    6'b100000: ALUControl = 3'b010; // add
                    6'b100010: ALUControl = 3'b110; // sub
                    6'b100100: ALUControl = 3'b000; // and
                    6'b100101: ALUControl = 3'b001; // or
                    6'b101010: ALUControl = 3'b111; // slt
                    default:   ALUControl = 3'b000; // default safe value
                endcase
            end

            // ------------------------------------------------
            // lw
            // Load word from memory into register
            // ------------------------------------------------
            6'b100011: begin
                RegWrite   = 1'b1;
                RegDst     = 1'b0;
                ALUSrc     = 1'b1;
                MemToReg   = 1'b1;
                MemWrite   = 1'b0;
                Branch     = 1'b0;
                Jump       = 1'b0;
                ALUControl = 3'b010; // add for address calculation
            end

            // ------------------------------------------------
            // sw
            // Store word from register into memory
            // ------------------------------------------------
            6'b101011: begin
                RegWrite   = 1'b0;
                ALUSrc     = 1'b1;
                MemWrite   = 1'b1;
                MemToReg   = 1'b0;
                Branch     = 1'b0;
                Jump       = 1'b0;
                ALUControl = 3'b010; // add for address calculation
            end

            // ------------------------------------------------
            // beq
            // Branch if two registers are equal
            // ------------------------------------------------
            6'b000100: begin
                RegWrite   = 1'b0;
                ALUSrc     = 1'b0;
                MemWrite   = 1'b0;
                Branch     = 1'b1;
                MemToReg   = 1'b0;
                Jump       = 1'b0;
                ALUControl = 3'b110; // subtract for comparison
            end

            // ------------------------------------------------
            // addi
            // Add immediate value to register
            // ------------------------------------------------
            6'b001000: begin
                RegWrite   = 1'b1;
                RegDst     = 1'b0;
                ALUSrc     = 1'b1;
                MemWrite   = 1'b0;
                MemToReg   = 1'b0;
                Branch     = 1'b0;
                Jump       = 1'b0;
                ALUControl = 3'b010; // add
            end

            // ------------------------------------------------
            // j
            // Unconditional jump
            // ------------------------------------------------
            6'b000010: begin
                RegWrite   = 1'b0;
                MemWrite   = 1'b0;
                Branch     = 1'b0;
                ALUSrc     = 1'b0;
                MemToReg   = 1'b0;
                RegDst     = 1'b0;
                Jump       = 1'b1;
                ALUControl = 3'b000;
            end

            // ------------------------------------------------
            // Default / unsupported instruction
            // Keeps all controls inactive
            // ------------------------------------------------
            default: begin
                ALUControl = 3'b000;
                MemToReg   = 1'b0;
                MemWrite   = 1'b0;
                Branch     = 1'b0;
                ALUSrc     = 1'b0;
                RegDst     = 1'b0;
                RegWrite   = 1'b0;
                Jump       = 1'b0;
            end
        endcase
    end

endmodule
