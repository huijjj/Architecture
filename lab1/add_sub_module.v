`ifndef ADD_SUB_MODULE_V
`define ADD_SUB_MODULE_V

module add_sub_module #(parameter data_width = 16) (
	input [data_width - 1 : 0] _A,
	input [data_width - 1 : 0] _B,
	input func,
	output reg [data_width - 1 : 0] _C,
	output reg _O
);
	reg [data_width - 1 : 0] temp;

	always @(*) begin
		if(func) // SUB
			temp = -_B;
		else // ADD
			temp = _B;

		_C = _A + temp;
		_O = ~(_A[data_width - 1] ^ temp[data_width - 1]) & (_A[data_width - 1] ^ _C[data_width - 1]);
	end
endmodule

`endif