`include "opcodes.v"

module use_rs(instruction, use_reg);
	input [`WORD_SIZE-1:0] instruction;
	output reg use_reg;

	always @(*) begin
		if(instruction[15:12] == `JMP_OP || instruction[15:12] == `JAL_OP || (instruction[15:12] == `HLT_OP && instruction[5:0] == `INST_FUNC_HLT)) begin
			// JMP or JAL or HLT
			use_reg = 0;
		end
		else begin
			use_reg = 1;
		end	
	end
endmodule

module use_rt(instruction, use_reg);
	input [`WORD_SIZE-1:0] instruction;
	output reg use_reg;
	
	// ADD, SUB, AND, ORR, SWD, BXX -> use = 1;


	always @(*) begin
		case(instruction[15:12])
			`ALU_OP: begin
				case(instruction[5:0])
					`INST_FUNC_ADD,
					`INST_FUNC_SUB,
					`INST_FUNC_AND,
					`INST_FUNC_ORR: begin
						use_reg = 1;
					end
					default: begin
						use_reg = 0;
					end
				endcase
			end
			`SWD_OP,  
			`BNE_OP,
			`BEQ_OP,
			`BGZ_OP,
			`BLZ_OP: begin
				use_reg = 1;
			end
			default: begin
				use_reg = 0;
			end
		endcase
	end
endmodule


module mux2_1 (sel, i0, i1, o);
   input sel;
   input [15:0] i0, i1;
   output reg [15:0] o;

   always @ (*) begin
        case (sel)
            0: o = i0;
            1: o = i1;
        endcase
   end

endmodule

module mux3_1 (sel, i0, i1, i2, o);
   input [1:0]sel;
   input [15:0] i0, i1, i2;
   output reg [15:0] o;

   always @ (*) begin
        case (sel)
            2'b00: o = i0;
            2'b01: o = i1;
            2'b10: o = i2;
            default: o = 16'h0;
        endcase
   end

endmodule

module adder (input_1, input_2, result);
    input [15:0] input_1;
    input [15:0] input_2;

    output [15:0] result;
    
    assign result = input_1 + input_2;

endmodule

module sign_extender(in, out);
	input [7:0] in;
	output [15:0] out;

	assign out[7:0] = in[7:0];
	assign out[8] = in[7];
	assign out[9] = in[7];
	assign out[10] = in[7];
	assign out[11] = in[7];
	assign out[12] = in[7];
	assign out[13] = in[7];
	assign out[14] = in[7];
	assign out[15] = in[7];
endmodule

module make_address(pc, instruction, addr);
	input [15:0] pc;
	input [15:0] instruction;
	output [15:0] addr;
	assign addr[15:12] = pc[15:12];
	assign addr[11:0] = instruction[11:0];
endmodule