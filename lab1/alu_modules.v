`ifndef ALU_MODULES_V
`define ALU_MODULES_V

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

module identity_not_module #(parameter data_width = 16) (
	input [data_width - 1 : 0]_A,
	input func,
	output reg [data_width - 1 : 0] _C
);
	always @(*) begin
		if(func) // NOT
			_C <= ~_A;
		else // IDENTITY
			_C <= _A;
	end
endmodule

module and_or_module #(parameter data_width = 16) (
	input [data_width - 1 : 0]_A,
	input [data_width - 1 : 0]_B,
	input func,
	output reg [data_width - 1 : 0] _C
);
	always @(*) begin
		if(func) // OR
			_C <= _A|_B;
		else // AND
			_C <= _A&_B; 
	end	
endmodule

module nand_nor_module #(parameter data_width = 16) (
	input [data_width - 1 : 0]_A,
	input [data_width - 1 : 0]_B,
	input func,
	output reg [data_width - 1 : 0] _C
);
	always @(*) begin
		if(func) // NOR
			_C <= ~(_A|_B);
		else // NAND	
			_C <= ~(_A&_B);	
	end
endmodule

`endif