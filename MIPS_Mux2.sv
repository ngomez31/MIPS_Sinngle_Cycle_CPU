// ------------------------------------------------------------
// Module: MIPS_Mux2
// Description:
//   Parameterized 2-to-1 multiplexer
//
// Inputs:
//   d0 : Input selected when s = 0
//   d1 : Input selected when s = 1
//   s  : Select signal
//
// Output:
//   y  : Selected output
//
// Notes:
//   - Default width is 32 bits
//   - Can be reused throughout the MIPS datapath
// ------------------------------------------------------------
module MIPS_Mux2 #(parameter WIDTH = 32) (
	input  logic [WIDTH-1:0] d0,
	input  logic [WIDTH-1:0] d1,
	input  logic		 s,
	output logic [WIDTH-1:0] y
);
	assign y = s ? d1 : d0;
endmodule

