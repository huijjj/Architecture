`include "alu_func.v"

module ALU #(parameter data_width = 16) (
	input [data_width - 1 : 0] A, 
	input [data_width - 1 : 0] B, 
	input [3 : 0] FuncCode,
       	output reg [data_width - 1: 0] C,
       	output reg OverflowFlag);
// Do not use delay in your implementation.

// You can declare any variables as needed.
/*
	YOUR VARIABLE DECLARATION...
*/
	initial begin
		C = 0;
		OverflowFlag = 0;
	end   	
	
	wire [data_width - 1 : 0]res[7:0];
	wire ofFlag;
// TODO: You should implement the functionality of ALU!
// (HINT: Use 'always @(...) begin ... end')
	xor_or_xnor xor_module(.A(A), .B(B), .is_neg(FuncCode[0]), .result(res[0]), .offlag(ofFlag));
	xor_or_xnor xnor_module(.A(A), .B(B), .is_neg(FuncCode[0]), .result(res[1]), .offlag(ofFlag));
	logical_shift Lleft_shift(.A(A), .is_right(FuncCode[0]), .result(res[2]), .offlag(ofFlag));
	logical_shift Lright_shift(.A(A), .is_right(FuncCode[0]), .result(res[3]), .offlag(ofFlag));
	arith_shift Aleft_shift(.A(A), .is_right(FuncCode[0]), .result(res[4]), .offlag(ofFlag));
	arith_shift Aright_shift(.A(A), .is_right(FuncCode[0]), .result(res[5]));
	complement_or_zero two_complement(.A(A), .is_zero(FuncCode[0]), .result(res[6]), .offlag(ofFlag));
	complement_or_zero Zero(.A(A), .is_zero(FuncCode[0]), .result(res[7]), .offlag(ofFlag));
	always @(*) begin
		case(FuncCode)
			`FUNC_XOR:
				C <= res[0];
			`FUNC_XNOR:
				C <= res[1];
			`FUNC_LLS:
				C <= res[2];
			`FUNC_LRS:
				C <= res[3];
			`FUNC_ALS:
				C <= res[4];    
			`FUNC_ARS:
				C <= res[5];    
			`FUNC_TCP:
				C <= res[6];
			`FUNC_ZERO: 
				C <= res[7];
			default: begin end
		endcase
	end
endmodule

module xor_or_xnor #(parameter data_width = 16) (
	input [data_width - 1 : 0]A,
	input [data_width - 1 : 0]B,
	input is_neg,
	output reg [data_width - 1 : 0] result,
	output offlag);
	
	assign offlag = 0;
	always @(*) begin
		if(is_neg)
			result = ~(A^B); 
		else
			result = A^B;
	end
endmodule

module logical_shift #(parameter data_width = 16) (
	input [data_width - 1 : 0] A,
	input is_right,
	output reg [data_width - 1 : 0] result,
	output offlag);
	
	assign fflag = 0;
	always @(*) begin
		if(is_right)
			result = A>>1;
		else
			result = A<<1;
	end
endmodule

module arith_shift #(parameter data_width = 16) (
	input [data_width - 1 : 0] A,
	input is_right,
	output reg [data_width - 1 : 0] result,
	output offlag);
	
	assign offlag = 0;
	always @(*) begin
		if(is_right)begin
			result = A >>> 1;
			if(A[data_width - 1]==1) begin
				result[data_width - 1] = A[data_width-1];
			end
		end
		else
			result = A <<< 1;
	end
endmodule

module complement_or_zero #(parameter data_width = 16) (
	input [data_width - 1 : 0]A,
	input is_zero,
	output reg [data_width - 1 : 0]result,
	output offlag);
	
	assign offlag = 0;
	always @(*) begin
		if(is_zero)
			result = 0;
		else
			result = ~A+1;
	end	
endmodule