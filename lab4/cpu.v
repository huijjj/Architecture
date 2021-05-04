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
	reg [`WORD_SIZE-1:0] PC; // program counter
	reg [`WORD_SIZE-1:0] loaded_data; // loaded data from memory
	reg [`WORD_SIZE-1:0] instruction; // feteched instruction
	reg [`WORD_SIZE-1:0] instruction_count; // # of instructions executed
	reg [`WORD_SIZE-1:0] next_pc; // temporary storage for storing intermediate alu results (pc + 1)
	reg [`WORD_SIZE-1:0] branch_dst; // temporary storage for storing intermediate alu results (branch target)
	reg [`WORD_SIZE-1:0] wwd_output; // temporary register holding value of one of the register in register file for wwd output 
 
	reg instruction_fetch; // instruction fetch trigger
	reg PVSupdate; // pvs updatae trigger

	// control signals
	wire wwd; // identifies wwd instruction
	wire branch; // idenfifies branch instrution

	wire reg_write; // register write signal
	wire reg_dst; // write register mux control signal
	wire pc_to_reg; // write register mux control signal
	wire mem_to_reg; // write data mux control signal

	wire alu_src_A; // alu source mux control signal
	wire alu_src_B; // alu source mux control signal
	wire alu_op; // control signal for alu control unit

	wire mem_read; // memory read signal(load)
	wire mem_write; // nemory write signal(store)

	wire jal; // pc calc datapath mux control signal
	wire jalr; // pc calc datapath mux control signal
	
	wire pc_store; // value update control signal for alu intermediate storages
	wire branch_dst_store; // value update control signal for alu intermediate storages

	wire pvs; //pvs update signal, identifies the end of the instruction
	assign PVSupdate = pvs;

	// init
	initial begin
		PC = 0;
		PVSupdate = 0;
		instruction = 0;
		instruction_count = 0;
		instruction_fetch = 1;
		next_pc = 0;
		branch_dst = 0;
		wwd_output = 0;
	end

	// reset
	always @(*) begin
		if(!reset_n) begin
			PC = 0;
			PVSupdate = 0;
			instruction = 0;
			instruction_count = 0;
			instruction_fetch = 1;
			next_pc = 0;
			branch_dst = 0;
			wwd_output = 0;
		end
	end

	// instuction fetch, memory read, PVS update
	wire [`WORD_SIZE-1:0] o_jalr_mux; // final output from next pc datapath 
	always @(posedge clk) begin
		if(instruction_fetch & reset_n) begin
			instruction <= data;
			instruction_fetch <= 0;
		end
		else if(mem_read) begin
			loaded_data <= data;
		end
		else if(PVSupdate & reset_n) begin
			PC <= o_jalr_mux;
			instruction_fetch <= 1;
			instruction_count = instruction_count + 1'b1;
		end
		else begin
		end
	end

	// module instanciation
	control_unit control_unit(
		.reset_n(reset_n),
		.opcode(instruction[15:12]),
		.func_code(instruction[5:0]),
		.clk(clk),
		.reg_write(reg_write),
		.reg_dst(reg_dst),
		.pc_to_reg(pc_to_reg),
		.mem_read(mem_read),
		.jal(jal),
		.jalr(jalr),
		.branch(branch),
		.alu_src_A(alu_src_A),
		.alu_src_B(alu_src_B),
		.PVSupdate(pvs),
		.mem_write(mem_write),
		.mem_to_reg(mem_to_reg),
		.pc_store(pc_store),
		.branch_dst_store(branch_dst_store),
		.alu_op(alu_op),
		.halt(is_halted),
		.wwd(wwd)
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

	
	wire [2:0] func;
	wire [1:0] branch_type;
	alu_control_unit alu_control_unit(
		.alu_op(alu_op),
		.funct(instruction[5:0]),
		.opcode(instruction[15:12]),
		.funcCode(func),
		.branchType(branch_type)
	);

	wire [`WORD_SIZE-1:0] alu_out;
	wire [`WORD_SIZE-1:0] alu_input_1;
	wire [`WORD_SIZE-1:0] alu_input_2;
	wire branch_condition;
	wire overflow_flag;
	alu alu(
		.A(alu_input_1), 
		.B(alu_input_2), 
		.func_code(func), 
		.branch_type(branch_type), 
		.C(alu_out), 
		.overflow_flag(overflow_flag), 
		.bcond(branch_condition)
	);

	// register input multiplexers
	wire [`WORD_SIZE-1:0] o_write_reg_mux;
	assign o_write_reg_mux = reg_dst ? instruction[9:8] : instruction[7:6];
	assign write_reg = pc_to_reg ? 2'b10 : o_write_reg_mux;

	mux2_1 write_data_mux(
		.sel(mem_to_reg),
		.i1(alu_out),
		.i2(loaded_data),
		.o(write_data)
	);

	// alu input multiplexers
	wire [`WORD_SIZE-1:0] o_alu_src_A;
	mux2_1 alu_src_A_mux(
		.sel(alu_src_A),
		.i1(PC),
		.i2(reg_out1),
		.o(o_alu_src_A)
	);

	mux2_1 alu_input_1_mux(
		.sel(branch & alu_src_B),
		.i1(o_alu_src_A),
		.i2(next_pc),
		.o(alu_input_1)
	);

	wire [`WORD_SIZE-1:0] o_alu_src_B;
	mux2_1 alu_src_B_mux(
		.sel(alu_src_B),
		.i1(reg_out2),
		.i2(imm),
		.o(o_alu_src_B)
	);

	mux2_1 alu_input_2_mux(
		.sel(alu_src_A),
		.i1(16'h0001),
		.i2(o_alu_src_B),
		.o(alu_input_2)
	);

	// branch and PC logic
	assign next_pc = pc_store ? alu_out : next_pc;
	assign branch_dst = branch_dst_store ? alu_out : branch_dst;

	wire [`WORD_SIZE-1:0] o_branch_dst_mux;
	mux2_1 branch_dst_mux(
		.sel(branch_condition & branch),
		.i1(next_pc),
		.i2(branch_dst),
		.o(o_branch_dst_mux)
	);

	wire [`WORD_SIZE-1:0] o_jal_mux;
	mux2_1 jal_mux(
		.sel(jal),
		.i1(o_branch_dst_mux),
		.i2(addr),
		.o(o_jal_mux)
	);

	mux2_1 jalr_mux(
		.sel(jalr),
		.i1(o_jal_mux),
		.i2(reg_out1),
		.o(o_jalr_mux)
	);

	// assigning CPU outputs
	assign read_m = (mem_read || instruction_fetch);
	assign data = (mem_read || instruction_fetch) ? 16'bz : reg_out2;
	assign address = instruction_fetch ? PC : alu_out;
	assign num_inst = instruction_count;
	assign output_port = wwd_output;
	assign wwd_output = wwd ? reg_out1 : wwd_output;
	assign write_m = mem_write;
	
endmodule