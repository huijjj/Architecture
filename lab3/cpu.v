`include "opcodes.v" 	   

module mux (
	input [`WORD_SIZE-1:0] input0;
	input [`WORD_SIZE-1:0] input1;
	input sel;
	output [`WORD_SIZE-1:0] out;
);
	case (sel)
		0: out = input0;
		1: out = input1;
		default: out = 0;
	endcase
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

	wire reg_write;
	wire alu_src;
	wire mem_to_reg;
	wire jp;
	wire branch;


	wire [1:0] read1;
	wire [1:0] read2;
	wire [1:0] write_reg;

	wire [15:0] reg_read1;
	wire [15:0] reg_read2;


	mux memtoreg(
		.input0(),
		.input1(),
		.sel(mem_to_reg),
		.out(),
	);

	mux alusrc(
		.input0(),
		.input1(),
		.sel(alu_src),
		.out(),
	);

	mux jump(
		.input0(),
		.input1(),
		.sel(jp),
		.out(),
	);

	mux branch(
		.input0(),
		.input1(),
		.sel(branch),
		.out(),
	);


	control_unit control(
		.instr(data),
		.alu_src(alu_src),
		.reg_write(reg_write),
		.mem_read(readM),
		.mem_to_reg(mem_to_reg),
		.mem_write(writeM),
		.jp(jp),
		.branch(branch)
	);

	register_file register(
		.read_out1(reg_read1),
		.read_out2(reg_read2),
		.read1(),
		.read2(),
		.write_reg(),
		.write_data(),
		.reg_write(reg_write),
		.clk(clk)
	);

	alu alu(
		.alu_input_1(),
		.alu_input_2(),
		.func_code(),
		.alu_output()
	);

	always @(*) begin
		if(!reset_n) begin
			PC = 0;
		end
	end

endmodule							  																		  