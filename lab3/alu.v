`include "opcodes.v"

`define	NumBits	16

module alu (alu_input_1, alu_input_2, func_code, alu_output);
	input [`NumBits-1:0] alu_input_1;
	input [`NumBits-1:0] alu_input_2;
	input [2:0] func_code;
	output reg [`NumBits-1:0] alu_output;

endmodule