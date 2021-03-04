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
`include "alu_func.v"

initial begin
	C = 0;
	OverflowFlag = 0;
end   	

// TODO: You should implement the functionality of ALU!
// (HINT: Use 'always @(...) begin ... end')
/*
	YOUR ALU FUNCTIONALITY IMPLEMENTATION...
*/

	case(FuncCode)
		`FUNC_ADD:
		`FUNC_SUB:
		`FUNC_ID     4'b001
		`FUNC_NOT    4'b0011
`define FUNC_AND    4'b0100
`define FUNC_OR     4'b0101
`define FUNC_NAND   4'b0110
`define FUNC_NOR    4'b0111
`define FUNC_XOR    4'b1000
`define FUNC_XNOR   4'b1001
`define FUNC_LLS    4'b1010
`define FUNC_LRS    4'b1011
`define FUNC_ALS    4'b1100
`define FUNC_ARS    4'b1101
`define FUNC_TCP    4'b1110
`define FUNC_ZERO   4'b1111




endmodule

