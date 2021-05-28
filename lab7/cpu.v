`timescale 1ns/1ns
`include "opcodes.v"
`include "register_file.v" 
`include "alu.v"
`include "control_unit.v" 
`include "branch_predictor.v"
`include "hazard.v"
`include "utils.v"
`include "forwarding_unit.v"
`include "cache.v"


module cpu(clk, reset_n, read_m1, address1, data1, read_m2, write_m2, address2, data2, num_inst, output_port, is_halted,
dma_interrupt, external_interrupt, dma_BR, dma_BG, dma_start, dma_length
, o_IFID_instruction, o_d_cache_hit, o_i_cache_hit, o_x0, o_x1, o_x2, o_x3
, o_set0_way0_data_0, o_set0_way1_data_0, o_set1_way0_data_0, o_set1_way1_data_0
, o_set0_way0_data_1, o_set0_way1_data_1, o_set1_way0_data_1, o_set1_way1_data_1
, o_set0_way0_data_2, o_set0_way1_data_2, o_set1_way0_data_2, o_set1_way1_data_2
, o_set0_way0_data_3, o_set0_way1_data_3, o_set1_way0_data_3, o_set1_way1_data_3
);

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

	input dma_interrupt;
	input external_interrupt;
	input dma_BR;
	output dma_BG;
	output dma_start;
	output [3:0] dma_length;

	// for test
	output [15:0] o_IFID_instruction;
	output [15:0] o_x0;
	output [15:0] o_x1;
	output [15:0] o_x2;
	output [15:0] o_x3;
	output o_d_cache_hit;
	output o_i_cache_hit;


	output [15:0] o_set0_way0_data_0;
	output [15:0] o_set0_way1_data_0;
	output [15:0] o_set1_way0_data_0;
	output [15:0] o_set1_way1_data_0;
	output [15:0] o_set0_way0_data_1;
	output [15:0] o_set0_way1_data_1;
	output [15:0] o_set1_way0_data_1;
	output [15:0] o_set1_way1_data_1;
	output [15:0] o_set0_way0_data_2;
	output [15:0] o_set0_way1_data_2;
	output [15:0] o_set1_way0_data_2;
	output [15:0] o_set1_way1_data_2;
	output [15:0] o_set0_way0_data_3;
	output [15:0] o_set0_way1_data_3;
	output [15:0] o_set1_way0_data_3;
	output [15:0] o_set1_way1_data_3;
	




	// dma register
	reg reg_dma_start;
	reg [3:0] reg_dma_length;
	reg bus_granted;

	assign dma_BG = bus_granted;
	assign dma_start = reg_dma_start;
	assign dma_length = reg_dma_length;

	// internal values
	reg [`WORD_SIZE-1:0] PC;
	reg [`WORD_SIZE-1:0] instruction_count;
	reg halt;
	reg [`WORD_SIZE-1:0] output_port_reg;
	wire i_cache_hit;

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


	reg [15:0] dma_address;
	wire [15:0] d_address2;


	// for cache hit
	wire data_cache_hit;
	wire data_cache_busy;
	wire instruction_cache_busy;
	wire [15:0] data_cache_outdata;

	initial begin
		dma_address = 16'h17;
		reg_dma_start = 0;
		reg_dma_length = 0;
		bus_granted = 0;
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
			dma_address = 16'h17;
			reg_dma_start = 0;
			reg_dma_length = 0;
			bus_granted = 0;
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
	


	// for cache connection
	wire [15:0] instruction_cache_data;

	// DMA
	always @(posedge clk) begin
		if(dma_BR) begin
			if(instruction_cache_busy & data_cache_busy & (MEM_control_EXMEM[0] | MEM_control_EXMEM[1]) & (bus_granted == 0)) begin
				bus_granted <= 0;
			end
			else begin
				bus_granted <= 1;
			end
		end
		else begin
			bus_granted <= 0;
		end
	end


	always @(posedge clk) begin
		if(external_interrupt == 1) begin
			reg_dma_start <= 1;
			reg_dma_length <= 4'b1100;
		end
		else begin
		end
		
		if(dma_interrupt == 1) begin
			reg_dma_start <= 0;
		end
		else begin
		end
	end

	assign address2 = bus_granted ? dma_address : d_address2;


	// IF
	wire o_branch_predictor_taken;
	wire [1:0] o_branch_predictor_state;
	wire [`WORD_SIZE-1:0] o_branch_predictor_next_PC;
	wire [`WORD_SIZE-1:0] actual_PC;
	wire actual_taken;
	wire predict;
	wire [`WORD_SIZE-1:0] target_PC;
	branch_predictor branch_predictor(
		.clk(clk),
		.reset_n(reset_n),
		.PC(PC),
		.actual_PC(target_PC),
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

	always @(posedge clk) begin
		// PC update
		if(!halt & !(o_hazard_detection_unit | controls[14]) & reset_n & i_cache_hit) begin	
			if(MEM_control_EXMEM[1]) begin
				if(data_cache_busy) begin
					PC <= PC; 
				end
				else begin
					if(data_cache_hit) begin
						PC <= o_PC_source_MUX;
					end
					else begin
						// stall
						PC <= PC;
					end
				end
			end
			else if(MEM_control_EXMEM[0]) begin
				if(data_cache_busy) begin
					PC <= PC;
				end
				else begin
					// go
					PC <= o_PC_source_MUX;
				end
			end
			else begin
				// go
				PC <= o_PC_source_MUX;
			end
		end

		// instruction fetch
		if(EX_control_IDEX[6] | wrong_prediction) begin // flush
			if(MEM_control_EXMEM[1]) begin
				if(data_cache_busy) begin			
					instruction_IFID <= instruction_IFID;
					PC <= PC;			
				end
				else begin
					if(data_cache_hit) begin
						instruction_IFID <= 16'hb000;
						PC <= o_PC_source_MUX;
					end
					else begin
						instruction_IFID <= instruction_IFID;
						PC <= PC; 
					end
				end
			end
			else if(MEM_control_EXMEM[0]) begin
				if(data_cache_busy) begin
					instruction_IFID <= instruction_IFID;
					PC <= PC; 
				end
				else begin				
					instruction_IFID <= 16'hb000;
					PC <= o_PC_source_MUX;								
				end
			end
			else begin
				instruction_IFID <= 16'hb000;
				PC <= o_PC_source_MUX;								
			end							
		end

		else if(o_hazard_detection_unit | o_control_unit[14]) begin // stall
			instruction_IFID <= instruction_IFID;
		end
		else if(i_cache_hit) begin
			if(MEM_control_EXMEM[1]) begin
				if(data_cache_busy) begin
					instruction_IFID <= instruction_IFID; 
				end
				else begin
					if(data_cache_hit) begin
						instruction_IFID <= instruction_cache_data;
					end
					else begin
						instruction_IFID <= instruction_IFID; 
					end
				end
			end
			else if(MEM_control_EXMEM[0]) begin
				if(data_cache_busy) begin
					instruction_IFID <= instruction_IFID; 
				end
				else begin				
					instruction_IFID <= instruction_cache_data;									
				end
			end
			else begin
				instruction_IFID <= instruction_cache_data;									
			end
		end
		else begin
			if(MEM_control_EXMEM[1]) begin
				if(data_cache_busy) begin
					instruction_IFID <= instruction_IFID; 
				end
				else begin
					if(data_cache_hit) begin
						instruction_IFID <= 16'hb000;
					end
					else begin
						instruction_IFID <= instruction_IFID; 
					end
				end
			end
			else if(MEM_control_EXMEM[0]) begin
				if(data_cache_busy) begin
					instruction_IFID <= instruction_IFID; 
				end
				else begin				
					instruction_IFID <= 16'hb000;									
				end
			end
			else begin
				instruction_IFID <= 16'hb000;									
			end
		end

		//updating IFID register
		if(MEM_control_EXMEM[1]) begin
			if(data_cache_busy) begin
				// stall
				taken_IFID <= taken_IFID;
				predictor_state_IFID <= predictor_state_IFID;
				PC_IFID <= PC_IFID;	
			end
			else begin
				if(data_cache_hit) begin
					// go
					taken_IFID <= o_branch_predictor_taken;
					predictor_state_IFID <= o_branch_predictor_state;
					PC_IFID <= PC;
				end
				else begin
					// stall
					taken_IFID <= taken_IFID;
					predictor_state_IFID <= predictor_state_IFID;
					PC_IFID <= PC_IFID;
				end
			end
		end
		else if(MEM_control_EXMEM[0]) begin
			if(data_cache_busy) begin
				// stall
				taken_IFID <= taken_IFID;
				predictor_state_IFID <= predictor_state_IFID;
				PC_IFID <= PC_IFID;	
			end
			else begin
				// go
				taken_IFID <= o_branch_predictor_taken;
				predictor_state_IFID <= o_branch_predictor_state;
				PC_IFID <= PC;
			end
		end
		else begin
			// go
			taken_IFID <= o_branch_predictor_taken;
			predictor_state_IFID <= o_branch_predictor_state;
			PC_IFID <= PC;
		end
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
		.o_x0(o_x0),
		.o_x1(o_x1),
		.o_x2(o_x2),
		.o_x3(o_x3)
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
		if(MEM_control_EXMEM[1]) begin
			if(data_cache_busy) begin
				// stall
				regout1_IDEX <= regout1_IDEX;
				regout2_IDEX <= regout2_IDEX;
				write_dest_IDEX <=write_dest_IDEX;
				taken_IDEX <= taken_IDEX;
				imm_IDEX <= imm_IDEX;
				jump_target_IDEX <= jump_target_IDEX;
				branch_target_IDEX <= branch_target_IDEX;
				predictor_state_IDEX <= predictor_state_IDEX;
				PC_IDEX <= PC_IDEX;
				EX_control_IDEX <= EX_control_IDEX;
				MEM_control_IDEX <= MEM_control_IDEX;
				WB_control_IDEX <= WB_control_IDEX;
				rs_IDEX <= rs_IDEX;
				rt_IDEX <= rt_IDEX;
			end
			else begin
				if(data_cache_hit) begin					
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
				else begin
					regout1_IDEX <= regout1_IDEX;
					regout2_IDEX <= regout2_IDEX;
					write_dest_IDEX <=write_dest_IDEX;
					taken_IDEX <= taken_IDEX;
					imm_IDEX <= imm_IDEX;
					jump_target_IDEX <= jump_target_IDEX;
					branch_target_IDEX <= branch_target_IDEX;
					predictor_state_IDEX <= predictor_state_IDEX;
					PC_IDEX <= PC_IDEX;
					EX_control_IDEX <= EX_control_IDEX;
					MEM_control_IDEX <= MEM_control_IDEX;
					WB_control_IDEX <= WB_control_IDEX;
					rs_IDEX <= rs_IDEX;
					rt_IDEX <= rt_IDEX;
				end
			end
		end
		else if(MEM_control_EXMEM[0]) begin
			if(data_cache_busy) begin
				// stall
				regout1_IDEX <= regout1_IDEX;
				regout2_IDEX <= regout2_IDEX;
				write_dest_IDEX <=write_dest_IDEX;
				taken_IDEX <= taken_IDEX;
				imm_IDEX <= imm_IDEX;
				jump_target_IDEX <= jump_target_IDEX;
				branch_target_IDEX <= branch_target_IDEX;
				predictor_state_IDEX <= predictor_state_IDEX;
				PC_IDEX <= PC_IDEX;
				EX_control_IDEX <= EX_control_IDEX;
				MEM_control_IDEX <= MEM_control_IDEX;
				WB_control_IDEX <= WB_control_IDEX;
				rs_IDEX <= rs_IDEX;
				rt_IDEX <= rt_IDEX;
			end
			else begin
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
		end
		else begin
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
	assign target_PC = EX_control_IDEX[8] ? branch_target_IDEX: jump_target_IDEX;

	always @(posedge clk) begin
		// updating EXMEM register
		if(MEM_control_EXMEM[1]) begin
			if(data_cache_busy) begin
				// stall
				regout1_EXMEM <= regout1_EXMEM;
				regout2_EXMEM <= regout2_EXMEM;
				aluout_EXMEM <= aluout_EXMEM;
				write_dest_EXMEM <= write_dest_EXMEM;
				PC_EXMEM <= PC_EXMEM;
				MEM_control_EXMEM <= MEM_control_EXMEM;
				WB_control_EXMEM <= WB_control_EXMEM;
			end
			else begin
				if(data_cache_hit) begin
					// go
					regout1_EXMEM <= o_source_A_MUX;
					regout2_EXMEM <= o_source_B_MUX;
					aluout_EXMEM <= o_alu;
					write_dest_EXMEM <= write_dest_IDEX;
					PC_EXMEM <= PC_IDEX;
					MEM_control_EXMEM <= MEM_control_IDEX;
					WB_control_EXMEM <= WB_control_IDEX;
				end
				else begin
					// stall
					regout1_EXMEM <= regout1_EXMEM;
					regout2_EXMEM <= regout2_EXMEM;
					aluout_EXMEM <= aluout_EXMEM;
					write_dest_EXMEM <= write_dest_EXMEM;
					PC_EXMEM <= PC_EXMEM;
					MEM_control_EXMEM <= MEM_control_EXMEM;
					WB_control_EXMEM <= WB_control_EXMEM;
				end
			end
		end
		else if(MEM_control_EXMEM[0]) begin
			if(data_cache_busy) begin
				// stall
				regout1_EXMEM <= regout1_EXMEM;
				regout2_EXMEM <= regout2_EXMEM;
				aluout_EXMEM <= aluout_EXMEM;
				write_dest_EXMEM <= write_dest_EXMEM;
				PC_EXMEM <= PC_EXMEM;
				MEM_control_EXMEM <= MEM_control_EXMEM;
				WB_control_EXMEM <= WB_control_EXMEM;
			end
			else begin
				// go
				regout1_EXMEM <= o_source_A_MUX;
				regout2_EXMEM <= o_source_B_MUX;
				aluout_EXMEM <= o_alu;
				write_dest_EXMEM <= write_dest_IDEX;
				PC_EXMEM <= PC_IDEX;
				MEM_control_EXMEM <= MEM_control_IDEX;
				WB_control_EXMEM <= WB_control_IDEX;
			end
		end
		else begin
			// go
			regout1_EXMEM <= o_source_A_MUX;
			regout2_EXMEM <= o_source_B_MUX;
			aluout_EXMEM <= o_alu;
			write_dest_EXMEM <= write_dest_IDEX;
			PC_EXMEM <= PC_IDEX;
			MEM_control_EXMEM <= MEM_control_IDEX;
			WB_control_EXMEM <= WB_control_IDEX;
		end
	end


	// MEM
	always @(posedge clk) begin
		// updating MEMWB registers
		if(MEM_control_EXMEM[1]) begin
			if(data_cache_busy) begin
				// stall
				regout1_MEMWB <= regout1_MEMWB;
				aluout_MEMWB <= aluout_MEMWB;
				data_MEMWB <= data_MEMWB;
				write_dest_MEMWB <= write_dest_MEMWB;
				PC_MEMWB <= PC_MEMWB;
				WB_control_MEMWB <= WB_control_MEMWB;

			end
			else begin
				if(data_cache_hit) begin
					// go
					regout1_MEMWB <= regout1_EXMEM;
					aluout_MEMWB <= aluout_EXMEM;
					data_MEMWB <= data_cache_outdata;
					write_dest_MEMWB <= write_dest_EXMEM;
					PC_MEMWB <= PC_EXMEM;
					WB_control_MEMWB <= WB_control_EXMEM;
				end
				else begin
					// stall
					regout1_MEMWB <= regout1_MEMWB;
					aluout_MEMWB <= aluout_MEMWB;
					data_MEMWB <= data_MEMWB;
					write_dest_MEMWB <= write_dest_MEMWB;
					PC_MEMWB <= PC_MEMWB;
					WB_control_MEMWB <= WB_control_MEMWB;
				end
			end
		end
		else if(MEM_control_EXMEM[0]) begin
			if(data_cache_busy) begin
				// stall
				regout1_MEMWB <= regout1_MEMWB;
				aluout_MEMWB <= aluout_MEMWB;
				data_MEMWB <= data_MEMWB;
				write_dest_MEMWB <= write_dest_MEMWB;
				PC_MEMWB <= PC_MEMWB;
				WB_control_MEMWB <= WB_control_MEMWB;
			end
			else begin
				// go
				regout1_MEMWB <= regout1_EXMEM;
				aluout_MEMWB <= aluout_EXMEM;
				data_MEMWB <= data_cache_outdata;
				write_dest_MEMWB <= write_dest_EXMEM;
				PC_MEMWB <= PC_EXMEM;
				WB_control_MEMWB <= WB_control_EXMEM;
			end
		end
		else begin
			// go
			regout1_MEMWB <= regout1_EXMEM;
			aluout_MEMWB <= aluout_EXMEM;
			data_MEMWB <= data2;
			write_dest_MEMWB <= write_dest_EXMEM;
			PC_MEMWB <= PC_EXMEM;
			WB_control_MEMWB <= WB_control_EXMEM;
		end
	end

	
	// WB
	assign output_port = output_port_reg;
	assign halt = WB_control_MEMWB[3];
	assign is_halted = halt;
	assign reg_write_data = WB_control_MEMWB[2] ? PC_MEMWB + 1'b1 : (WB_control_MEMWB[0] ? data_MEMWB : aluout_MEMWB);

	always @(posedge clk) begin
		if(WB_control_MEMWB[4]) begin
			if(MEM_control_EXMEM[1]) begin
				if(data_cache_busy) begin
					// stall
					instruction_count <= instruction_count;
				end
				else begin
					if(data_cache_hit) begin
						// go
						instruction_count <= instruction_count + 1;
					end
					else begin
						// stall
						instruction_count <= instruction_count;
					end
				end
			end
			else if(MEM_control_EXMEM[0]) begin
				if(data_cache_busy) begin
					// stall
					instruction_count <= instruction_count;
				end
				else begin
					// go
					instruction_count <= instruction_count + 1;
				end
			end
			else begin
				// go
				instruction_count <= instruction_count + 1;
			end
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

	wire write2;

	// instruction cache
	insturction_cache i_cache(
		.i_address(PC),
		.i_data(data1),
		.reset_n(reset_n),
		.instruction_count(num_inst),
		.read(!halt & !(o_hazard_detection_unit | controls[14]) & reset_n),
		.clk(clk),
		.flush(EX_control_IDEX[6] | wrong_prediction),
		.d_cache_busy(data_cache_busy),
		.BG(bus_granted),
		.address(address1),
		.o_data(instruction_cache_data),
		.hit(i_cache_hit),
		.read_m1(read_m1),
		.busy(instruction_cache_busy)
	);

	data_cache d_cache(
		.reset_n(reset_n),
		.clk(clk),
		.input_address(aluout_EXMEM),
		.read_signal(MEM_control_EXMEM[1]),
		.write_signal(MEM_control_EXMEM[0]),
		.instruction_count(num_inst),
		.BG(bus_granted),
		.hit(data_cache_hit),
		.busy(data_cache_busy),
		.data_cpu_in(regout2_EXMEM),
		.data_cpu_out(data_cache_outdata),
		.output_address(d_address2),
		.data_mem(data2),
		.read_m2(read_m2),
		.write_m2(write2),
		.o_set0_way0_data_0(o_set0_way0_data_0),
		.o_set0_way0_data_1(o_set0_way0_data_1),
		.o_set0_way0_data_2(o_set0_way0_data_2),
		.o_set0_way0_data_3(o_set0_way0_data_3),
		.o_set0_way1_data_0(o_set0_way1_data_0),
		.o_set0_way1_data_1(o_set0_way1_data_1),
		.o_set0_way1_data_2(o_set0_way1_data_2),
		.o_set0_way1_data_3(o_set0_way1_data_3),
		.o_set1_way0_data_0(o_set1_way0_data_0),
		.o_set1_way0_data_1(o_set1_way0_data_1),
		.o_set1_way0_data_2(o_set1_way0_data_2),
		.o_set1_way0_data_3(o_set1_way0_data_3),
		.o_set1_way1_data_0(o_set1_way1_data_0),
		.o_set1_way1_data_1(o_set1_way1_data_1),
		.o_set1_way1_data_2(o_set1_way1_data_2),
		.o_set1_way1_data_3(o_set1_way1_data_3)
	);

	assign write_m2 = dma_BR ? 1 : write2;

	// for test
	assign o_IFID_instruction = instruction_IFID;
	assign o_d_cache_hit = data_cache_hit;
	assign o_i_cache_hit = i_cache_hit;

endmodule