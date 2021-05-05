`include "opcodes.v"
`include "utils.v"

module hazard_detect(IFID_IR, IDEX_rd, IDEX_M_mem_read, is_stall);

	input [`WORD_SIZE-1:0] IFID_IR;
	input [1:0] IDEX_rd;
	input IDEX_M_mem_read;

	output reg is_stall;

	wire use_rs_inst;
	use_rs check_use_rs(
		.instruction(IFID_IR),
		.use_reg(use_rs_inst)
	);

	wire use_rt_inst;
	use_rt check_use_rt(
		.instruction(IFID_IR),
		.use_reg(use_rt_inst)
	);

	always @(*) begin
	    if(IDEX_M_mem_read) begin
			if((use_rs_inst && (IFID_IR[11:10] == IDEX_rd)) || (use_rt_inst && (IFID_IR[9:8] == IDEX_rd))) begin
				is_stall = 1;
			end
			else begin
				is_stall = 0;
			end
		end
		else begin
			is_stall = 0;
		end
	end
	
endmodule