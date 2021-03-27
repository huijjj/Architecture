module register_file( read_out1, read_out2, read1, read2, write_reg, write_data, reg_write, clk, reset_n, r0, r1, r2, r3, instruction_fetch); 
    output reg [15:0] read_out1;
    output reg [15:0] read_out2;
    input [1:0] read1;
    input [1:0] read2;
    input [1:0] write_reg;
    input [15:0] write_data;
    input reg_write;
    input clk;
	input reset_n;
	input instruction_fetch;

	output [15:0] r0;
	output [15:0] r1;
	output [15:0] r2;
	output [15:0] r3;	

    reg [15:0] x0;
    reg [15:0] x1;
   	reg [15:0] x2;
    reg [15:0] x3;


	assign r0 = x0;
	assign r1 = x1;
	assign r2 = x2;
	assign r3 = x3;

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

    	always @(negedge instruction_fetch) begin     
        	case(read1)
            		2'b11: begin
                		read_out1 <= x3;
            		end
            		2'b10: begin
                		read_out1 <= x2;                   
            		end
            		2'b01: begin
                		read_out1 <= x1;                  
            		end
            		default : begin
                		read_out1 <= x0;                  
            		end
        	endcase
        	case(read2)
            		2'b11: begin
                		read_out2 <= x3;
            		end
            		2'b10: begin
               			read_out2 <= x2;                   
            		end
            		2'b01: begin
                		read_out2 <= x1;                  
            		end
            		default : begin
                		read_out2 <= x0;                  
            		end
        	endcase 
    end

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


endmodule

