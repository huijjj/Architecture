`ifndef BITWISE_MODULE_V
`define BITWISE_MODULE_V

`define FUNC_ID     4'b0010
`define FUNC_NOT    4'b0011
`define FUNC_AND    4'b0100
`define FUNC_OR     4'b0101
`define FUNC_NAND   4'b0110
`define FUNC_NOR    4'b0111
`define FUNC_XOR    4'b1000
`define FUNC_XNOR   4'b1001

module bitwise_module #(parameter data_width = 16) (
    	input [data_width - 1 : 0]_A,
   	input [data_width - 1 : 0]_B,
	input [3 : 0]func,
	output reg [data_width - 1 : 0] _C
);
    	always @(*) begin
        	case (func)
            		`FUNC_ID: begin               
				_C <= _A;		        			        
           	 	end
            		`FUNC_NOT: begin
                		_C <= ~_A;
            		end
            		`FUNC_AND: begin
                		_C <= _A&_B;
            		end
            		`FUNC_OR: begin
                		_C <= _A|_B;
            		end
            		`FUNC_NAND: begin
               		 	_C <= ~(_A&_B);	
            		end
            		`FUNC_NOR: begin
                		_C <= ~(_A|_B);
            		end
            		`FUNC_XOR: begin
                		_C = _A^_B;
            		end
            		`FUNC_XNOR: begin
                		_C <=  ~(_A^_B);
           	 	end
            		default : begin
                		_C <= 16'h0000;
            		end
		endcase
    	end
endmodule

// module identity_not_module #(parameter data_width = 16) (
// 	input [data_width - 1 : 0]_A,
// 	input func,
// 	output reg [data_width - 1 : 0] _C
// );
// 	always @(*) begin
// 		if(func) // NOT
// 			_C <= ~_A;
// 		else // IDENTITY
// 			_C <= _A;
// 	end
// endmodule

// module and_or_module #(parameter data_width = 16) (
// 	input [data_width - 1 : 0]_A,
// 	input [data_width - 1 : 0]_B,
// 	input func,
// 	output reg [data_width - 1 : 0] _C
// );
// 	always @(*) begin
// 		if(func) // OR
// 			_C <= _A|_B;
// 		else // AND
// 			_C <= _A&_B; 
// 	end	
// endmodule

// module nand_nor_module #(parameter data_width = 16) (
// 	input [data_width - 1 : 0]_A,
// 	input [data_width - 1 : 0]_B,
// 	input func,
// 	output reg [data_width - 1 : 0] _C
// );
// 	always @(*) begin
// 		if(func) // NOR
// 			_C <= ~(_A|_B);
// 		else // NAND	
// 			_C <= ~(_A&_B);	
// 	end
// endmodule

// module xor_or_xnor #(parameter data_width = 16) (
// 	input [data_width - 1 : 0]A,
// 	input [data_width - 1 : 0]B,
// 	input is_neg,
// 	output reg [data_width - 1 : 0] result,
// 	output offlag);
	
// 	assign offlag = 0;
// 	always @(*) begin
// 		if(is_neg)
// 			result = ~(A^B); 
// 		else
// 			result = A^B;
// 	end
// endmodule

`endif