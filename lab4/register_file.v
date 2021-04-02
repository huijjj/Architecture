module register_file(read_out1, read_out2, read1, read2, write_reg, write_data, reg_write, clk); 
    input [1:0] read1;
    input [1:0] read2;
    input [1:0] write_reg;
    input [15:0] write_data;
    input reg_write;
    input clk;
    output [15:0] read_out1;
    output [15:0] read_out2;

    //TODO: implement register file

endmodule