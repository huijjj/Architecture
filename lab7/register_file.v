`include "opcodes.v" 

module register_file (read_out1, read_out2, read1, read2, dest, write_data, reg_write, clk, reset_n
, o_x0, o_x1, o_x2, o_x3
);

	input clk, reset_n;
	input [1:0] read1;
	input [1:0] read2;
	input [1:0] dest;
	input reg_write;
	input [`WORD_SIZE-1:0] write_data;
	

	output [`WORD_SIZE-1:0] read_out1;
	output [`WORD_SIZE-1:0] read_out2;

	// for test
	output [15:0] o_x0;
	output [15:0] o_x1;
	output [15:0] o_x2;
	output [15:0] o_x3;


	
	//TODO: implement register file
	reg [15:0] x0;
   	reg [15:0] x1;
  	reg [15:0] x2;
	reg [15:0] x3;

	// initialize
    initial begin
    	x0 = 0;
    	x1 = 0;
    	x2 = 0;
    	x3 = 0;
    end

	// reset
	always @(*) begin
		if(!reset_n) begin
			x0 = 0;
        	x1 = 0;
        	x2 = 0;
        	x3 = 0;
		end
	end

	// read data
    assign read_out1 = (read1 == 2'b00 ? x0 : (read1 == 2'b01 ? x1 : (read1 == 2'b10 ? x2 : x3)));
    assign read_out2 = (read2 == 2'b00 ? x0 : (read2 == 2'b01 ? x1 : (read2 == 2'b10 ? x2 : x3)));

	// write data
    always @(posedge clk) begin
    	if(reg_write) begin
        	case(dest)
            	2'b11: begin
                	x3 <= write_data;
            	end
            	2'b10: begin
                	x2 <= write_data;                   
            	end
            	2'b01: begin
                	x1 <= write_data;                  
            	end
            	default : begin
                	x0 <= write_data;                  
            	end
        	endcase 
    	end
   	end

	// for test
	assign o_x0 = x0;
	assign o_x1 = x1;
	assign o_x2 = x2;
	assign o_x3 = x3;
endmodule
