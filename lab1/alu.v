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
`include "add_sub_module.v"
`include "bitwise_module.v"
`include "shift_module.v"
`include "other_module.v"

wire [data_width - 1 : 0]res[3 : 0];
wire of;

add_sub_module _add_sub_module(
	._A(A),
	._B(B),
	.func(FuncCode[0]),
	._C(res[3]),
	._O(of)
);

bitwise_module _bitwise_module(
	._A(A),
	._B(B),
	.func(FuncCode),
	._C(res[2])
);

shift_module _shift_module(
	._A(A),
	.func(FuncCode),
	._C(res[1])
);

other_module _other_module(
	._A(A),
	.func(FuncCode[0]),
	._C(res[0])
);

always @(*) begin
	case (FuncCode)
		`FUNC_ADD: begin
			C <= res[3];
			OverflowFlag <= of;
		end

		`FUNC_SUB: begin
			C <= res[3]; 
			OverflowFlag <= of;
		end

		`FUNC_ID: begin
			C <= res[2]; 
			OverflowFlag <= 1'b0;
		end

		`FUNC_NOT: begin
			C <= res[2]; 
			OverflowFlag <= 1'b0;
		end

		`FUNC_AND: begin
			C <= res[2]; 
			OverflowFlag <= 1'b0;
		end

		`FUNC_OR: begin
			C <= res[2];
			OverflowFlag <= 1'b0;
		end 

		`FUNC_NAND: begin
			C <= res[2]; 
			OverflowFlag <= 1'b0;
		end

		`FUNC_NOR: begin
			C <= res[2]; 
			OverflowFlag <= 1'b0;
		end

		`FUNC_XOR: 	begin
			C <= res[2]; 
			OverflowFlag <= 1'b0;
		end
		`FUNC_XNOR:	begin
			C <= res[2]; 
			OverflowFlag <= 1'b0;
		end
		`FUNC_LLS: 	begin
			C <= res[1]; 
			OverflowFlag <= 1'b0;
		end
		`FUNC_LRS: begin
			C <= res[1]; 
			OverflowFlag <= 1'b0;
		end
		`FUNC_ALS: begin
			C <= res[1]; 
			OverflowFlag <= 1'b0;
		end
		`FUNC_ARS: begin
			C <= res[1]; 
			OverflowFlag <= 1'b0;
		end
		`FUNC_TCP: begin
			C <= res[0]; 
			OverflowFlag <= 1'b0;
		end
		`FUNC_ZERO: begin
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

