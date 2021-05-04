`include "opcodes.v" 

module control_unit (opcode, func_code, clk, reset_n, pc_write_cond, pc_write, i_or_d, mem_read, mem_to_reg, mem_write, ir_write, pc_to_reg, pc_src, halt, wwd, new_inst, reg_write, alu_src_A, alu_src_B, alu_op);

	input [3:0] opcode;
	input [5:0] func_code;

	input reset_n;
	
	output reg halt, reg_dst, pc_to_reg;
	output reg alu_src, branch, JPR_or_JRL, JMP_or_JAL;
	output reg mem_write, mem_read;
	output reg mem_to_reg, wwd;
	output reg [2:0] alu_op;
	output reg [1:0] branch_type;

	initial begin
		halt = 0;
		reg_dst = 0;
		pc_to_reg = 0;
		alu_src = 0;
		branch = 0;
		JPR_or_JRL  = 0;
		JMP_or_JAL = 0;
		mem_write = 0;
		mem_read = 0;
		mem_to_reg = 0;
		wwd = 0;
		alu_op = 0;
		branch_type = 0;
	end

	always @(*) begin
   		if(!reset_n) begin
	    	halt = 0;
			reg_dst = 0;
			pc_to_reg = 0;
			alu_src = 0;
			branch = 0;
			JPR_or_JRL  = 0;
			JMP_or_JAL = 0;
			mem_write = 0;
			mem_read = 0;
			mem_to_reg = 0;
			wwd = 0;
			alu_op = 0;
			branch_type = 0;
    	end
  	end

	always @(*) begin
		case(opcode)
			`ALU_OP: begin
				case(func_code)
					`INST_FUNC_ADD: begin
						halt = 0;
						reg_dst = 0;
						pc_to_reg = 0;
						alu_src = 0;
						branch = 0;
						JPR_or_JRL  = 0;
						JMP_or_JAL = 0;
						mem_write = 0;
						mem_read = 0;
						mem_to_reg = 0;
						wwd = 0;
						alu_op = `FUNC_ADD;
						branch_type = 0;
					end 
					`INST_FUNC_SUB: begin
						halt = 0;
						reg_dst = 0;
						pc_to_reg = 0;
						alu_src = 0;
						branch = 0;
						JPR_or_JRL  = 0;
						JMP_or_JAL = 0;
						mem_write = 0;
						mem_read = 0;
						mem_to_reg = 0;
						wwd = 0;
						alu_op = `FUNC_SUB;
						branch_type = 2'b11;
					end 
					`INST_FUNC_AND: begin
						halt = 0;
						reg_dst = 0;
						pc_to_reg = 0;
						alu_src = 0;
						branch = 0;
						JPR_or_JRL  = 0;
						JMP_or_JAL = 0;
						mem_write = 0;
						mem_read = 0;
						mem_to_reg = 0;
						wwd = 0;
						alu_op = `FUNC_AND;
						branch_type = 0;
					end 
					`INST_FUNC_ORR: begin
						halt = 0;
						reg_dst = 0;
						pc_to_reg = 0;
						alu_src = 0;
						branch = 0;
						JPR_or_JRL  = 0;
						JMP_or_JAL = 0;
						mem_write = 0;
						mem_read = 0;
						mem_to_reg = 0;
						wwd = 0;
						alu_op = `FUNC_ORR;
						branch_type = 0;
					end 
					`INST_FUNC_NOT: begin
						halt = 0;
						reg_dst = 0;
						pc_to_reg = 0;
						alu_src = 0;
						branch = 0;
						JPR_or_JRL  = 0;
						JMP_or_JAL = 0;
						mem_write = 0;
						mem_read = 0;
						mem_to_reg = 0;
						wwd = 0;
						alu_op = `FUNC_NOT;
						branch_type = 0;
					end 
					`INST_FUNC_TCP: begin
						halt = 0;
						reg_dst = 0;
						pc_to_reg = 0;
						alu_src = 0;
						branch = 0;
						JPR_or_JRL  = 0;
						JMP_or_JAL = 0;
						mem_write = 0;
						mem_read = 0;
						mem_to_reg = 0;
						wwd = 0;
						alu_op = `FUNC_TCP;
						branch_type = 0;
					end 
					`INST_FUNC_SHL: begin
						halt = 0;
						reg_dst = 0;
						pc_to_reg = 0;
						alu_src = 0;
						branch = 0;
						JPR_or_JRL  = 0;
						JMP_or_JAL = 0;
						mem_write = 0;
						mem_read = 0;
						mem_to_reg = 0;
						wwd = 0;
						alu_op = `FUNC_SHL;
						branch_type = 0;
					end 
					`INST_FUNC_SHR: begin
						halt = 0;
						reg_dst = 0;
						pc_to_reg = 0;
						alu_src = 0;
						branch = 0;
						JPR_or_JRL  = 0;
						JMP_or_JAL = 0;
						mem_write = 0;
						mem_read = 0;
						mem_to_reg = 0;
						wwd = 0;
						alu_op = `FUNC_SHL;
						branch_type = 0;
					end 
					`INST_FUNC_JPR: begin
						halt = 0;
						reg_dst = 0;
						pc_to_reg = 0;
						alu_src = 0;
						branch = 0;
						JPR_or_JRL  = 1;
						JMP_or_JAL = 0;
						mem_write = 0;
						mem_read = 0;
						mem_to_reg = 0;
						wwd = 0;
						alu_op = 0;
						branch_type = 0;
					end
					`INST_FUNC_JRL: begin
						halt = 0;
						reg_dst = 0;
						pc_to_reg = 1;
						alu_src = 0;
						branch = 0;
						JPR_or_JRL  = 1;
						JMP_or_JAL = 0;
						mem_write = 0;
						mem_read = 0;
						mem_to_reg = 0;
						wwd = 0;
						alu_op = 0;
						branch_type = 0;
					end
					`INST_FUNC_WWD: begin
						halt = 0;
						reg_dst = 0;
						pc_to_reg = 0;
						alu_src = 0;
						branch = 0;
						JPR_or_JRL  = 0;
						JMP_or_JAL = 0;
						mem_write = 0;
						mem_read = 0;
						mem_to_reg = 0;
						wwd = 1;
						alu_op = 0;
						branch_type = 0;
					end
					`INST_FUNC_HLT: begin
						halt = 1;
						reg_dst = 0;
						pc_to_reg = 0;
						alu_src = 0;
						branch = 0;
						JPR_or_JRL  = 0;
						JMP_or_JAL = 0;
						mem_write = 0;
						mem_read = 0;
						mem_to_reg = 0;
						wwd = 0;
						alu_op = 0;
						branch_type = 0;
						
					end
				endcase
			end
			`ADI_OP: begin
				halt = 0;
				reg_dst = 1;
				pc_to_reg = 0;
				alu_src = 1;
				branch = 0;
				JPR_or_JRL  = 0;
				JMP_or_JAL = 0;
				mem_write = 0;
				mem_read = 0;
				mem_to_reg = 0;
				wwd = 0;
				alu_op = `FUNC_ADD;
				branch_type = 0;
			end
			`ORI_OP: begin
				halt = 0;
				reg_dst = 1;
				pc_to_reg = 0;
				alu_src = 1;
				branch = 0;
				JPR_or_JRL  = 0;
				JMP_or_JAL = 0;
				mem_write = 0;
				mem_read = 0;
				mem_to_reg = 0;
				wwd = 0;
				alu_op = `FUNC_ORR;
				branch_type = 0;
			end
			`LHI_OP: begin
				halt = 0;
				reg_dst = 1;
				pc_to_reg = 0;
				alu_src = 1;
				branch = 0;
				JPR_or_JRL  = 0;
				JMP_or_JAL = 0;
				mem_write = 0;
				mem_read = 0;
				mem_to_reg = 0;
				wwd = 0;
				alu_op = `FUNC_SHL;
				branch_type = 2'b01;
			end
			`LWD_OP: begin
				halt = 0;
				reg_dst = 1;
				pc_to_reg = 0;
				alu_src = 1;
				branch = 0;
				JPR_or_JRL  = 0;
				JMP_or_JAL = 0;
				mem_write = 0;
				mem_read = 1;
				mem_to_reg = 1;
				wwd = 0;
				alu_op = `FUNC_ADD;
				branch_type = 0;
			end
			`SWD_OP: begin
				halt = 0;
				reg_dst = 0;
				pc_to_reg = 0;
				alu_src = 1;
				branch = 0;
				JPR_or_JRL  = 0;
				JMP_or_JAL = 0;
				mem_write = 1;
				mem_read = 0;
				mem_to_reg = 0;
				wwd = 0;
				alu_op = `FUNC_ADD;
				branch_type = 0;
			end
			`BNE_OP: begin
				halt = 0;
				reg_dst = 0;
				pc_to_reg = 0;
				alu_src = 0;
				branch = 1;
				JPR_or_JRL  = 0;
				JMP_or_JAL = 0;
				mem_write = 0;
				mem_read = 0;
				mem_to_reg = 0;
				wwd = 0;
				alu_op = `FUNC_SUB;
				branch_type = 2'b00;
			end
			`BEQ_OP: begin
				halt = 0;
				reg_dst = 0;
				pc_to_reg = 0;
				alu_src = 0;
				branch = 1;
				JPR_or_JRL  = 0;
				JMP_or_JAL = 0;
				mem_write = 0;
				mem_read = 0;
				mem_to_reg = 0;
				wwd = 0;
				alu_op = `FUNC_SUB;
				branch_type = 2'b01;
			end
			`BGZ_OP: begin
				halt = 0;
				reg_dst = 0;
				pc_to_reg = 0;
				alu_src = 0;
				branch = 1;
				JPR_or_JRL  = 0;
				JMP_or_JAL = 0;
				mem_write = 0;
				mem_read = 0;
				mem_to_reg = 0;
				wwd = 0;
				alu_op = `FUNC_ADD;
				branch_type = 2'b10;
			end
			`BLZ_OP: begin
				halt = 0;
				reg_dst = 0;
				pc_to_reg = 0;
				alu_src = 0;
				branch = 1;
				JPR_or_JRL  = 0;
				JMP_or_JAL = 0;
				mem_write = 0;
				mem_read = 0;
				mem_to_reg = 0;
				wwd = 0;
				alu_op = `FUNC_ADD;
				branch_type = 2'b11;
			end
			`JMP_OP: begin
				halt = 0;
				reg_dst = 0;
				pc_to_reg = 0;
				alu_src = 0;
				branch = 0;
				JPR_or_JRL  = 0;
				JMP_or_JAL = 1;
				mem_write = 0;
				mem_read = 0;
				mem_to_reg = 0;
				wwd = 0;
				alu_op = 0;
				branch_type = 0;
			end
			`JAL_OP: begin
				halt = 0;
				reg_dst = 0;
				pc_to_reg = 1;
				alu_src = 0;
				branch = 0;
				JPR_or_JRL  = 0;
				JMP_or_JAL = 1;
				mem_write = 0;
				mem_read = 0;
				mem_to_reg = 0;
				wwd = 0;
				alu_op = 0;
				branch_type = 0;
			end
			default: begin
				halt = 0;
				reg_dst = 0;
				pc_to_reg = 0;
				alu_src = 0;
				branch = 0;
				JPR_or_JRL  = 0;
				JMP_or_JAL = 0;
				mem_write = 0;
				mem_read = 0;
				mem_to_reg = 0;
				wwd = 0;
				alu_op = 0;
				branch_type = 0;
			end
		endcase	
	end
endmodule