`include "opcodes.v" 

module alu (A, B, func_code, branch_type, alu_out, overflow_flag, bcond);

	input [`WORD_SIZE-1:0] A;
	input [`WORD_SIZE-1:0] B;
	input [2:0] func_code;
	input [1:0] branch_type; 

	output reg [`WORD_SIZE-1:0] alu_out;
	output reg overflow_flag; 
	output reg bcond;

	//TODO: implement alu 
	

endmodule