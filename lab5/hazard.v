`include "opcodes.v"

module hazard_detect(IFID_IR, IDEX_rd, IDEX_M_mem_read, is_stall);

	input [`WORD_SIZE-1:0] IFID_IR;
	input [1:0]  IDEX_rd;
	input IDEX_M_mem_read;

	output is_stall;

	wire use_rs_inst;
	use_rs check_use_rs(
		.instruction(IFID_IR),
		.use(use_rs_inst)
	);

	wire use_rt_inst;
	use_rt check_use_rt(
		.instruction(IFID_IR),
		.use(use_rt_inst)
	);

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
endmodule

module use_rs(instruction, use);
	input [`WORD_SIZE-1:0];
	output use;

	always @(*) begin
		if(instruction[15:12] == `JMP_OP || instruction[15:12] = `JAL_OP || (instruction[15:12] == `HLT_OP && instruction[5:0] == `INST_FUNC_HLT)) begin
			// JMP or JAL or HLT
			use = 0;
		end
		else begin
			use = 1;
		end	
	end
endmodule

module use_rt(instruction, use);
	input [`WORD_SIZE-1:0];
	output use;
	
	// ADD, SUB, AND, ORR, SWD, BXX -> use = 1;


	always @(*) begin
		case(instrcution[15:12])
			`ALU_OP: begin
				case(instruction[5:0])
					`INST_FUNC_ADD,
					`INST_FUNC_SUB,
					`INST_FUNC_AND,
					`INST_FUNC_ORR: begin
						use = 1;
					end
					default: begin
						use = 0;
					end
				endcase
			end
			`SWD_OP,  
			`BNE_OP,
			`BEQ_OP,
			`BGZ_OP,
			`BLZ_OP: begin
				use = 1;
			end
			default: begin
				use = 0;
			end
		endcase
	end
endmodule
