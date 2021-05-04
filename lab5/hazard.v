`include "opcodes.v"

module hazard_detect(IFID_IR, IDEX_rd, IDEX_M_mem_read, is_stall);

	input [`WORD_SIZE-1:0] IFID_IR;
	input [1:0]  IDEX_rd;
	input IDEX_M_mem_read;

	output is_stall;

	//TODO: implement hazard detection unit

endmodule