`ifndef OTHERS_MODULE_V
`define OTHERS_MODULE_V

`define FUNC_TCP    4'b1110
`define FUNC_ZERO   4'b1111

module other_module #(parameter data_width = 16) (
	input [data_width - 1 : 0] _A,
	input func,
	output reg [data_width - 1 : 0] _C
);
	always @(*) begin
		if(func) // ZERO
			_C <= 16'h0000;
		else // TCP
			_C <= ~_A+1;
	end
endmodule

// module complement_or_zero #(parameter data_width = 16) (
// 	input [data_width - 1 : 0]A,
// 	input is_zero,
// 	output reg [data_width - 1 : 0]result,
// 	output offlag);
	
// 	assign offlag = 0;
// 	always @(*) begin
// 		if(is_zero)
// 			result = 0;
// 		else
// 			result = ~A+1;
// 	end	
// endmodule

`endif