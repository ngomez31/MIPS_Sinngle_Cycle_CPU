# ECE 469 Lab 6 — MIPS Single-Cycle CPU Class Project

## Project Overview
This repository contains my implementation of a **32-bit MIPS single-cycle CPU** for **ECE 469 (Spring 2026)**. The goal of the project was to build, simulate, and verify a simplified MIPS processor in **SystemVerilog** by combining the datapath and control units into a working single-cycle design.

The project began with the baseline MIPS processor that supports the standard instruction subset:

- `add`
- `sub`
- `and`
- `or`
- `slt`
- `lw`
- `sw`
- `beq`
- `addi`
- `j`

After verifying the unmodified processor in simulation, the design was extended to support additional instructions and tested with new machine-code programs.

## Course Project Objectives
The main objectives of this lab were to:

- understand the internal operation of a **single-cycle MIPS processor**
- study the relationship between the **controller** and the **datapath**
- integrate an existing **32-bit ALU** into the full CPU design
- initialize and use instruction and data memories
- simulate the processor in **ModelSim**
- verify correct execution using waveform analysis
- modify the decoder and datapath to support new instructions

## Project Scope
The assignment was divided into three parts:

### Part A — Baseline MIPS v0
In Part A, the task was to build and test the original single-cycle MIPS CPU. The processor organization follows the textbook-style split between:

- **controller**
- **datapath**
- **instruction memory**
- **data memory**
- **register file**
- **ALU**
- supporting blocks such as sign extension, adders, and multiplexers

The instruction memory was initialized with the provided test program (`test_a` / `memfile.dat`), and the CPU was simulated to verify correct execution. A required part of the assignment was completing the cycle-by-cycle prediction table and confirming whether the processor wrote the correct value to **address 84** during the final store operation.

### Part B — Extended MIPS v1
In Part B, the processor was modified to support two additional instructions:

- `bne` with opcode `000101`
- `slti` with opcode `001010`

This required updating the **main decoder**, **ALU decoder**, and any related control logic so the processor could execute the new instructions correctly. A second test program (`test_b`) was then used to verify that the new functionality worked and that the original instruction set still behaved correctly.

### Part C — Extra Credit MIPS v2
The extra credit portion added two more instructions:

- `sltu` with opcode/function combination `000000 / 101011`
- `ble` with opcode/function combination `000000 / 111011`

These additions required further updates to the decode and execution logic, along with a third validation program (`test_c`).

## Key Design Features
This project includes the major hardware blocks expected in a single-cycle MIPS processor:

- **Instruction Memory** for fetching 32-bit instructions
- **Register File** with two read ports and one write port
- **ALU** for arithmetic and logical operations
- **Data Memory** for load/store instructions
- **Main Control Unit** for opcode-based control generation
- **ALU Control Unit** for selecting the correct ALU operation
- **Sign Extension** for immediate values
- **Branch and Jump Logic** for PC selection
- **Multiplexers and adders** to route operands and next-PC values

## Verification and Simulation
A major part of the project was simulation-based verification. The assignment specifically required waveform analysis in **ModelSim** using the following signals:

- `reset`
- `pc`
- `clk`
- `instr`
- `aluout`
- `writedata`
- `memwrite`
- `readdata`

These signals were required to be shown in **hexadecimal**, in the exact order listed above, and at a readable zoom level for grading.

## Files in This Repository
Depending on the version of the project, this repository may include files such as:

- `top.sv` — top-level processor integration
- `mips.sv` — top processor module
- `controller.sv` — main control and ALU control logic
- `datapath.sv` — datapath implementation
- `MiPSRegFile.sv` — 32 × 32-bit register file
- `Instruction_Mem_MIPS32.sv` — instruction memory
- `MIPSDataMem.sv` — data memory
- `alu.sv` — 32-bit ALU
- `memfile.dat` — machine code for Part A
- `memfile_b.dat` — machine code for Part B
- `memfile_c.dat` — machine code for Part C
- testbench files for simulation and verification

## What I Learned
Through this project, I strengthened my understanding of:

- how MIPS instructions move through a single-cycle datapath
- how opcode and function fields drive control logic
- how memory, register, and ALU modules connect in hardware
- how to debug processor behavior using simulation waveforms
- how to extend an existing CPU architecture with new instructions

## Summary
This class project demonstrates the design, implementation, and verification of a **single-cycle 32-bit MIPS CPU in SystemVerilog**. It started with a baseline processor and then expanded to support new instructions through control-unit and datapath modifications. The project combines digital design, RTL coding, debugging, and hardware-oriented problem solving in a complete CPU implementation.
