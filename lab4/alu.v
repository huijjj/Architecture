`include "opcodes.v"

`define NumBits 16

module alu (A, B, func_code, branch_type, C, overflow_flag, bcond);
   input [`NumBits-1:0] A; //input data A
   input [`NumBits-1:0] B; //input data B
   input [2:0] func_code; //function code for the operation
   input [1:0] branch_type; //branch type for bne, beq, bgz, blz and 이단아
   output reg [`NumBits-1:0] C; //output data C
   output reg overflow_flag; 
   output reg bcond; //1 if branch condition met, else 0

   //TODO: implement ALU
   initial begin
      C = 0;
      overflow_flag = 0;
      bcond = 0;
   end

   always @(*) begin
      case(func_code)
         `FUNC_ADD: begin
            C = A + B;
            case(branch_type)
                2'b10: begin // bgz
				   	if(A[`NumBits-1] == 0 && A != 0) begin
				   		bcond = 1;
				   	end
				   	else begin
				   		bcond = 0;
				   	end
				end
				2'b11: begin // blz
				   	if(A[`NumBits-1] == 1 && A != 0) begin
				   		bcond = 1;
				   	end
				   	else begin
				   		bcond = 0;
				end
				   end
                default: begin
                    bcond = 0;
                    overflow_flag = ~(A[`NumBits - 1] ^ B[`NumBits - 1]) & (A[`NumBits - 1] ^ C[`NumBits - 1]);
                end
            endcase
        end
			`FUNC_SUB: begin
				C = A - B;
				case(branch_type)
					2'b00: begin // bne
						if(C == 0) begin
							bcond = 0;
						end
						else begin
							bcond = 1;
						end
					end
					2'b01: begin // beq
						if(C == 0) begin
							bcond = 1;
						end
						else begin
							bcond = 0;
						end
					end
					default: begin
						bcond = 0;
						overflow_flag = (A[`NumBits - 1] ^ B[`NumBits - 1]) & ~(A[`NumBits - 1] ^ C[`NumBits - 1]);
					end
				endcase
			end
			`FUNC_AND: begin
				C = A & B;
				bcond = 0;
			end
			`FUNC_ORR: begin
				C = A | B;
				bcond = 0;
			end
			`FUNC_NOT: begin
				C = ~A;
				bcond = 0;
			end
			`FUNC_TCP: begin
				C = ~A + 1;
				bcond = 0;
			end
			`FUNC_SHL: begin
				case(branch_type)
					2'b01: begin
						C = B << 8;
					end
					2'b00: begin
						C = A << 1;
					end
                default: begin
                end
				endcase
				bcond = 0;
			end
			`FUNC_SHR: begin
				C = A >> 1;
				C[`NumBits-1] = A[`NumBits-1];
				bcond = 0;
			end
         default: begin
         end
      endcase
   end
endmodule