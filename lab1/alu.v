module ALU #(parameter data_width = 16) (
	input [data_width - 1 : 0] A, 
	input [data_width - 1 : 0] B, 
	input [3 : 0] FuncCode,
       	output reg [data_width - 1: 0] C,
       	output reg OverflowFlag);
// Do not use delay in your implementation.

// You can declare any variables as needed.
/*
	YOUR VARIABLE DECLARATION...
*/

initial begin
	C = 0;
	OverflowFlag = 0;
end   	

// TODO: You should implement the functionality of ALU!
// (HINT: Use 'always @(...) begin ... end')
/*
	YOUR ALU FUNCTIONALITY IMPLEMENTATION...
*/
 
`include "alu_func.v"
`include "alu_modules.v"

wire [data_width - 1 : 0]res[7 : 0];
wire of;

add_sub_module _add_sub_module(
	._A(A),
	._B(B),
	.func(FuncCode[0]),
	._C(res[7]),
	._O(of)
);

identity_not_module _identity_not_module(
	._A(A),
	.func(FuncCode[0]),
	._C(res[6])
);

and_or_module _and_or_module(
	._A(A),
	._B(B),
	.func(FuncCode[0]),
	._C(res[5])
);

nand_nor_module _nand_nor_module(
	._A(A),
	._B(B),
	.func(FuncCode[0]),
	._C(res[4])
);

xor_or_xnor xor_or_xnor_module(.A(A), .B(B), .is_neg(FuncCode[0]), .result(res[3]), .offlag(ofFlag));



logical_shift L_shift(.A(A), .is_right(FuncCode[0]), .result(res[2]), .offlag(ofFlag));



arith_shift A_shift(.A(A), .is_right(FuncCode[0]), .result(res[1]), .offlag(ofFlag));



complement_or_zero comp_zero(.A(A), .is_zero(FuncCode[0]), .result(res[0]), .offlag(ofFlag));




always @(*) begin
	case (FuncCode)
		`FUNC_ADD: begin
			C <= res[7];
			OverflowFlag <= of;
		end

		`FUNC_SUB: begin
			C <= res[7]; 
			OverflowFlag <= of;
		end

		`FUNC_ID: begin
			C <= res[6]; 
			OverflowFlag <= 1'b0;
		end

		`FUNC_NOT: begin
			C <= res[6]; 
			OverflowFlag <= 1'b0;
		end

		`FUNC_AND: begin
			C <= res[5]; 
			OverflowFlag <= 1'b0;
		end

		`FUNC_OR: begin
			C <= res[5];
			OverflowFlag <= 1'b0;
		end 

		`FUNC_NAND: begin
			C <= res[4]; 
			OverflowFlag <= 1'b0;
		end

		`FUNC_NOR: 
		begin
			C <= res[4]; 
			OverflowFlag <= 1'b0;
		end

		`FUNC_XOR: 
				begin
			C <= res[3]; 
			OverflowFlag <= 1'b0;
		end
		`FUNC_XNOR:
				begin
			C <= res[3]; 
			OverflowFlag <= 1'b0;
		end
		`FUNC_LLS: 
				begin
			C <= res[2]; 
			OverflowFlag <= 1'b0;
		end
		`FUNC_LRS: 
				begin
			C <= res[2]; 
			OverflowFlag <= 1'b0;
		end
		`FUNC_ALS: 
				begin
			C <= res[1]; 
			OverflowFlag <= 1'b0;
		end
		`FUNC_ARS: 
				begin
			C <= res[1]; 
			OverflowFlag <= 1'b0;
		end
		`FUNC_TCP: 
				begin
			C <= res[0]; 
			OverflowFlag <= 1'b0;
		end
		`FUNC_ZERO: 
				begin
			C <= res[0]; 
			OverflowFlag <= 1'b0;
		end

		default: begin
			C <= 16'b0;
			OverflowFlag <= 1'b0;
		end 
	endcase
end
endmodule

