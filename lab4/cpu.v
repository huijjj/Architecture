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
	reg [`WORD_SIZE-1:0] loaded_data;
	reg [`WORD_SIZE-1:0] instruction;
	reg [`WORD_SIZE-1:0] instruction_count;
	reg instruction_fetch;
	reg [`WORD_SIZE-1:0] next_pc;
	reg [`WORD_SIZE-1:0] branch_dst;

	// control signals
	wire reg_write;
	wire reg_dst;
	wire pc_to_reg;
	wire mem_read;
	wire jal;
	wire jalr;
	wire branch;
	wire alu_src_A;
	wire alu_src_B;
	wire PVSupdate;
	wire mem_write;
	wire mem_to_reg;
	wire reg_store;
	wire branch_dst_store;

	// init
	initial begin
		PC = 0;
		PVSupdate = 0;
		instruction = 0;
		instruction_count = 0;
		instruction_fetch = 1;
	end

	// reset
	always @(*) begin
		if(!reset_n) begin
			PC = 0;
			PVSupdate = 0;
			instruction = 0;
			instruction_count = 0;
			instruction_fetch = 1;
		end
	end

	// instuction fetch, memory read, PVS update
	always @(posedge clk) begin
		if(instruction_fetch & reset_n) begin
			instruction <= data;
			instruction_fetch <= 0;
		end
		else if(mem_read) begin
			loaded_data <= data;
		end
		else if(PVSupdate) begin
			PC <= o_jalr_mux;
			instruction_fetch <= 1;
			instruction_count = instruction_count + 1'b1;
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

	wire [`WORD_SIZE-1:0] imm;
	sign_extender sign_extender(
		.in(instruction[7:0]),
		.out(imm)
	);

	wire [`WORD_SIZE-1:0] addr;
	make_address make_address(
		.pc(PC),
		.instruction(instruction),
		.addr(addr)
	);

	alu_control_unit alu_control_unit(

	);

	wire [`WORD_SIZE-1:0] alu_out;
	wire [`WORD_SIZE-1:0] alu_input_1;
	wire [`WORD_SIZE-1:0] alu_input_2;
	wire [`WORD_SIZE-1:0] alu_output;
	wire branch_condition;
	alu alu(

	);

	// register input multiplexers
	wire [`WORD_SIZE-1:0] o_write_reg_mux;
	mux2_1 write_reg_mux(
		.sel(reg_dst),
		.i0(instruction[7:6]),
		.i1(instruction[9:8]),
		.o(o_write_reg_mux)
	);

	mux2_1 write_reg_mux(
		.sel(pc_to_reg),
		.i0(o_write_reg_mux),
		.i1(2'b10),
		.o(write_reg)
	);

	mux2_1 write_data_mux(
		.sel(mem_to_reg),
		.i0(alu_out),
		.i1(loaded_data),
		.o(write_data)
	);

	// alu input multiplexers
	mux2_1 alu_input_1_mux(
		.sel(alu_src_A),
		.i0(PC),
		.i1(reg_out1),
		.o(alu_input_1)
	);

	mux2_1 alu_src_B(
		.sel(alu_src_B),
		.i0(reg_out2),
		.i1(imm),
		.o(alu_input_2)
	);

	mux2_1 alu_input_2_mux(
		.sel(alu_src_A),
		.i0(16'h0001),
		.i1(reg_out2),
		.o(alu_input_2)
	);

	// branch and PC logic
	assign next_pc = reg_store ? alu_output : next_pc;
	assign branch_dst = branch_dst_store ? alu_output : branch_dst;

	wire [`WORD_SIZE-1:0] o_branch_dst_mux;
	mux2_1 branch_dst_mux(
		.sel(branch_condition & branch),
		.i0(next_pc),
		.i1(branch_dst),
		.o(o_branch_dst_mux)
	);

	wire [`WORD_SIZE-1:0] o_jal_mux;
	mux2_1 jal_mux(
		.sel(jal),
		.i0(o_branch_dst_mux),
		.i1(addr),
		.o(o_jal_mux)
	);

	wire [`WORD_SIZE-1:0] o_jalr_mux;
	mux2_1 jalr_mux(
		.sel(jalr),
		.i0(o_jal_mux),
		.i1(reg_out1),
		.o(o_jalr_mux)
	);

	// assigning CPU outputs
	assign read_m = (mem_read || instruction_fetch);
	assign data = (mem_read || CC == 2'b00) ? 16'bz : reg_out2;
	assign address = (CC == 2'b00) ? PC : alu_out;
	assign num_inst = instruction_count;

endmodule