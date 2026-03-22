module alu(input logic [31:0] A, B,
 input logic [2:0] F,
 output logic [31:0] Y,
 output logic zero);

 logic [31:0]BB, S;
 logic cout,less_than;
 logic [31:0]X1,X2,X3,X4;
 assign BB = F[2]? ~B : B ;
 assign X1 = BB & A ;
 assign X2 = BB | A ;
 adder myadder(A,BB,F[2],S,cout);
 assign X3 = S;
 assign less_than = S[31];
 assign X4 = {31'b0, less_than};
 assign Y = F[1] ? (F[0] ? X4 : X3):(F[0]? X2 : X1);
 always_comb
	begin
		if(Y==32'b0) zero=1'b1;
		else zero = 1'b0;
	end
endmodule

module adder #(parameter N = 32)
	(input logic [N-1:0] a, b,
	input logic cin,
	output logic [N-1:0] s,
	output logic cout);
	assign {cout, s} = a+b+ cin;
endmodule



