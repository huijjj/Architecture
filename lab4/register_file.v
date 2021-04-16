module register_file(read_out1, read_out2, read1, read2, write_reg, write_data, reg_write, clk, reset_n, o_r0,o_r1, o_r2, o_r3); 
    	input [1:0] read1;
    	input [1:0] read2;
    	input [1:0] write_reg;
    	input [15:0] write_data;
    	input reg_write;
    	input clk;
	input reset_n;
    	output [15:0] read_out1;
    	output [15:0] read_out2;
	
	//for test
	output [15:0] o_r0;
	output [15:0] o_r1;
	output [15:0] o_r2;
	output [15:0] o_r3;

    	//TODO: implement register file

    	reg [15:0] x0;
   	reg [15:0] x1;
  	reg [15:0] x2;
    	reg [15:0] x3;

    	initial begin
    		x0 = 0;
     		x1 = 0;
    		x2 = 0;
    		x3 = 0;
    	end

	always @(*) begin
		if(!reset_n) begin
			x0 = 0;
        	x1 = 0;
        	x2 = 0;
        	x3 = 0;
		end
	end

    	mux4_1 read1_mux(
        	.sel(read1),
        	.i1(x0),
        	.i2(x1),
        	.i3(x2),
        	.i4(x3),
        	.o(read_out1)
    	);

    	mux4_1 read2_mux(
        	.sel(read2),
        	.i1(x0),
        	.i2(x1),
        	.i3(x2),
        	.i4(x3),
        	.o(read_out2)
    	);

    	always @(posedge clk) begin
        	if(reg_write) begin
            case(write_reg)
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

	//for test
	assign o_r0 = x0;
    	assign o_r1 = x1;
	assign o_r2 = x2;
	assign o_r3 = x3;
endmodule