`include "opcodes.v" 

module control_unit (opcode, func_code, reset_n, control_signal);

	input [3:0] opcode;
	input [5:0] func_code;

	input reset_n;

	output reg [17:0] control_signal;

	initial begin
		control_signal[0] = 0; // alu_source
		control_signal[3:1] = 3'b000; // alu_op
		control_signal[5:4] = 2'b00; // branch_type
		control_signal[6] = 0; // JPR_or_JRL
		control_signal[7] = 0; // JMP_or_JAL
		control_signal[8] = 0; // branch
		
		control_signal[9] = 0; // mem_write
		control_signal[10] = 0; // mem_read

		control_signal[11] = 0; // mem_to_reg
		control_signal[12] = 0; // wwd
		control_signal[13] = 0; // pc_to_reg
		control_signal[14] = 0; // halt
		control_signal[15] = 0; // valid_instruction
		control_signal[16] = 0; // reg_dst
		control_signal[17] = 0; // reg_write
	end

	always @(*) begin
   		if(!reset_n) begin
	    	control_signal[0] = 0; // alu_source
			control_signal[3:1] = 3'b000; // alu_op
			control_signal[5:4] = 2'b00; // branch_type
			control_signal[6] = 0; // JPR_or_JRL
			control_signal[7] = 0; // JMP_or_JAL
			control_signal[8] = 0; // branch
		
			control_signal[9] = 0; // mem_write
			control_signal[10] = 0; // mem_read

			control_signal[11] = 0; // mem_to_reg
			control_signal[12] = 0; // wwd
			control_signal[13] = 0; // pc_to_reg
			control_signal[14] = 0; // halt
			control_signal[15] = 0; // valid_instruction
			control_signal[16] = 0; // reg_dst
			control_signal[17] = 0; // reg_write
    	end
  	end

	always @(*) begin
		if((opcode == 4'b1011) | !reset_n) begin //nop
			control_signal[15] = 0; // valid_instruction (nop)
		end
		else begin
			control_signal[15] = 1; // valid_instruction
		end
	end

	always @(*) begin
		case(opcode)
			`ALU_OP: begin
				case(func_code)
					`INST_FUNC_ADD: begin
						control_signal[0] = 0; // alu_source
						control_signal[3:1] = `FUNC_ADD; // alu_op
						control_signal[5:4] = 2'b00; // branch_type
						control_signal[6] = 0; // JPR_or_JRL
						control_signal[7] = 0; // JMP_or_JAL
						control_signal[8] = 0; // branch
		
						control_signal[9] = 0; // mem_write
						control_signal[10] = 0; // mem_read

						control_signal[11] = 0; // mem_to_reg
						control_signal[12] = 0; // wwd
						control_signal[13] = 0; // pc_to_reg
						control_signal[14] = 0; // halt
						control_signal[16] = 0; // reg_dst
						control_signal[17] = 1; // reg_write
					end 
					`INST_FUNC_SUB: begin
						control_signal[0] = 0; // alu_source
						control_signal[3:1] = `FUNC_SUB; // alu_op
						control_signal[5:4] = 2'b11; // branch_type
						control_signal[6] = 0; // JPR_or_JRL
						control_signal[7] = 0; // JMP_or_JAL
						control_signal[8] = 0; // branch
		
						control_signal[9] = 0; // mem_write
						control_signal[10] = 0; // mem_read

						control_signal[11] = 0; // mem_to_reg
						control_signal[12] = 0; // wwd
						control_signal[13] = 0; // pc_to_reg
						control_signal[14] = 0; // halt
						control_signal[16] = 0; // reg_dst
						control_signal[17] = 1; // reg_write
					end 
					`INST_FUNC_AND: begin
						control_signal[0] = 0; // alu_source
						control_signal[3:1] = `FUNC_AND; // alu_op
						control_signal[5:4] = 2'b00; // branch_type
						control_signal[6] = 0; // JPR_or_JRL
						control_signal[7] = 0; // JMP_or_JAL
						control_signal[8] = 0; // branch
		
						control_signal[9] = 0; // mem_write
						control_signal[10] = 0; // mem_read

						control_signal[11] = 0; // mem_to_reg
						control_signal[12] = 0; // wwd
						control_signal[13] = 0; // pc_to_reg
						control_signal[14] = 0; // halt
						control_signal[16] = 0; // reg_dst
						control_signal[17] = 1; // reg_write
					end 
					`INST_FUNC_ORR: begin
						control_signal[0] = 0; // alu_source
						control_signal[3:1] = `FUNC_ORR; // alu_op
						control_signal[5:4] = 2'b00; // branch_type
						control_signal[6] = 0; // JPR_or_JRL
						control_signal[7] = 0; // JMP_or_JAL
						control_signal[8] = 0; // branch
		
						control_signal[9] = 0; // mem_write
						control_signal[10] = 0; // mem_read

						control_signal[11] = 0; // mem_to_reg
						control_signal[12] = 0; // wwd
						control_signal[13] = 0; // pc_to_reg
						control_signal[14] = 0; // halt
						control_signal[16] = 0; // reg_dst
						control_signal[17] = 1; // reg_write
					end 
					`INST_FUNC_NOT: begin
						control_signal[0] = 0; // alu_source
						control_signal[3:1] = `FUNC_NOT; // alu_op
						control_signal[5:4] = 2'b00; // branch_type
						control_signal[6] = 0; // JPR_or_JRL
						control_signal[7] = 0; // JMP_or_JAL
						control_signal[8] = 0; // branch
		
						control_signal[9] = 0; // mem_write
						control_signal[10] = 0; // mem_read

						control_signal[11] = 0; // mem_to_reg
						control_signal[12] = 0; // wwd
						control_signal[13] = 0; // pc_to_reg
						control_signal[14] = 0; // halt
						control_signal[16] = 0; // reg_dst
						control_signal[17] = 1; // reg_write
					end 
					`INST_FUNC_TCP: begin
						control_signal[0] = 0; // alu_source
						control_signal[3:1] = `FUNC_TCP; // alu_op
						control_signal[5:4] = 2'b00; // branch_type
						control_signal[6] = 0; // JPR_or_JRL
						control_signal[7] = 0; // JMP_or_JAL
						control_signal[8] = 0; // branch
		
						control_signal[9] = 0; // mem_write
						control_signal[10] = 0; // mem_read

						control_signal[11] = 0; // mem_to_reg
						control_signal[12] = 0; // wwd
						control_signal[13] = 0; // pc_to_reg
						control_signal[14] = 0; // halt
						control_signal[16] = 0; // reg_dst
						control_signal[17] = 1; // reg_write
					end 
					`INST_FUNC_SHL: begin	
						control_signal[0] = 0; // alu_source
						control_signal[3:1] = `FUNC_SHL; // alu_op
						control_signal[5:4] = 2'b00; // branch_type
						control_signal[6] = 0; // JPR_or_JRL
						control_signal[7] = 0; // JMP_or_JAL
						control_signal[8] = 0; // branch
		
						control_signal[9] = 0; // mem_write
						control_signal[10] = 0; // mem_read

						control_signal[11] = 0; // mem_to_reg
						control_signal[12] = 0; // wwd
						control_signal[13] = 0; // pc_to_reg
						control_signal[14] = 0; // halt
						control_signal[16] = 0; // reg_dst
						control_signal[17] = 1; // reg_write
					end 
					`INST_FUNC_SHR: begin
						control_signal[0] = 0; // alu_source
						control_signal[3:1] = `INST_FUNC_SHR; // alu_op
						control_signal[5:4] = 2'b00; // branch_type
						control_signal[6] = 0; // JPR_or_JRL
						control_signal[7] = 0; // JMP_or_JAL
						control_signal[8] = 0; // branch
		
						control_signal[9] = 0; // mem_write
						control_signal[10] = 0; // mem_read

						control_signal[11] = 0; // mem_to_reg
						control_signal[12] = 0; // wwd
						control_signal[13] = 0; // pc_to_reg
						control_signal[14] = 0; // halt
						control_signal[16] = 0; // reg_dst
						control_signal[17] = 1; // reg_write
					end 
					`INST_FUNC_JPR: begin
						control_signal[0] = 0; // alu_source
						control_signal[3:1] = 3'b000; // alu_op
						control_signal[5:4] = 2'b00; // branch_type
						control_signal[6] = 1; // JPR_or_JRL
						control_signal[7] = 0; // JMP_or_JAL
						control_signal[8] = 0; // branch
		
						control_signal[9] = 0; // mem_write
						control_signal[10] = 0; // mem_read

						control_signal[11] = 0; // mem_to_reg
						control_signal[12] = 0; // wwd
						control_signal[13] = 0; // pc_to_reg
						control_signal[14] = 0; // halt
						control_signal[16] = 0; // reg_dst
						control_signal[17] = 0; // reg_write
					end
					`INST_FUNC_JRL: begin
						control_signal[0] = 0; // alu_source
						control_signal[3:1] = 3'b000; // alu_op
						control_signal[5:4] = 2'b00; // branch_type
						control_signal[6] = 1; // JPR_or_JRL
						control_signal[7] = 0; // JMP_or_JAL
						control_signal[8] = 0; // branch
		
						control_signal[9] = 0; // mem_write
						control_signal[10] = 0; // mem_read

						control_signal[11] = 0; // mem_to_reg
						control_signal[12] = 0; // wwd
						control_signal[13] = 1; // pc_to_reg
						control_signal[14] = 0; // halt
						control_signal[16] = 0; // reg_dst
						control_signal[17] = 1; // reg_write
					end
					`INST_FUNC_WWD: begin
						control_signal[0] = 0; // alu_source
						control_signal[3:1] = 3'b000; // alu_op
						control_signal[5:4] = 2'b00; // branch_type
						control_signal[6] = 0; // JPR_or_JRL
						control_signal[7] = 0; // JMP_or_JAL
						control_signal[8] = 0; // branch
		
						control_signal[9] = 0; // mem_write
						control_signal[10] = 0; // mem_read

						control_signal[11] = 0; // mem_to_reg
						control_signal[12] = 1; // wwd
						control_signal[13] = 0; // pc_to_reg
						control_signal[14] = 0; // halt
						control_signal[16] = 0; // reg_dst
						control_signal[17] = 0; // reg_write
					end
					`INST_FUNC_HLT: begin
						control_signal[0] = 0; // alu_source
						control_signal[3:1] = 3'b000; // alu_op
						control_signal[5:4] = 2'b00; // branch_type
						control_signal[6] = 0; // JPR_or_JRL
						control_signal[7] = 0; // JMP_or_JAL
						control_signal[8] = 0; // branch
		
						control_signal[9] = 0; // mem_write
						control_signal[10] = 0; // mem_read

						control_signal[11] = 0; // mem_to_reg
						control_signal[12] = 0; // wwd
						control_signal[13] = 0; // pc_to_reg
						control_signal[14] = 1; // halt
						control_signal[16] = 0; // reg_dst
						control_signal[17] = 0; // reg_write
					end
					default: begin
						control_signal[0] = 0; // alu_source
						control_signal[3:1] = 3'b000; // alu_op
						control_signal[5:4] = 2'b00; // branch_type
						control_signal[6] = 0; // JPR_or_JRL
						control_signal[7] = 0; // JMP_or_JAL
						control_signal[8] = 0; // branch
		
						control_signal[9] = 0; // mem_write
						control_signal[10] = 0; // mem_read

						control_signal[11] = 0; // mem_to_reg
						control_signal[12] = 0; // wwd
						control_signal[13] = 0; // pc_to_reg
						control_signal[14] = 0; // halt
						control_signal[16] = 0; // reg_dst
						control_signal[17] = 0; // reg_write
					end
				endcase
			end
			`ADI_OP: begin
				control_signal[0] = 1; // alu_source
				control_signal[3:1] = `FUNC_ADD; // alu_op
				control_signal[5:4] = 2'b00; // branch_type
				control_signal[6] = 0; // JPR_or_JRL
				control_signal[7] = 0; // JMP_or_JAL
				control_signal[8] = 0; // branch
		
				control_signal[9] = 0; // mem_write
				control_signal[10] = 0; // mem_read

				control_signal[11] = 0; // mem_to_reg
				control_signal[12] = 0; // wwd
				control_signal[13] = 0; // pc_to_reg
				control_signal[14] = 0; // halt
				control_signal[16] = 1; // reg_dst
				control_signal[17] = 1; // reg_write
			end
			`ORI_OP: begin
				control_signal[0] = 1; // alu_source
				control_signal[3:1] = `FUNC_ORR; // alu_op
				control_signal[5:4] = 2'b00; // branch_type
				control_signal[6] = 0; // JPR_or_JRL
				control_signal[7] = 0; // JMP_or_JAL
				control_signal[8] = 0; // branch
		
				control_signal[9] = 0; // mem_write
				control_signal[10] = 0; // mem_read

				control_signal[11] = 0; // mem_to_reg
				control_signal[12] = 0; // wwd
				control_signal[13] = 0; // pc_to_reg
				control_signal[14] = 0; // halt
				control_signal[16] = 1; // reg_dst
				control_signal[17] = 1; // reg_write
			end
			`LHI_OP: begin
				control_signal[0] = 1; // alu_source
				control_signal[3:1] = `FUNC_SHL; // alu_op
				control_signal[5:4] = 2'b01; // branch_type
				control_signal[6] = 0; // JPR_or_JRL
				control_signal[7] = 0; // JMP_or_JAL
				control_signal[8] = 0; // branch
		
				control_signal[9] = 0; // mem_write
				control_signal[10] = 0; // mem_read

				control_signal[11] = 0; // mem_to_reg
				control_signal[12] = 0; // wwd
				control_signal[13] = 0; // pc_to_reg
				control_signal[14] = 0; // halt
				control_signal[16] = 1; // reg_dst
				control_signal[17] = 1; // reg_write
			end
			`LWD_OP: begin
				control_signal[0] = 1; // alu_source
				control_signal[3:1] = `FUNC_ADD; // alu_op
				control_signal[5:4] = 2'b00; // branch_type
				control_signal[6] = 0; // JPR_or_JRL
				control_signal[7] = 0; // JMP_or_JAL
				control_signal[8] = 0; // branch
		
				control_signal[9] = 0; // mem_write
				control_signal[10] = 1; // mem_read

				control_signal[11] = 1; // mem_to_reg
				control_signal[12] = 0; // wwd
				control_signal[13] = 0; // pc_to_reg
				control_signal[14] = 0; // halt
				control_signal[16] = 1; // reg_dst
				control_signal[17] = 1; // reg_write

			end
			`SWD_OP: begin
				control_signal[0] = 1; // alu_source
				control_signal[3:1] = `FUNC_ADD; // alu_op
				control_signal[5:4] = 2'b00; // branch_type
				control_signal[6] = 0; // JPR_or_JRL
				control_signal[7] = 0; // JMP_or_JAL
				control_signal[8] = 0; // branch
		
				control_signal[9] = 1; // mem_write
				control_signal[10] = 0; // mem_read

				control_signal[11] = 0; // mem_to_reg
				control_signal[12] = 0; // wwd
				control_signal[13] = 0; // pc_to_reg
				control_signal[14] = 0; // halt
				control_signal[16] = 0; // reg_dst
				control_signal[17] = 0; // reg_write
			end
			`BNE_OP: begin
				control_signal[0] = 0; // alu_source
				control_signal[3:1] = `FUNC_SUB; // alu_op
				control_signal[5:4] = 2'b00; // branch_type
				control_signal[6] = 0; // JPR_or_JRL
				control_signal[7] = 0; // JMP_or_JAL
				control_signal[8] = 1; // branch
		
				control_signal[9] = 0; // mem_write
				control_signal[10] = 0; // mem_read

				control_signal[11] = 0; // mem_to_reg
				control_signal[12] = 0; // wwd
				control_signal[13] = 0; // pc_to_reg
				control_signal[14] = 0; // halt
				control_signal[16] = 1; // reg_dst
				control_signal[17] = 0; // reg_write
			end
			`BEQ_OP: begin
				control_signal[0] = 0; // alu_source
				control_signal[3:1] = `FUNC_SUB; // alu_op
				control_signal[5:4] = 2'b01; // branch_type
				control_signal[6] = 0; // JPR_or_JRL
				control_signal[7] = 0; // JMP_or_JAL
				control_signal[8] = 1; // branch
		
				control_signal[9] = 0; // mem_write
				control_signal[10] = 0; // mem_read

				control_signal[11] = 0; // mem_to_reg
				control_signal[12] = 0; // wwd
				control_signal[13] = 0; // pc_to_reg
				control_signal[14] = 0; // halt
				control_signal[16] = 1; // reg_dst
				control_signal[17] = 0; // reg_write
			end
			`BGZ_OP: begin
				control_signal[0] = 0; // alu_source
				control_signal[3:1] = `FUNC_ADD; // alu_op
				control_signal[5:4] = 2'b10; // branch_type
				control_signal[6] = 0; // JPR_or_JRL
				control_signal[7] = 0; // JMP_or_JAL
				control_signal[8] = 1; // branch
		
				control_signal[9] = 0; // mem_write
				control_signal[10] = 0; // mem_read

				control_signal[11] = 0; // mem_to_reg
				control_signal[12] = 0; // wwd
				control_signal[13] = 0; // pc_to_reg
				control_signal[14] = 0; // halt
				control_signal[16] = 1; // reg_dst
				control_signal[17] = 0; // reg_write
			end
			`BLZ_OP: begin
				control_signal[0] = 0; // alu_source
				control_signal[3:1] = `FUNC_ADD; // alu_op
				control_signal[5:4] = 2'b11; // branch_type
				control_signal[6] = 0; // JPR_or_JRL
				control_signal[7] = 0; // JMP_or_JAL
				control_signal[8] = 1; // branch
		
				control_signal[9] = 0; // mem_write
				control_signal[10] = 0; // mem_read

				control_signal[11] = 0; // mem_to_reg
				control_signal[12] = 0; // wwd
				control_signal[13] = 0; // pc_to_reg
				control_signal[14] = 0; // halt
				control_signal[16] = 1; // reg_dst
				control_signal[17] = 0; // reg_write
			end
			`JMP_OP: begin
				control_signal[0] = 0; // alu_source
				control_signal[3:1] = 3'b000; // alu_op
				control_signal[5:4] = 2'b00; // branch_type
				control_signal[6] = 0; // JPR_or_JRL
				control_signal[7] = 1; // JMP_or_JAL
				control_signal[8] = 0; // branch
		
				control_signal[9] = 0; // mem_write
				control_signal[10] = 0; // mem_read

				control_signal[11] = 0; // mem_to_reg
				control_signal[12] = 0; // wwd
				control_signal[13] = 0; // pc_to_reg
				control_signal[14] = 0; // halt
				control_signal[16] = 0; // reg_dst
				control_signal[17] = 0; // reg_write
			end
			`JAL_OP: begin
				control_signal[0] = 0; // alu_source
				control_signal[3:1] = 3'b000; // alu_op
				control_signal[5:4] = 2'b00; // branch_type
				control_signal[6] = 0; // JPR_or_JRL
				control_signal[7] = 1; // JMP_or_JAL
				control_signal[8] = 0; // branch
		
				control_signal[9] = 0; // mem_write
				control_signal[10] = 0; // mem_read

				control_signal[11] = 0; // mem_to_reg
				control_signal[12] = 0; // wwd
				control_signal[13] = 1; // pc_to_reg
				control_signal[14] = 0; // halt
				control_signal[16] = 0; // reg_dst
				control_signal[17] = 1; // reg_write
			end
			default: begin
				control_signal[0] = 0; // alu_source
				control_signal[3:1] = 3'b000; // alu_op
				control_signal[5:4] = 2'b00; // branch_type
				control_signal[6] = 0; // JPR_or_JRL
				control_signal[7] = 0; // JMP_or_JAL
				control_signal[8] = 0; // branch
		
				control_signal[9] = 0; // mem_write
				control_signal[10] = 0; // mem_read

				control_signal[11] = 0; // mem_to_reg
				control_signal[12] = 0; // wwd
				control_signal[13] = 0; // pc_to_reg
				control_signal[14] = 0; // halt
				control_signal[16] = 0; // reg_dst
				control_signal[17] = 0; // reg_write
			end
		endcase	
	end
endmodule