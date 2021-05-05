`timescale 1ns/1ns
`include "opcodes.v"
`include "register_file.v" 
`include "alu.v"
`include "control_unit.v" 
`include "branch_predictor.v"
`include "hazard.v"
`include "utils.v"
`include "forwarding_unit.v"

module cpu(clk, reset_n, read_m1, address1, data1, read_m2, write_m2, address2, data2, num_inst, output_port, is_halted,
o_instruction, o_wb_control_idex, o_wb_control_exmem, o_wb_control_memwb, o_r0, o_r1, o_r2, o_r3, o_actual_taken, o_actual_pc, o_next_pc, o_hazard, o_halt_ID);

	input clk;
	input reset_n;

	output read_m1;
	output [`WORD_SIZE-1:0] address1;
	output read_m2;
	output write_m2;
	output [`WORD_SIZE-1:0] address2;

	input [`WORD_SIZE-1:0] data1;
	inout [`WORD_SIZE-1:0] data2;

	output reg [`WORD_SIZE-1:0] num_inst;
	output reg [`WORD_SIZE-1:0] output_port;
	output is_halted;



	//test outputs
	output [`WORD_SIZE-1:0] o_instruction;
	output [5:0] o_wb_control_idex;
	output [5:0] o_wb_control_exmem;
	output [5:0] o_wb_control_memwb;
	output [`WORD_SIZE-1:0] o_r0;
	output [`WORD_SIZE-1:0] o_r1;
	output [`WORD_SIZE-1:0] o_r2;
	output [`WORD_SIZE-1:0] o_r3;
	output o_actual_taken;
	output [`WORD_SIZE-1:0] o_actual_pc;
	output [`WORD_SIZE-1:0] o_next_pc;
	output o_hazard;
	output o_halt_ID;

	//TODO: implement datapath of pipelined CPU

	// internal values
	reg [`WORD_SIZE-1:0] PC;
	reg [`WORD_SIZE-1:0] instruction_count;
	reg halt;
	reg [`WORD_SIZE-1:0] output_port_reg;

	// IF/ID registers
	reg [`WORD_SIZE-1:0] instruction_IFID;
	reg [1:0] taken_IFID;
	reg [1:0] predictor_state_IFID;
	reg [`WORD_SIZE-1:0] PC_IFID;
	

	// ID/EX registers
	reg [`WORD_SIZE-1:0] regout1_IDEX;
	reg [`WORD_SIZE-1:0] regout2_IDEX;
	reg [1:0] write_dest_IDEX;
	reg taken_IDEX;
	reg [`WORD_SIZE-1:0] imm_IDEX;
	reg [`WORD_SIZE-1:0] jump_target_IDEX;
	reg [`WORD_SIZE-1:0] branch_target_IDEX;
	reg [1:0] predictor_state_IDEX;
	reg [`WORD_SIZE-1:0] PC_IDEX;
	reg [8:0] EX_control_IDEX;
	reg [1:0] MEM_control_IDEX;
	reg [5:0] WB_control_IDEX;
	reg [1:0] rs_IDEX;
	reg [1:0] rt_IDEX;


	// EX/MEM registers
	reg [`WORD_SIZE-1:0] regout1_EXMEM;
	reg [`WORD_SIZE-1:0] regout2_EXMEM;
	reg [`WORD_SIZE-1:0] aluout_EXMEM;
	reg [1:0] write_dest_EXMEM;
	reg [`WORD_SIZE-1:0] PC_EXMEM;
	reg [1:0] MEM_control_EXMEM;
	reg [5:0] WB_control_EXMEM;


	// MEM/WB registers
	reg [`WORD_SIZE-1:0] regout1_MEMWB;
	reg [`WORD_SIZE-1:0] aluout_MEMWB;
	reg [`WORD_SIZE-1:0] data_MEMWB;
	reg [1:0] write_dest_MEMWB;
	reg [`WORD_SIZE-1:0] PC_MEMWB;
	reg [5:0] WB_control_MEMWB;

	initial begin
		output_port_reg = 0;
		PC = 0;
		instruction_count = 0;
		instruction_IFID = 0;
		taken_IFID = 0;
		predictor_state_IFID = 0;
		PC_IFID = 0;
		regout1_IDEX = 0;
		regout2_IDEX = 0;
		write_dest_IDEX = 0;
		taken_IDEX = 0;
		imm_IDEX = 0;
		jump_target_IDEX = 0;
		branch_target_IDEX = 0;
		predictor_state_IDEX = 0;
		PC_IDEX = 0;
		EX_control_IDEX = 0;
		MEM_control_IDEX = 0;
		WB_control_IDEX = 0;
		rs_IDEX = 0;
		rt_IDEX = 0;
		regout1_EXMEM = 0;
		regout2_EXMEM = 0;
		aluout_EXMEM = 0;
		write_dest_EXMEM = 0;
		PC_EXMEM = 0;
		MEM_control_EXMEM = 0;
		WB_control_EXMEM = 0;
		regout1_MEMWB = 0;
		aluout_MEMWB = 0;
		data_MEMWB = 0;
		write_dest_MEMWB = 0;
		PC_MEMWB = 0;
		WB_control_MEMWB = 0;
	end

	always @(*) begin
		if(!reset_n) begin
			output_port_reg = 0;
			PC = 0;
			instruction_count = 0;
			instruction_IFID = 0;
			taken_IFID = 0;
			predictor_state_IFID = 0;
			PC_IFID = 0;
			regout1_IDEX = 0;
			regout2_IDEX = 0;
			write_dest_IDEX = 0;
			taken_IDEX = 0;
			imm_IDEX = 0;
			jump_target_IDEX = 0;
			branch_target_IDEX = 0;
			predictor_state_IDEX = 0;
			PC_IDEX = 0;
			EX_control_IDEX = 0;
			MEM_control_IDEX = 0;
			WB_control_IDEX = 0;
			rs_IDEX = 0;
			rt_IDEX = 0;
			regout1_EXMEM = 0;
			regout2_EXMEM = 0;
			aluout_EXMEM = 0;
			write_dest_EXMEM = 0;
			PC_EXMEM = 0;
			MEM_control_EXMEM = 0;
			WB_control_EXMEM = 0;
			regout1_MEMWB = 0;
			aluout_MEMWB = 0;
			data_MEMWB = 0;
			write_dest_MEMWB = 0;
			PC_MEMWB = 0;
			WB_control_MEMWB = 0;
		end
	end
	
	// IF
	wire o_branch_predictor_taken;
	wire [1:0] o_branch_predictor_state;
	wire [`WORD_SIZE-1:0] o_branch_predictor_next_PC;
	wire [`WORD_SIZE-1:0] actual_PC;
	wire actual_taken;
	wire predict;
	branch_predictor branch_predictor(
		.clk(clk),
		.reset_n(reset_n),
		.PC(PC),
		.actual_PC(actual_PC),
		.branch_PC(PC_IDEX),
		.actual_taken(actual_taken),
		.prev_state(predictor_state_IDEX),
		.is_bj(predict),
		.next_PC(o_branch_predictor_next_PC),
		.predictor_state(o_branch_predictor_state),
		.taken(o_branch_predictor_taken)
	);

	wire wrong_prediction;
	wire [`WORD_SIZE-1:0] o_PC_source_MUX;
	mux2_1 PC_source_MUX(
		.sel(wrong_prediction),
		.i0(o_branch_predictor_next_PC),
		.i1(actual_PC),
		.o(o_PC_source_MUX)
	);

	wire o_hazard_detection_unit;
	wire [17:0] o_control_unit;
	wire [17:0] controls;

	assign read_m1 = !halt & !(o_hazard_detection_unit | controls[14]) & reset_n;
	assign address1 = PC;

	always @(posedge clk) begin
		// PC update
		if(!halt & !(o_hazard_detection_unit | controls[14]) & reset_n) begin		
			PC <= o_PC_source_MUX;
		end

		// instruction fetch
		if(EX_control_IDEX[6] | wrong_prediction | !reset_n) begin // flush
			instruction_IFID <= 16'hb000;
		end
		else if(o_hazard_detection_unit | o_control_unit[14]) begin // stall
			instruction_IFID <= instruction_IFID;
		end
		else begin
			instruction_IFID <= data1;
		end

		//updating IFID register
		taken_IFID <= o_branch_predictor_taken;
		predictor_state_IFID <= o_branch_predictor_state;
		PC_IFID <= PC;
	end

	// ID
	wire [`WORD_SIZE-1:0] o_reg_out1;
	wire [`WORD_SIZE-1:0] o_reg_out2;
	wire [`WORD_SIZE-1:0] reg_write_data;
	register_file register_file(
		.clk(clk),
		.reset_n(reset_n),
		.read1(instruction_IFID[11:10]),
		.read2(instruction_IFID[9:8]),
		.dest(write_dest_MEMWB),
		.reg_write(WB_control_MEMWB[5]),
		.write_data(reg_write_data),
		.read_out1(o_reg_out1),
		.read_out2(o_reg_out2),
		.r0(o_r0),
		.r1(o_r1),
		.r2(o_r2),
		.r3(o_r3)
	);

	hazard_detect hazard_detection_unit(
		.IFID_IR(instruction_IFID),
		.IDEX_rd(write_dest_IDEX),
		.IDEX_M_mem_read(MEM_control_IDEX[1]),
		.is_stall(o_hazard_detection_unit)
	);

	control_unit control_unit(
		.opcode(instruction_IFID[15:12]),
		.func_code(instruction_IFID[5:0]),
		.reset_n(reset_n),
		.control_signal(o_control_unit)
	);

	wire [`WORD_SIZE-1:0] o_imm_gen;
	sign_extender imm_gen(
		.in(instruction_IFID[7:0]),
		.out(o_imm_gen)
	);

	wire [`WORD_SIZE-1:0] o_make_address;
	make_address make_address(
		.pc(PC_IFID + 1'b1),
		.instruction(instruction_IFID),
		.addr(o_make_address)
	);

	wire d3_regout1;
	wire d3_regout2;
	wire [1:0] d2_d1_regout1;
	wire [1:0] d2_d1_regout2;
	forwarding_unit forwarding_unit(
		.rs_IFID(instruction_IFID[11:10]),
		.rt_IFID(instruction_IFID[9:8]),
		.rs_IDEX(rs_IDEX),
		.rt_IDEX(rt_IDEX),
		.writeReg_EXMEM(write_dest_EXMEM),
		.writeReg_MEMWB(write_dest_MEMWB),
		.reg_write_mem(WB_control_EXMEM[5]),
		.reg_write_wb(WB_control_MEMWB[5]),
		.dist3_regout1_forwarding(d3_regout1),
		.dist3_regout2_forwarding(d3_regout2),
		.dist2_or_dist1_regout1_forwarding(d2_d1_regout1),
		.dist2_or_dist1_regout2_forwarding(d2_d1_regout2)
	);

	wire [`WORD_SIZE-1:0] o_adder;
	adder adder(
		.input_1(o_imm_gen),
		.input_2(PC_IFID + 1'b1),
		.result(o_adder)
	);

	wire stall_or_flush;
	assign stall_or_flush = o_hazard_detection_unit | EX_control_IDEX[6] | wrong_prediction;

	assign controls = stall_or_flush ? 18'b0 : o_control_unit;
	wire [5:0] WB_control_temp;
	assign WB_control_temp[5] = controls[17];
	assign WB_control_temp[4:0] = controls[15:11];

	always @(posedge clk) begin
		// updating IDEX register
		regout1_IDEX <= d3_regout1 ? reg_write_data : o_reg_out1;
		regout2_IDEX <= d3_regout2 ? reg_write_data : o_reg_out2;
		write_dest_IDEX <= o_control_unit[13] ? 2 : (o_control_unit[16] ? instruction_IFID[9:8] : instruction_IFID[7:6]);
		taken_IDEX <= taken_IFID;
		imm_IDEX <= o_imm_gen;
		jump_target_IDEX <= o_make_address;
		branch_target_IDEX <= o_adder;
		predictor_state_IDEX <= predictor_state_IFID;
		PC_IDEX <= PC_IFID;
		EX_control_IDEX <= controls[8:0];
		MEM_control_IDEX <= controls[10:9];
		WB_control_IDEX <= WB_control_temp;
		rs_IDEX <= instruction_IFID[11:10];
		rt_IDEX <= instruction_IFID[9:8];
	end

	// EX
	wire [`WORD_SIZE-1:0] o_source_A_MUX;
	mux3_1 source_A_forwarding_MUX(
		.sel(d2_d1_regout1),
		.i0(regout1_IDEX),
		.i1(aluout_EXMEM),
		.i2(reg_write_data),
		.o(o_source_A_MUX)
	);

	wire [`WORD_SIZE-1:0] o_source_B_MUX;
	mux3_1 source_B_forwarding_MUX(
		.sel(d2_d1_regout2),
		.i0(regout2_IDEX),
		.i1(aluout_EXMEM),
		.i2(reg_write_data),
		.o(o_source_B_MUX)
	);

	wire [`WORD_SIZE-1:0] o_alu;
	wire overflow;
	wire bcond;
	alu alu(
		.A(o_source_A_MUX),
		.B(EX_control_IDEX[0] ? imm_IDEX : o_source_B_MUX),
		.func_code(EX_control_IDEX[3:1]),
		.branch_type(EX_control_IDEX[5:4]),
		.alu_out(o_alu),
		.overflow_flag(overflow),
		.bcond(bcond)
	);

	wire temp0;
	wire temp1;
	wire temp2;
	wire branch_condition;
	assign branch_condition = EX_control_IDEX[8] & bcond;

	assign predict = EX_control_IDEX[8] | EX_control_IDEX[7];
	assign actual_taken = branch_condition | EX_control_IDEX[7];
	assign wrong_prediction = temp2 | EX_control_IDEX[6];
	assign temp0 = taken_IDEX ^ branch_condition;
	assign temp1 = !taken_IDEX & EX_control_IDEX[7];
	assign temp2 = EX_control_IDEX[8] ? temp0: temp1;
	assign actual_PC = EX_control_IDEX[6] ? o_source_A_MUX : (EX_control_IDEX[7] ? jump_target_IDEX : (branch_condition ? branch_target_IDEX : PC_IDEX + 1'b1));

	always @(posedge clk) begin
		// updating EXMEM register
		regout1_EXMEM <= o_source_A_MUX;
		regout2_EXMEM <= o_source_B_MUX;
		aluout_EXMEM <= o_alu;
		write_dest_EXMEM <= write_dest_IDEX;
		PC_EXMEM <= PC_IDEX;
		MEM_control_EXMEM <= MEM_control_IDEX;
		WB_control_EXMEM <= WB_control_IDEX;
	end


	// MEM
	assign read_m2 = MEM_control_EXMEM[1];
	assign address2 = aluout_EXMEM;
	assign data2 = MEM_control_EXMEM[1] ? 16'bz : regout2_EXMEM;
	assign write_m2 = MEM_control_EXMEM[0];

	always @(posedge clk) begin
		// updating MEMWB registers
		regout1_MEMWB <= regout1_EXMEM;
		aluout_MEMWB <= aluout_EXMEM;
		data_MEMWB <= data2;
		write_dest_MEMWB <= write_dest_EXMEM;
		PC_MEMWB <= PC_EXMEM;
		WB_control_MEMWB <= WB_control_EXMEM;
	end

	
	// WB
	assign output_port = output_port_reg;
	assign halt = WB_control_MEMWB[3];
	assign is_halted = halt;
	assign reg_write_data = WB_control_MEMWB[2] ? PC_MEMWB + 1'b1 : (WB_control_MEMWB[0] ? data_MEMWB : aluout_MEMWB);

	always @(posedge clk) begin
		if(WB_control_MEMWB[4]) begin
			instruction_count <= instruction_count + 1;
		end
		else begin
			instruction_count <= instruction_count;
		end
		if(WB_control_MEMWB[1]) begin
			output_port_reg <= regout1_MEMWB;
		end
		else begin
			output_port_reg <= output_port_reg;
		end
	end

	assign num_inst = instruction_count;

	// assigning test outputs
	assign o_instruction = instruction_IFID;
	assign o_wb_control_idex = WB_control_IDEX;
	assign o_wb_control_exmem = WB_control_EXMEM;
	assign o_wb_control_memwb = WB_control_MEMWB;
	assign o_actual_taken = actual_taken;
	assign o_actual_pc = actual_PC;
	assign o_next_pc = o_PC_source_MUX;
	assign o_hazard = o_hazard_detection_unit;
	assign o_halt_ID = o_control_unit[14];

endmodule


