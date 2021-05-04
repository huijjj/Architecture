`include "opcodes.v" 

module register_file (read_out1, read_out2, read1, read2, dest, write_data, reg_write, clk, reset_n);

	input clk, reset_n;
	input [1:0] read1;
	input [1:0] read2;
	input [1:0] dest;
	input reg_write;
	input [`WORD_SIZE-1:0] write_data;
	

	output [`WORD_SIZE-1:0] read_out1;
	output [`WORD_SIZE-1:0] read_out2;
	
	//TODO: implement register file

endmodule
