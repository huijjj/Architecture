`include "opcodes.v"

module mux1 (
	input [`WORD_SIZE-1:0] input0,
	input [`WORD_SIZE-1:0] input1,
	input sel,
	output [`WORD_SIZE-1:0] out
);
	assign out = sel ? input1 : input0;
endmodule

module mux2 (
	input [1:0] input0,
	input [1:0] input1,
	input sel,
	output [1:0] out
);
	assign out = sel ? input1 : input0;
endmodule

// module mux3 (
// 	input [1:0] input0,
// 	input [`WORD_SIZE-1:0] data_0,
// 	input [`WORD_SIZE-1:0] data_1,
// 	input sel,
// 	output [1:0] out_0,
// 	output [`WORD_SIZE-1:0] out_1
// );
// 	assign out_0 = sel ? 2'b10 : input0;
// 	assign out_1 = sel ? data_1 : data_0;
// endmodule

module sign_extender(input_imm, output_imm);
	input [7:0]input_imm;
	output [`WORD_SIZE-1:0] output_imm;
	assign output_imm[7:0] = input_imm[7:0];
	assign	output_imm[8] = input_imm[7];
	assign	output_imm[9] = input_imm[7];
	assign	output_imm[10] = input_imm[7];
	assign	output_imm[11] = input_imm[7];
	assign	output_imm[12] = input_imm[7];
	assign	output_imm[13] = input_imm[7];
	assign	output_imm[14] = input_imm[7];
	assign	output_imm[15] = input_imm[7];
endmodule

module ADD(data_0, data_1, result);
	input [`WORD_SIZE-1:0] data_0;
	input [`WORD_SIZE-1:0] data_1;
	output [`WORD_SIZE-1:0] result;
	assign result = data_0 + data_1;
endmodule

module make_address(pc, offset, result);
	input [`WORD_SIZE-1:0] pc;
	input [`WORD_SIZE-1:0] offset;
	output [`WORD_SIZE-1:0] result;
	assign result[15:12] = pc[15:12];
	assign result[11:0] = offset[11:0];
endmodule

module AND(data_0, data_1, result);
	input data_0;
	input data_1;
	output result;
	assign result = data_0 & data_1;
endmodule

module cpu (readM, writeM, address, data, ackOutput, inputReady, reset_n, clk);
	output reg readM;									
	output writeM;								
	output [`WORD_SIZE-1:0] address;	
	inout [`WORD_SIZE-1:0] data;		
	input ackOutput;								
	input inputReady;								
	input reset_n;									
	input clk;		
	


	reg [`WORD_SIZE-1:0] PC; // program counter
	reg [`WORD_SIZE-1:0] instruction; // fetched instruction
	reg [`WORD_SIZE-1:0] loaded_data; // loaded data
	

	// control signals
	wire alu_src;
	wire reg_write;
	wire mem_to_reg;
	wire jal;
	wire jalr;
	wire pc_to_reg;
	wire mem_write;

	wire branch;
	wire reg_dst;
	wire mem_read;

	
	reg instruction_fetch;
	reg o_writeM;
	

	initial begin // initialize
		PC = 0;	
		instruction = 0;
		instruction_fetch = 0;
		loaded_data = 0;
		readM = 0;
		o_writeM = 0;
	end

	always @(*) begin // reset
		if(!reset_n) begin
			PC = 0;
			instruction = 0;
			instruction_fetch = 0;	
			loaded_data = 0;
			readM = 0;
			o_writeM = 0;
			
		end
	end
	
	

	//module instantiation
	control_unit control(
		.instr(instruction),
		.alu_src(alu_src),
		.reg_write(reg_write),
		.mem_read(mem_read),
		.mem_to_reg(mem_to_reg),
		.mem_write(mem_write),
		.branch(branch),
		.jal(jal),
		.jalr(jalr),
		.pc_to_reg(pc_to_reg),
		.reg_dst(reg_dst)
	);

	wire [15:0] regout_1; // data out from register
	wire [15:0] regout_2; // data out from register
	wire [15:0] write_data; // data to write in register
	wire [1:0] write_reg; // register to write data
	register_file register(
		.read_out1(regout_1),
		.read_out2(regout_2),
		.read1(instruction[11:10]),
		.read2(instruction[9:8]),
		.write_reg(write_reg),
		.write_data(write_data),
		.reg_write(reg_write),
		.clk(clk),
		.reset_n(reset_n),
		.instruction_fetch(instruction_fetch)
	);

	assign reg_input_data = write_data;

	wire [3:0] o_opcode;
	wire [2:0] o_func_code;
	wire [5:0] o_instruction_func_code;
	alu_control alu_control(
		.instrc(instruction),
		.o_opcode(o_opcode),
		.o_alu_func_code(o_func_code),
		.o_instrc_func_code(o_instruction_func_code)
	);

	wire [15:0] alu_output; // ALU operation result
	wire [15:0] alu_input_2;
	wire bcond;
	alu alu(
		.alu_input_1(regout_1),
		.alu_input_2(alu_input_2),
		.opcode(o_opcode),
		.func_code(o_func_code),
		.instrc_func(o_instruction_func_code),
		.bcond(bcond),
		.alu_output(alu_output)
	);

	wire [15:0] imm;
	sign_extender imm_gen(
		.input_imm(instruction[7:0]),
		.output_imm(imm)	
	);

	//multiplexers

	// [7:6] rd
	// [9:8] rt
	wire [1:0] o_reg_dst_mux;
	mux2 reg_dst_mux(
		.input0(instruction[7:6]), 
		.input1(instruction[9:8]), 
		.sel(reg_dst),
		.out(o_reg_dst_mux)
	);

	mux2 pc_to_reg_mux(
		.input0(o_reg_dst_mux), 
		.input1(2'b10), 
		.sel(pc_to_reg),
		.out(write_reg)
	);

	mux1 alu_src_mux(
		.input0(regout_2),
		.input1(imm),
		.sel(alu_src),
		.out(alu_input_2)
	);
	
	wire [15:0] o_data_src_mux;
	mux1 data_src_mux(
		.input0(alu_output),
		.input1(loaded_data),
		.sel(mem_to_reg),
		.out(o_data_src_mux)
	);

	mux1 write_data_mux(
		.input0(o_data_src_mux),
		.input1(PC + 1'b1),
		.sel(pc_to_reg),
		.out(write_data)
	);

	// TODO: PC update
	wire [15:0] pc_plus_one;
	wire [15:0] pc_plus_imm;
	wire [15:0] combine_pc_offset;
	wire is_branch;
	wire [15:0] o_is_branch_module;
	wire [15:0] o_is_jal_module;
	wire [15:0] next_pc;

	ADD pc_plus_one_module(
		.data_0(PC),
		.data_1(16'h0001),
		.result(pc_plus_one)
	);

	ADD pc_plus_imm_module(
		.data_0(pc_plus_one),
		.data_1(imm),
		.result(pc_plus_imm)
	);

	make_address combine_pc_and_offset_module(
		.pc(PC),
		.offset(instruction),
		.result(combine_pc_offset)
	);

	AND bcond_and_branch(
		.data_0(bcond),
		.data_1(branch),
		.result(is_branch)
	);

	mux1 is_branch_module(
		.input0(pc_plus_one),
		.input1(pc_plus_imm),
		.sel(is_branch),
		.out(o_is_branch_module)
	);

	mux1 is_jal_module(
		.input0(o_is_branch_module),
		.input1(combine_pc_offset),
		.sel(jal),
		.out(o_is_jal_module)
	);

	mux1 is_jalr_module(
		.input0(o_is_jal_module),
		.input1(alu_output),
		.sel(jalr),
		.out(next_pc)
	);


	// connectiong outputs
	
	assign data = (mem_read | instruction_fetch) ? 16'bz : regout_2;
	assign readM = instruction_fetch | mem_read;
	assign address = instruction_fetch ? PC : alu_output;
	assign writeM = o_writeM;


	// clock sync
	always @(posedge clk) begin
		instruction_fetch <= 1;
	end

	always @(negedge clk) begin
		if(reset_n) begin
			PC <= next_pc;
			o_writeM <= mem_write;
		end
	end

	always @(posedge inputReady) begin
		instruction_fetch <= 0;
		if(instruction_fetch) begin
			instruction <= data;
		end
		else begin
			loaded_data <= data;
		end
	end

	always @(posedge ackOutput) begin
		o_writeM <= 0;
	end

endmodule							  																		  