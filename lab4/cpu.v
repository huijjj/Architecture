`timescale 1ns/1ns
`define WORD_SIZE 16    // data and address word size

module cpu(clk, reset_n, read_m, write_m, address, data, num_inst, output_port, is_halted);
	input clk;
	input reset_n;
	
	output read_m;
	output write_m;
	output [`WORD_SIZE-1:0] address;

	inout [`WORD_SIZE-1:0] data;

	output [`WORD_SIZE-1:0] num_inst;		// number of instruction executed (for testing purpose)
	output [`WORD_SIZE-1:0] output_port;	// this will be used for a "WWD" instruction
	output is_halted;


	// internal data
	reg [`WORD_SIZE-1:0] PC;
	reg [`WORD_SIZE-1:0] instruction;

	// control signals
	reg PVSupdate;
	wire reg_write;


	// init
	initial begin
		PC = 0;
		instruction = 0;
		PVSupdate = 0;
	end

	// reset
	always @(*) begin
		if(!reset_n) begin
			PC = 0;
			instruction = 0;
			PVSupdate = 0;
		end
	end



	// module instanciation
	control_unit control_unit(

	);


	wire [`WORD_SIZE-1:0] reg_out1;
	wire [`WORD_SIZE-1:0] reg_out2;
	wire [`WORD_SIZE-1:0] write_data;
	wire [1:0] write_reg;
	register_file register_file(
		.read1(instruction[11:10]),
		.read2(instruction[9:8]),
		.write_reg(write_reg),
		.write_data(write_data),
		.reg_write(reg_write),
		.clk(clk),
		.reset_n(reset_n),
		.read_out1(reg_out1),
		.read_out2(reg_out2)
	);

	alu_control_unit alu_control_unit(

	);

	alu alu(

	);




endmodule
