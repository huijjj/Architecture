`include "opcodes.v"

module mux1 (
	input [`WORD_SIZE-1:0] input0,
	input [`WORD_SIZE-1:0] input1,
	input sel,
	output reg [`WORD_SIZE-1:0] out
);
	always @(*) begin
		case (sel)
			0: out = input0;
			1: out = input1;
			default: out = 0;
		endcase
	end
endmodule

module mux2 (
	input [1:0] input0,
	input [1:0] input1,
	input sel,
	output reg [1:0] out
);
	always @(*) begin
		case (sel)
			0: out = input0;
			1: out = input1;
			default: out = 0;
		endcase
	end
endmodule

module mux3 (
	input [1:0] input0,
	input [`WORD_SIZE-1:0] data_0,
	input [`WORD_SIZE-1:0] data_1,
	input sel,
	output reg [1:0] out_0,
	output reg [`WORD_SIZE-1:0] out_1
);
	always @(*) begin
		case (sel)
			0: begin
				out_0 = input0;
				out_1 = data_0;
			end
			1: begin
				out_0 = 2;
				out_1 = data_1;
			end
			
		endcase	
	end
endmodule

module mux4 (
	input [15:0] input0,
	input [15:0] input1,
	input [15:0] input2,
	input sel_0,
	input sel_1,
	output reg [15:0] out
);
	always @(*) begin
		if(sel_0 == 0 && sel_1 == 0) begin
			out = input1;
		end
		else if(sel_0 == 0 && sel_1 != 0) begin
			out = input2;
		end
		else if(sel_0 != 0 && sel_1 == 0) begin
			out = input0;
		end
	end
endmodule

module sign_extender(input_imm, output_imm);
	input [7:0]input_imm;
	output reg [`WORD_SIZE-1:0] output_imm;

	always @(*) begin
		output_imm[7:0] = input_imm[7:0];
		output_imm[8] = input_imm[7];
		output_imm[9] = input_imm[7];
		output_imm[10] = input_imm[7];
		output_imm[11] = input_imm[7];
		output_imm[12] = input_imm[7];
		output_imm[13] = input_imm[7];
		output_imm[14] = input_imm[7];
		output_imm[15] = input_imm[7];
	end
endmodule

module ADD(data_0, data_1, result);
	input [`WORD_SIZE-1:0] data_0;
	input [`WORD_SIZE-1:0] data_1;
	output reg [`WORD_SIZE-1:0] result;

	always @(*) begin
		result = data_0 + data_1;
	end
endmodule

module make_address(pc, imm, result);
	input [`WORD_SIZE-1:0] pc;
	input [`WORD_SIZE-1:0] imm;
	output reg [`WORD_SIZE-1:0] result;

	always @(*) begin
		result[15:12] =	pc[15:12];
		result[11:0] = imm[11:0];
	end
endmodule

module AND(input0, input1, result);
	input input0;
	input input1;
	output reg result;

	always @(*) begin
		result = input0 & input1;
	end
endmodule

module cpu (readM, writeM, address, data, ackOutput, inputReady, reset_n, clk);
	output readM;									
	output writeM;								
	output [`WORD_SIZE-1:0] address;	
	inout [`WORD_SIZE-1:0] data;		
	input ackOutput;								
	input inputReady;								
	input reset_n;									
	input clk;			

	reg [`WORD_SIZE-1:0] PC;
	reg [`WORD_SIZE-1:0] instruction;

	wire reg_write;
	wire alu_src;
	wire mem_to_reg;
	wire jal;
	wire jalr;
	wire pc_to_reg;
	wire branch;
	wire reg_dst;
	
	reg memory_read;
	assign readM = memory_read;
	
	reg addr;
	assign address = addr;

	initial begin
		PC = 0;	
	end

	always @(posedge clk) begin // instruction fetch
		addr <= PC;
		memory_read <= 1;
		instruction <= data;
	end

	wire [15:0]sign_extend_imm;
	wire [15:0]alu_output;

	wire [1:0]write_reg_0;

	wire [15:0] alu_read2;
	wire [2:0] alu_func;

	wire [1:0] read1;
	wire [1:0] read2;
	wire [1:0] write_reg;
	wire [15:0] write_data;

	wire [1:0] final_write_reg;
	wire [15:0] final_write_data;

	wire [15:0] reg_read1;
	wire [15:0] reg_read2;

	wire [2:0] alu_control_alufunc;
	wire [5:0] alu_control_insfunc;
	wire [3:0] alu_control_opcode;

	wire bcond;

	wire [15:0] pcPlus4;
	wire [15:0] combine_PCimm;
	wire [15:0] pcPlusimm;
	wire [15:0] calc_next_pc;
	wire selector;

	mux2 select_rd_or_rt(
		.input0(instruction[7:6]), // 0이면 rd
		.input1(instruction[9:8]), // 1이면 rt
		.sel(reg_dst),
		.out(write_reg_0)
	);

	mux3 select_wrReg_and_wrData(
		.input0(write_reg_0),
		.data_0(write_data), //
		.data_1(pcPlus4), //PC+4
		.sel(pc_to_reg),
		.out_0(final_write_reg),
		.out_1(final_write_data)
	);

	mux1 select_alu_input_data2(
		.input0(reg_read2),
		.input1(sign_extend_imm),
		.sel(alu_src),
		.out(alu_read2)
	);

	mux1 select_wrReg_data(
		.input0(data),
		.input1(alu_output),
		.sel(memory_read),
		.out(write_data)
	);

	ADD pc_plus_4(
		.data_0(PC),
		.data_1(16'h0004),
		.result(pcPlus4)
	);

	make_address combine_PC_and_imm(
		.pc(PC),
		.imm(sign_extend_imm),
		.result(combine_PCimm)
	);

	ADD pc_plus_imm(
		.data_0(PC),
		.data_1(sign_extend_imm),
		.result(pcPlusimm)
	);

	AND and_moudule(
		.input0(branch),
		.input1(bcond),
		.result(selector)
	);

	mux4 calc_next_PCaddress(
		.input0(combine_PCimm),
		.input1(pcPlus4),
		.input2(pcPlusimm),
		.sel_0(jal),
		.sel_1(selector),
		.out(calc_next_pc)
	);

	wire [15: 0] pc_out;
	assign PC = pc_out;

	mux1 select_next_pc(
		.input0(calc_next_pc),
		.input1(alu_output),
		.sel(jalr),
		.out(pc_out)
	);

	wire temp;
	assign memory_read = temp;

	control_unit control(
		.instr(instruction),
		.alu_src(alu_src),
		.reg_write(reg_write),
		.mem_read(temp),
		.mem_to_reg(mem_to_reg),
		.mem_write(writeM),
		.branch(branch),
		.jal(jal),
		.jalr(jalr),
		.pc_to_reg(pc_to_reg),
		.reg_dst(reg_dst)
	);

	register_file register(
		.read_out1(reg_read1),
		.read_out2(reg_read2),
		.read1(instruction[11:10]),
		.read2(instruction[9:8]),
		.write_reg(final_write_reg),
		.write_data(final_write_data),
		.reg_write(reg_write),
		.clk(clk)
	);

	alu_control alu_control(
		.instrc(instruction),
		.o_opcode(alu_control_opcode),
		.o_alu_func_code(alu_control_alufunc),
		.o_instrc_func_code(alu_control_insfunc)
	);

	alu alu(
		.alu_input_1(reg_read1),
		.alu_input_2(alu_read2),
		.opcode(alu_control_opcode),
		.func_code(alu_control_alufunc),
		.instrc_func(alu_control_insfunc),
		.bcond(bcond),
		.alu_output(alu_output)
	);

	sign_extender imm_gen(
		.input_imm(instruction[7:0]),
		.output_imm(sign_extend_imm)	
	);

	always @(*) begin
		if(!reset_n) begin
			PC = 0;
		end
	end

endmodule							  																		  