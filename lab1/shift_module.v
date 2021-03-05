`ifndef SHIFT_MODULE_V
`define SHIFT_MODULE_V

`define FUNC_LLS    4'b1010
`define FUNC_LRS    4'b1011
`define FUNC_ALS    4'b1100
`define FUNC_ARS    4'b1101

module shift_module  #(parameter data_width = 16) (
    	input [data_width - 1 : 0] _A,
	input [3 : 0] func,
	output reg [data_width - 1 : 0] _C
);
	always @(*) begin
		case (func)
            		`FUNC_LLS: begin                
			   	_C <= (_A << 1);		        			        
            		end
            		`FUNC_LRS: begin
                		_C <= (_A >> 1);
            		end
            		`FUNC_ALS: begin 
                		_C <= (_A << 1);
            		end
            `		FUNC_ARS: begin // >>> dosen't seem to work
                		_C <= (_A >> 1);
				_C[data_width - 1] <= _A[data_width - 1];
			end
            		default : begin
                		_C <= 16'h0000;
            		end
		endcase
    	end
endmodule

// module logical_shift #(parameter data_width = 16) (
// 	input [data_width - 1 : 0] A,
// 	input is_right,
// 	output reg [data_width - 1 : 0] result,
// 	output offlag);
	
// 	assign fflag = 0;
// 	always @(*) begin
// 		if(is_right)
// 			result = A>>1;
// 		else
// 			result = A<<1;
// 	end
// endmodule

// module arith_shift #(parameter data_width = 16) (
// 	input [data_width - 1 : 0] A,
// 	input is_right,
// 	output reg [data_width - 1 : 0] result,
// 	output offlag);
	
// 	assign offlag = 0;
// 	always @(*) begin
// 		if(is_right)begin
// 			result = A >>> 1;
// 			if(A[data_width - 1]==1) begin
// 				result[data_width - 1] = A[data_width-1];
// 			end
// 		end
// 		else
// 			result = A <<< 1;
// 	end
// endmodule

`endif