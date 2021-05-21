`include "opcodes.v" 

module alu (A, B, func_code, branch_type, alu_out, overflow_flag, bcond);

	input [`WORD_SIZE-1:0] A;
	input [`WORD_SIZE-1:0] B;
	input [2:0] func_code;
	input [1:0] branch_type; 

	output reg [`WORD_SIZE-1:0] alu_out;
	output reg overflow_flag; 
	output reg bcond;

	initial begin
      alu_out = 0;
      overflow_flag = 0;
      bcond = 0;
   end
	
 always @(*) begin
      case(func_code)
         `FUNC_ADD: begin
            alu_out = A + B;
            case(branch_type)
                2'b10: begin // bgz
				   	if(A[`WORD_SIZE-1] == 0 && A != 0) begin
				   		bcond = 1;
				   	end
				   	else begin
				   		bcond = 0;
				   	end
				end
				2'b11: begin // blz
				   	if(A[`WORD_SIZE-1] == 1 && A != 0) begin
				   		bcond = 1;
				   	end
				   	else begin
				   		bcond = 0;
					end
				end
                default: begin
                    bcond = 0;
                    overflow_flag = ~(A[`WORD_SIZE - 1] ^ B[`WORD_SIZE - 1]) & (A[`WORD_SIZE - 1] ^ alu_out[`WORD_SIZE - 1]);
                end
            endcase
        end
		`FUNC_SUB: begin
			alu_out = A - B;
			case(branch_type)
				2'b00: begin // bne
					if(alu_out == 0) begin
						bcond = 0;
					end
					else begin
						bcond = 1;
					end
				end
				2'b01: begin // beq
					if(alu_out == 0) begin
						bcond = 1;
					end
					else begin
						bcond = 0;
					end
				end
				default: begin
					bcond = 0;
					overflow_flag = (A[`WORD_SIZE - 1] ^ B[`WORD_SIZE - 1]) & ~(A[`WORD_SIZE - 1] ^ alu_out[`WORD_SIZE - 1]);
				end
			endcase
		end
		`FUNC_AND: begin
			alu_out = A & B;
			bcond = 0;
		end
		`FUNC_ORR: begin
			alu_out = A | B;
			bcond = 0;
		end
		`FUNC_NOT: begin
			alu_out = ~A;
			bcond = 0;
		end
		`FUNC_TCP: begin
			alu_out = ~A + 1;
			bcond = 0;
		end
		`FUNC_SHL: begin
			case(branch_type)
				2'b01: begin
					alu_out = B << 8;
				end
				2'b00: begin
					alu_out = A << 1;
				end
            	default: begin
            	end
			endcase
			bcond = 0;
		end
		`FUNC_SHR: begin
			alu_out = A >> 1;
			alu_out[`WORD_SIZE-1] = A[`WORD_SIZE-1];
			bcond = 0;
		end
    	default: begin
     	end
      endcase
   end
endmodule