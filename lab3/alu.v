`include "opcodes.v"

`define	NumBits	16

module alu (alu_input_1, alu_input_2, opcode, func_code, instrc_func, bcond, alu_output);
	input [`NumBits-1:0] alu_input_1;
	input [`NumBits-1:0] alu_input_2;
	input [3:0] opcode;
	input [2:0] func_code;
	input [5:0] instrc_func;
	output reg bcond;
	output reg [`NumBits-1:0] alu_output;

	always @(*) begin
		case(func_code)
			`FUNC_ADD: begin
				if(instrc_func == `INST_FUNC_JPR || instrc_func == `INST_FUNC_JRL) begin
					alu_output = alu_input_1;
				end
				else begin
					alu_output = alu_input_1 + alu_input_2;
				end
				bcond = 0;
			end
			`FUNC_SUB: begin
				alu_output = alu_input_1 - alu_input_2;
				case(opcode)
					`BNE_OP: begin
						if(alu_output == 0) begin
							bcond = 0;
						end
						else begin
							bcond = 1;
						end
					end
					`BEQ_OP: begin
						if(alu_output == 0) begin
							bcond = 1;
						end
						else begin
							bcond = 0;
						end
					end
					`BGZ_OP: begin
						if(alu_input_1 > 0) begin
							bcond = 1;
						end
						else begin
							bcond = 0;
						end
					end
					`BLZ_OP: begin
						if(alu_input_1 < 0) begin
							bcond = 1;
						end
						else begin
							bcond = 0;
						end
					end
					default: begin
						bcond = 0;
					end
				endcase
			end
			`FUNC_AND: begin
				alu_output = alu_input_1 & alu_input_2;
				bcond = 0;
			end
			`FUNC_ORR: begin
				alu_output = alu_input_1 | alu_input_2;
				bcond = 0;
			end
			`FUNC_NOT: begin
				alu_output = ~alu_input_1;
				bcond = 0;
			end
			`FUNC_TCP: begin
				alu_output = ~alu_input_1 + 1;
				bcond = 0;
			end
			`FUNC_SHL: begin
				case(opcode)
					`LHI_OP: begin
						alu_output = alu_input_2 << 8;
					end
					`ALU_OP: begin
						alu_output = alu_input_1 << 1;
					end
				endcase
				bcond = 0;
			end
			`FUNC_SHR: begin
				alu_output = alu_input_1 >> 1;
				alu_output[`NumBits-1] = alu_input_1[`NumBits-1];
				bcond = 0;
			end
		endcase
	end

endmodule

module alu_control(instrc, o_opcode, o_alu_func_code, o_instrc_func_code);
	input [15:0] instrc;
	output reg [3:0] o_opcode;
	output reg [2:0] o_alu_func_code;
	output reg [5:0] o_instrc_func_code;

	reg [5:0] i_func_code;
	reg [3:0] i_opcode;

	always @(*) begin
		
		i_func_code = instrc[5:0];
		i_opcode = instrc[15:12];
		
		case(i_opcode)
			`ALU_OP: begin
				case(i_func_code)
					`INST_FUNC_ADD: begin
						o_opcode = i_opcode;
						o_instrc_func_code = i_func_code;
						o_alu_func_code = `FUNC_ADD;
					end
					`INST_FUNC_SUB: begin
						o_opcode = i_opcode;
						o_instrc_func_code = i_func_code;
						o_alu_func_code = `FUNC_SUB;
					end
					`INST_FUNC_AND: begin
						o_opcode = i_opcode;
						o_instrc_func_code = i_func_code;
						o_alu_func_code = `FUNC_AND;
					end
					`INST_FUNC_ORR: begin
						o_opcode = i_opcode;
						o_instrc_func_code = i_func_code;
						o_alu_func_code = `FUNC_ORR;
					end
					`INST_FUNC_NOT: begin
						o_opcode = i_opcode;
						o_instrc_func_code = i_func_code;
						o_alu_func_code = `FUNC_NOT;
					end
					`INST_FUNC_TCP: begin
						o_opcode = i_opcode;
						o_instrc_func_code = i_func_code;
						o_alu_func_code = `FUNC_TCP;
					end
					`INST_FUNC_SHL: begin
						o_opcode = i_opcode;
						o_instrc_func_code = i_func_code;
						o_alu_func_code = `FUNC_SHL;
					end
					`INST_FUNC_SHR: begin
						o_opcode = i_opcode;
						o_instrc_func_code = i_func_code;
						o_alu_func_code = `FUNC_SHR;
					end
					`INST_FUNC_JPR: begin
						o_opcode = i_opcode;
						o_instrc_func_code = i_func_code;
						o_alu_func_code = `FUNC_ADD;
					end
					`INST_FUNC_JRL: begin
						o_opcode = i_opcode;
						o_instrc_func_code = i_func_code;
						o_alu_func_code = `FUNC_ADD;
					end
				endcase
			end
			`ADI_OP: begin
				o_opcode = i_opcode;
				o_alu_func_code = `FUNC_ADD;
                o_instrc_func_code = -1;
			end
			`ORI_OP: begin
				o_opcode = i_opcode;
				o_alu_func_code = `FUNC_ORR;
                o_instrc_func_code = -1;
			end
			`LHI_OP: begin
				o_opcode = i_opcode;
				o_alu_func_code = `FUNC_SHL;
                o_instrc_func_code = -1;
			end
			`LWD_OP: begin
				o_opcode = i_opcode;
				o_alu_func_code = `FUNC_ADD;
                o_instrc_func_code = -1;
			end
			`SWD_OP: begin
				o_opcode = i_opcode;
				o_alu_func_code = `FUNC_ADD;
                o_instrc_func_code = -1;
			end
			`BNE_OP: begin
				o_opcode = i_opcode;
				o_alu_func_code = `FUNC_SUB;
                o_instrc_func_code = -1;
			end
			`BEQ_OP: begin
				o_opcode = i_opcode;
				o_alu_func_code = `FUNC_SUB;
                o_instrc_func_code = -1;
			end
			`BGZ_OP: begin
				o_opcode = i_opcode;
				o_alu_func_code = `FUNC_SUB;
                o_instrc_func_code = -1;
			end
			`BLZ_OP: begin
				o_opcode = i_opcode;
				o_alu_func_code = `FUNC_SUB;
                o_instrc_func_code = -1;
			end
		endcase
	end
endmodule	