`include "opcodes.v" 
`define BUFFER_SIZE 256 // size of branch target buffer

module branch_predictor(clk, reset_n, PC, actual_PC, branch_PC, actual_taken, prev_state, is_bj, next_PC, predictor_state, taken);

	input clk;
	input reset_n;
	input [`WORD_SIZE-1:0] PC; // current PC
	input [`WORD_SIZE-1:0] actual_PC; // calculated target PC from branch resolve stage
	input [`WORD_SIZE-1:0] branch_PC; // PC of previous branch instruction
	input actual_taken;
	input [1:0] prev_state;
	input is_bj;

	output [`WORD_SIZE-1:0] next_PC; // predicted next PC
	output [1:0] predictor_state;
	output taken;

	//TODO: implement branch predictor
	reg [1:0] state; // state of the predictor(2-bit satuation) based on global branch history
	reg [`WORD_SIZE:0] BTB [0:`BUFFER_SIZE-1]; // branch target buffer
	// MSB of BTB entry is valid bit
	// last 8 bits of PC is used as a index for accessing BTB

	// since BTB has more entry than given instructions at testbench code
	// we do not consider any collision to make implementation simple.

	wire [7:0] index;
	assign index = PC[7:0];
	wire [7:0] branch_index;
	assign branch_index = branch_PC[7:0];
	wire valid;
	assign valid = BTB[index][`WORD_SIZE];

	// initialize
	initial begin
		// initializing predictor state
		state = 2'b00;

		// initializing target buffer, setting valid bits to zero(invalid)
		BTB[16'h00][`WORD_SIZE] = 0;
		BTB[16'h01][`WORD_SIZE] = 0;
		BTB[16'h02][`WORD_SIZE] = 0;
		BTB[16'h03][`WORD_SIZE] = 0;
		BTB[16'h04][`WORD_SIZE] = 0;
		BTB[16'h05][`WORD_SIZE] = 0;
		BTB[16'h06][`WORD_SIZE] = 0;
		BTB[16'h07][`WORD_SIZE] = 0;
		BTB[16'h08][`WORD_SIZE] = 0;
		BTB[16'h09][`WORD_SIZE] = 0;
		BTB[16'h0a][`WORD_SIZE] = 0;
		BTB[16'h0b][`WORD_SIZE] = 0;
		BTB[16'h0c][`WORD_SIZE] = 0;
		BTB[16'h0d][`WORD_SIZE] = 0;
		BTB[16'h0e][`WORD_SIZE] = 0;
		BTB[16'h0f][`WORD_SIZE] = 0;
		BTB[16'h10][`WORD_SIZE] = 0;
		BTB[16'h11][`WORD_SIZE] = 0;
		BTB[16'h12][`WORD_SIZE] = 0;
		BTB[16'h13][`WORD_SIZE] = 0;
		BTB[16'h14][`WORD_SIZE] = 0;
		BTB[16'h15][`WORD_SIZE] = 0;
		BTB[16'h16][`WORD_SIZE] = 0;
		BTB[16'h17][`WORD_SIZE] = 0;
		BTB[16'h18][`WORD_SIZE] = 0;
		BTB[16'h19][`WORD_SIZE] = 0;
		BTB[16'h1a][`WORD_SIZE] = 0;
		BTB[16'h1b][`WORD_SIZE] = 0;
		BTB[16'h1c][`WORD_SIZE] = 0;
		BTB[16'h1d][`WORD_SIZE] = 0;
		BTB[16'h1e][`WORD_SIZE] = 0;
		BTB[16'h1f][`WORD_SIZE] = 0;
		BTB[16'h20][`WORD_SIZE] = 0;
		BTB[16'h21][`WORD_SIZE] = 0;
		BTB[16'h22][`WORD_SIZE] = 0;
		BTB[16'h23][`WORD_SIZE] = 0;
		BTB[16'h24][`WORD_SIZE] = 0;
		BTB[16'h25][`WORD_SIZE] = 0;
		BTB[16'h26][`WORD_SIZE] = 0;
		BTB[16'h27][`WORD_SIZE] = 0;
		BTB[16'h28][`WORD_SIZE] = 0;
		BTB[16'h29][`WORD_SIZE] = 0;
		BTB[16'h2a][`WORD_SIZE] = 0;
		BTB[16'h2b][`WORD_SIZE] = 0;
		BTB[16'h2c][`WORD_SIZE] = 0;
		BTB[16'h2d][`WORD_SIZE] = 0;
		BTB[16'h2e][`WORD_SIZE] = 0;
		BTB[16'h2f][`WORD_SIZE] = 0;
		BTB[16'h30][`WORD_SIZE] = 0;
		BTB[16'h31][`WORD_SIZE] = 0;
		BTB[16'h32][`WORD_SIZE] = 0;
		BTB[16'h33][`WORD_SIZE] = 0;
		BTB[16'h34][`WORD_SIZE] = 0;
		BTB[16'h35][`WORD_SIZE] = 0;
		BTB[16'h36][`WORD_SIZE] = 0;
		BTB[16'h37][`WORD_SIZE] = 0;
		BTB[16'h38][`WORD_SIZE] = 0;
		BTB[16'h39][`WORD_SIZE] = 0;
		BTB[16'h3a][`WORD_SIZE] = 0;
		BTB[16'h3b][`WORD_SIZE] = 0;
		BTB[16'h3c][`WORD_SIZE] = 0;
		BTB[16'h3d][`WORD_SIZE] = 0;
		BTB[16'h3e][`WORD_SIZE] = 0;
		BTB[16'h3f][`WORD_SIZE] = 0;
		BTB[16'h40][`WORD_SIZE] = 0;
		BTB[16'h41][`WORD_SIZE] = 0;
		BTB[16'h42][`WORD_SIZE] = 0;
		BTB[16'h43][`WORD_SIZE] = 0;
		BTB[16'h44][`WORD_SIZE] = 0;
		BTB[16'h45][`WORD_SIZE] = 0;
		BTB[16'h46][`WORD_SIZE] = 0;
		BTB[16'h47][`WORD_SIZE] = 0;
		BTB[16'h48][`WORD_SIZE] = 0;
		BTB[16'h49][`WORD_SIZE] = 0;
		BTB[16'h4a][`WORD_SIZE] = 0;
		BTB[16'h4b][`WORD_SIZE] = 0;
		BTB[16'h4c][`WORD_SIZE] = 0;
		BTB[16'h4d][`WORD_SIZE] = 0;
		BTB[16'h4e][`WORD_SIZE] = 0;
		BTB[16'h4f][`WORD_SIZE] = 0;
		BTB[16'h50][`WORD_SIZE] = 0;
		BTB[16'h51][`WORD_SIZE] = 0;
		BTB[16'h52][`WORD_SIZE] = 0;
		BTB[16'h53][`WORD_SIZE] = 0;
		BTB[16'h54][`WORD_SIZE] = 0;
		BTB[16'h55][`WORD_SIZE] = 0;
		BTB[16'h56][`WORD_SIZE] = 0;
		BTB[16'h57][`WORD_SIZE] = 0;
		BTB[16'h58][`WORD_SIZE] = 0;
		BTB[16'h59][`WORD_SIZE] = 0;
		BTB[16'h5a][`WORD_SIZE] = 0;
		BTB[16'h5b][`WORD_SIZE] = 0;
		BTB[16'h5c][`WORD_SIZE] = 0;
		BTB[16'h5d][`WORD_SIZE] = 0;
		BTB[16'h5e][`WORD_SIZE] = 0;
		BTB[16'h5f][`WORD_SIZE] = 0;
		BTB[16'h60][`WORD_SIZE] = 0;
		BTB[16'h61][`WORD_SIZE] = 0;
		BTB[16'h62][`WORD_SIZE] = 0;
		BTB[16'h63][`WORD_SIZE] = 0;
		BTB[16'h64][`WORD_SIZE] = 0;
		BTB[16'h65][`WORD_SIZE] = 0;
		BTB[16'h66][`WORD_SIZE] = 0;
		BTB[16'h67][`WORD_SIZE] = 0;
		BTB[16'h68][`WORD_SIZE] = 0;
		BTB[16'h69][`WORD_SIZE] = 0;
		BTB[16'h6a][`WORD_SIZE] = 0;
		BTB[16'h6b][`WORD_SIZE] = 0;
		BTB[16'h6c][`WORD_SIZE] = 0;
		BTB[16'h6d][`WORD_SIZE] = 0;
		BTB[16'h6e][`WORD_SIZE] = 0;
		BTB[16'h6f][`WORD_SIZE] = 0;
		BTB[16'h70][`WORD_SIZE] = 0;
		BTB[16'h71][`WORD_SIZE] = 0;
		BTB[16'h72][`WORD_SIZE] = 0;
		BTB[16'h73][`WORD_SIZE] = 0;
		BTB[16'h74][`WORD_SIZE] = 0;
		BTB[16'h75][`WORD_SIZE] = 0;
		BTB[16'h76][`WORD_SIZE] = 0;
		BTB[16'h77][`WORD_SIZE] = 0;
		BTB[16'h78][`WORD_SIZE] = 0;
		BTB[16'h79][`WORD_SIZE] = 0;
		BTB[16'h7a][`WORD_SIZE] = 0;
		BTB[16'h7b][`WORD_SIZE] = 0;
		BTB[16'h7c][`WORD_SIZE] = 0;
		BTB[16'h7d][`WORD_SIZE] = 0;
		BTB[16'h7e][`WORD_SIZE] = 0;
		BTB[16'h7f][`WORD_SIZE] = 0;
		BTB[16'h80][`WORD_SIZE] = 0;
		BTB[16'h81][`WORD_SIZE] = 0;
		BTB[16'h82][`WORD_SIZE] = 0;
		BTB[16'h83][`WORD_SIZE] = 0;
		BTB[16'h84][`WORD_SIZE] = 0;
		BTB[16'h85][`WORD_SIZE] = 0;
		BTB[16'h86][`WORD_SIZE] = 0;
		BTB[16'h87][`WORD_SIZE] = 0;
		BTB[16'h88][`WORD_SIZE] = 0;
		BTB[16'h89][`WORD_SIZE] = 0;
		BTB[16'h8a][`WORD_SIZE] = 0;
		BTB[16'h8b][`WORD_SIZE] = 0;
		BTB[16'h8c][`WORD_SIZE] = 0;
		BTB[16'h8d][`WORD_SIZE] = 0;
		BTB[16'h8e][`WORD_SIZE] = 0;
		BTB[16'h8f][`WORD_SIZE] = 0;
		BTB[16'h90][`WORD_SIZE] = 0;
		BTB[16'h91][`WORD_SIZE] = 0;
		BTB[16'h92][`WORD_SIZE] = 0;
		BTB[16'h93][`WORD_SIZE] = 0;
		BTB[16'h94][`WORD_SIZE] = 0;
		BTB[16'h95][`WORD_SIZE] = 0;
		BTB[16'h96][`WORD_SIZE] = 0;
		BTB[16'h97][`WORD_SIZE] = 0;
		BTB[16'h98][`WORD_SIZE] = 0;
		BTB[16'h99][`WORD_SIZE] = 0;
		BTB[16'h9a][`WORD_SIZE] = 0;
		BTB[16'h9b][`WORD_SIZE] = 0;
		BTB[16'h9c][`WORD_SIZE] = 0;
		BTB[16'h9d][`WORD_SIZE] = 0;
		BTB[16'h9e][`WORD_SIZE] = 0;
		BTB[16'h9f][`WORD_SIZE] = 0;
		BTB[16'ha0][`WORD_SIZE] = 0;
		BTB[16'ha1][`WORD_SIZE] = 0;
		BTB[16'ha2][`WORD_SIZE] = 0;
		BTB[16'ha3][`WORD_SIZE] = 0;
		BTB[16'ha4][`WORD_SIZE] = 0;
		BTB[16'ha5][`WORD_SIZE] = 0;
		BTB[16'ha6][`WORD_SIZE] = 0;
		BTB[16'ha7][`WORD_SIZE] = 0;
		BTB[16'ha8][`WORD_SIZE] = 0;
		BTB[16'ha9][`WORD_SIZE] = 0;
		BTB[16'haa][`WORD_SIZE] = 0;
		BTB[16'hab][`WORD_SIZE] = 0;
		BTB[16'hac][`WORD_SIZE] = 0;
		BTB[16'had][`WORD_SIZE] = 0;
		BTB[16'hae][`WORD_SIZE] = 0;
		BTB[16'haf][`WORD_SIZE] = 0;
		BTB[16'hb0][`WORD_SIZE] = 0;
		BTB[16'hb1][`WORD_SIZE] = 0;
		BTB[16'hb2][`WORD_SIZE] = 0;
		BTB[16'hb3][`WORD_SIZE] = 0;
		BTB[16'hb4][`WORD_SIZE] = 0;
		BTB[16'hb5][`WORD_SIZE] = 0;
		BTB[16'hb6][`WORD_SIZE] = 0;
		BTB[16'hb7][`WORD_SIZE] = 0;
		BTB[16'hb8][`WORD_SIZE] = 0;
		BTB[16'hb9][`WORD_SIZE] = 0;
		BTB[16'hba][`WORD_SIZE] = 0;
		BTB[16'hbb][`WORD_SIZE] = 0;
		BTB[16'hbc][`WORD_SIZE] = 0;
		BTB[16'hbd][`WORD_SIZE] = 0;
		BTB[16'hbe][`WORD_SIZE] = 0;
		BTB[16'hbf][`WORD_SIZE] = 0;
		BTB[16'hc0][`WORD_SIZE] = 0;
		BTB[16'hc1][`WORD_SIZE] = 0;
		BTB[16'hc2][`WORD_SIZE] = 0;
		BTB[16'hc3][`WORD_SIZE] = 0;
		BTB[16'hc4][`WORD_SIZE] = 0;
		BTB[16'hc5][`WORD_SIZE] = 0;
		BTB[16'hc6][`WORD_SIZE] = 0;
		BTB[16'hc7][`WORD_SIZE] = 0;
		BTB[16'hc8][`WORD_SIZE] = 0;
		BTB[16'hc9][`WORD_SIZE] = 0;
		BTB[16'hca][`WORD_SIZE] = 0;
		BTB[16'hcb][`WORD_SIZE] = 0;
		BTB[16'hcc][`WORD_SIZE] = 0;
		BTB[16'hcd][`WORD_SIZE] = 0;
		BTB[16'hce][`WORD_SIZE] = 0;
		BTB[16'hcf][`WORD_SIZE] = 0;
		BTB[16'hd0][`WORD_SIZE] = 0;
		BTB[16'hd1][`WORD_SIZE] = 0;
		BTB[16'hd2][`WORD_SIZE] = 0;
		BTB[16'hd3][`WORD_SIZE] = 0;
		BTB[16'hd4][`WORD_SIZE] = 0;
		BTB[16'hd5][`WORD_SIZE] = 0;
		BTB[16'hd6][`WORD_SIZE] = 0;
		BTB[16'hd7][`WORD_SIZE] = 0;
		BTB[16'hd8][`WORD_SIZE] = 0;
		BTB[16'hd9][`WORD_SIZE] = 0;
		BTB[16'hda][`WORD_SIZE] = 0;
		BTB[16'hdb][`WORD_SIZE] = 0;
		BTB[16'hdc][`WORD_SIZE] = 0;
		BTB[16'hdd][`WORD_SIZE] = 0;
		BTB[16'hde][`WORD_SIZE] = 0;
		BTB[16'hdf][`WORD_SIZE] = 0;
		BTB[16'he0][`WORD_SIZE] = 0;
		BTB[16'he1][`WORD_SIZE] = 0;
		BTB[16'he2][`WORD_SIZE] = 0;
		BTB[16'he3][`WORD_SIZE] = 0;
		BTB[16'he4][`WORD_SIZE] = 0;
		BTB[16'he5][`WORD_SIZE] = 0;
		BTB[16'he6][`WORD_SIZE] = 0;
		BTB[16'he7][`WORD_SIZE] = 0;
		BTB[16'he8][`WORD_SIZE] = 0;
		BTB[16'he9][`WORD_SIZE] = 0;
		BTB[16'hea][`WORD_SIZE] = 0;
		BTB[16'heb][`WORD_SIZE] = 0;
		BTB[16'hec][`WORD_SIZE] = 0;
		BTB[16'hed][`WORD_SIZE] = 0;
		BTB[16'hee][`WORD_SIZE] = 0;
		BTB[16'hef][`WORD_SIZE] = 0;
		BTB[16'hf0][`WORD_SIZE] = 0;
		BTB[16'hf1][`WORD_SIZE] = 0;
		BTB[16'hf2][`WORD_SIZE] = 0;
		BTB[16'hf3][`WORD_SIZE] = 0;
		BTB[16'hf4][`WORD_SIZE] = 0;
		BTB[16'hf5][`WORD_SIZE] = 0;
		BTB[16'hf6][`WORD_SIZE] = 0;
		BTB[16'hf7][`WORD_SIZE] = 0;
		BTB[16'hf8][`WORD_SIZE] = 0;
		BTB[16'hf9][`WORD_SIZE] = 0;
		BTB[16'hfa][`WORD_SIZE] = 0;
		BTB[16'hfb][`WORD_SIZE] = 0;
		BTB[16'hfc][`WORD_SIZE] = 0;
		BTB[16'hfd][`WORD_SIZE] = 0;
		BTB[16'hfe][`WORD_SIZE] = 0;
		BTB[16'hff][`WORD_SIZE] = 0;
	end

	// reset
	always @(*) begin
		if(!reset_n) begin
			// initializing predictor state
			state = 2'b00;

			// initializing target buffer, setting valid bits to zero(invalid)
			BTB[16'h00][`WORD_SIZE] = 0;
			BTB[16'h01][`WORD_SIZE] = 0;
			BTB[16'h02][`WORD_SIZE] = 0;
			BTB[16'h03][`WORD_SIZE] = 0;
			BTB[16'h04][`WORD_SIZE] = 0;
			BTB[16'h05][`WORD_SIZE] = 0;
			BTB[16'h06][`WORD_SIZE] = 0;
			BTB[16'h07][`WORD_SIZE] = 0;
			BTB[16'h08][`WORD_SIZE] = 0;
			BTB[16'h09][`WORD_SIZE] = 0;
			BTB[16'h0a][`WORD_SIZE] = 0;
			BTB[16'h0b][`WORD_SIZE] = 0;
			BTB[16'h0c][`WORD_SIZE] = 0;
			BTB[16'h0d][`WORD_SIZE] = 0;
			BTB[16'h0e][`WORD_SIZE] = 0;
			BTB[16'h0f][`WORD_SIZE] = 0;
			BTB[16'h10][`WORD_SIZE] = 0;
			BTB[16'h11][`WORD_SIZE] = 0;
			BTB[16'h12][`WORD_SIZE] = 0;
			BTB[16'h13][`WORD_SIZE] = 0;
			BTB[16'h14][`WORD_SIZE] = 0;
			BTB[16'h15][`WORD_SIZE] = 0;
			BTB[16'h16][`WORD_SIZE] = 0;
			BTB[16'h17][`WORD_SIZE] = 0;
			BTB[16'h18][`WORD_SIZE] = 0;
			BTB[16'h19][`WORD_SIZE] = 0;
			BTB[16'h1a][`WORD_SIZE] = 0;
			BTB[16'h1b][`WORD_SIZE] = 0;
			BTB[16'h1c][`WORD_SIZE] = 0;
			BTB[16'h1d][`WORD_SIZE] = 0;
			BTB[16'h1e][`WORD_SIZE] = 0;
			BTB[16'h1f][`WORD_SIZE] = 0;
			BTB[16'h20][`WORD_SIZE] = 0;
			BTB[16'h21][`WORD_SIZE] = 0;
			BTB[16'h22][`WORD_SIZE] = 0;
			BTB[16'h23][`WORD_SIZE] = 0;
			BTB[16'h24][`WORD_SIZE] = 0;
			BTB[16'h25][`WORD_SIZE] = 0;
			BTB[16'h26][`WORD_SIZE] = 0;
			BTB[16'h27][`WORD_SIZE] = 0;
			BTB[16'h28][`WORD_SIZE] = 0;
			BTB[16'h29][`WORD_SIZE] = 0;
			BTB[16'h2a][`WORD_SIZE] = 0;
			BTB[16'h2b][`WORD_SIZE] = 0;
			BTB[16'h2c][`WORD_SIZE] = 0;
			BTB[16'h2d][`WORD_SIZE] = 0;
			BTB[16'h2e][`WORD_SIZE] = 0;
			BTB[16'h2f][`WORD_SIZE] = 0;
			BTB[16'h30][`WORD_SIZE] = 0;
			BTB[16'h31][`WORD_SIZE] = 0;
			BTB[16'h32][`WORD_SIZE] = 0;
			BTB[16'h33][`WORD_SIZE] = 0;
			BTB[16'h34][`WORD_SIZE] = 0;
			BTB[16'h35][`WORD_SIZE] = 0;
			BTB[16'h36][`WORD_SIZE] = 0;
			BTB[16'h37][`WORD_SIZE] = 0;
			BTB[16'h38][`WORD_SIZE] = 0;
			BTB[16'h39][`WORD_SIZE] = 0;
			BTB[16'h3a][`WORD_SIZE] = 0;
			BTB[16'h3b][`WORD_SIZE] = 0;
			BTB[16'h3c][`WORD_SIZE] = 0;
			BTB[16'h3d][`WORD_SIZE] = 0;
			BTB[16'h3e][`WORD_SIZE] = 0;
			BTB[16'h3f][`WORD_SIZE] = 0;
			BTB[16'h40][`WORD_SIZE] = 0;
			BTB[16'h41][`WORD_SIZE] = 0;
			BTB[16'h42][`WORD_SIZE] = 0;
			BTB[16'h43][`WORD_SIZE] = 0;
			BTB[16'h44][`WORD_SIZE] = 0;
			BTB[16'h45][`WORD_SIZE] = 0;
			BTB[16'h46][`WORD_SIZE] = 0;
			BTB[16'h47][`WORD_SIZE] = 0;
			BTB[16'h48][`WORD_SIZE] = 0;
			BTB[16'h49][`WORD_SIZE] = 0;
			BTB[16'h4a][`WORD_SIZE] = 0;
			BTB[16'h4b][`WORD_SIZE] = 0;
			BTB[16'h4c][`WORD_SIZE] = 0;
			BTB[16'h4d][`WORD_SIZE] = 0;
			BTB[16'h4e][`WORD_SIZE] = 0;
			BTB[16'h4f][`WORD_SIZE] = 0;
			BTB[16'h50][`WORD_SIZE] = 0;
			BTB[16'h51][`WORD_SIZE] = 0;
			BTB[16'h52][`WORD_SIZE] = 0;
			BTB[16'h53][`WORD_SIZE] = 0;
			BTB[16'h54][`WORD_SIZE] = 0;
			BTB[16'h55][`WORD_SIZE] = 0;
			BTB[16'h56][`WORD_SIZE] = 0;
			BTB[16'h57][`WORD_SIZE] = 0;
			BTB[16'h58][`WORD_SIZE] = 0;
			BTB[16'h59][`WORD_SIZE] = 0;
			BTB[16'h5a][`WORD_SIZE] = 0;
			BTB[16'h5b][`WORD_SIZE] = 0;
			BTB[16'h5c][`WORD_SIZE] = 0;
			BTB[16'h5d][`WORD_SIZE] = 0;
			BTB[16'h5e][`WORD_SIZE] = 0;
			BTB[16'h5f][`WORD_SIZE] = 0;
			BTB[16'h60][`WORD_SIZE] = 0;
			BTB[16'h61][`WORD_SIZE] = 0;
			BTB[16'h62][`WORD_SIZE] = 0;
			BTB[16'h63][`WORD_SIZE] = 0;
			BTB[16'h64][`WORD_SIZE] = 0;
			BTB[16'h65][`WORD_SIZE] = 0;
			BTB[16'h66][`WORD_SIZE] = 0;
			BTB[16'h67][`WORD_SIZE] = 0;
			BTB[16'h68][`WORD_SIZE] = 0;
			BTB[16'h69][`WORD_SIZE] = 0;
			BTB[16'h6a][`WORD_SIZE] = 0;
			BTB[16'h6b][`WORD_SIZE] = 0;
			BTB[16'h6c][`WORD_SIZE] = 0;
			BTB[16'h6d][`WORD_SIZE] = 0;
			BTB[16'h6e][`WORD_SIZE] = 0;
			BTB[16'h6f][`WORD_SIZE] = 0;
			BTB[16'h70][`WORD_SIZE] = 0;
			BTB[16'h71][`WORD_SIZE] = 0;
			BTB[16'h72][`WORD_SIZE] = 0;
			BTB[16'h73][`WORD_SIZE] = 0;
			BTB[16'h74][`WORD_SIZE] = 0;
			BTB[16'h75][`WORD_SIZE] = 0;
			BTB[16'h76][`WORD_SIZE] = 0;
			BTB[16'h77][`WORD_SIZE] = 0;
			BTB[16'h78][`WORD_SIZE] = 0;
			BTB[16'h79][`WORD_SIZE] = 0;
			BTB[16'h7a][`WORD_SIZE] = 0;
			BTB[16'h7b][`WORD_SIZE] = 0;
			BTB[16'h7c][`WORD_SIZE] = 0;
			BTB[16'h7d][`WORD_SIZE] = 0;
			BTB[16'h7e][`WORD_SIZE] = 0;
			BTB[16'h7f][`WORD_SIZE] = 0;
			BTB[16'h80][`WORD_SIZE] = 0;
			BTB[16'h81][`WORD_SIZE] = 0;
			BTB[16'h82][`WORD_SIZE] = 0;
			BTB[16'h83][`WORD_SIZE] = 0;
			BTB[16'h84][`WORD_SIZE] = 0;
			BTB[16'h85][`WORD_SIZE] = 0;
			BTB[16'h86][`WORD_SIZE] = 0;
			BTB[16'h87][`WORD_SIZE] = 0;
			BTB[16'h88][`WORD_SIZE] = 0;
			BTB[16'h89][`WORD_SIZE] = 0;
			BTB[16'h8a][`WORD_SIZE] = 0;
			BTB[16'h8b][`WORD_SIZE] = 0;
			BTB[16'h8c][`WORD_SIZE] = 0;
			BTB[16'h8d][`WORD_SIZE] = 0;
			BTB[16'h8e][`WORD_SIZE] = 0;
			BTB[16'h8f][`WORD_SIZE] = 0;
			BTB[16'h90][`WORD_SIZE] = 0;
			BTB[16'h91][`WORD_SIZE] = 0;
			BTB[16'h92][`WORD_SIZE] = 0;
			BTB[16'h93][`WORD_SIZE] = 0;
			BTB[16'h94][`WORD_SIZE] = 0;
			BTB[16'h95][`WORD_SIZE] = 0;
			BTB[16'h96][`WORD_SIZE] = 0;
			BTB[16'h97][`WORD_SIZE] = 0;
			BTB[16'h98][`WORD_SIZE] = 0;
			BTB[16'h99][`WORD_SIZE] = 0;
			BTB[16'h9a][`WORD_SIZE] = 0;
			BTB[16'h9b][`WORD_SIZE] = 0;
			BTB[16'h9c][`WORD_SIZE] = 0;
			BTB[16'h9d][`WORD_SIZE] = 0;
			BTB[16'h9e][`WORD_SIZE] = 0;
			BTB[16'h9f][`WORD_SIZE] = 0;
			BTB[16'ha0][`WORD_SIZE] = 0;
			BTB[16'ha1][`WORD_SIZE] = 0;
			BTB[16'ha2][`WORD_SIZE] = 0;
			BTB[16'ha3][`WORD_SIZE] = 0;
			BTB[16'ha4][`WORD_SIZE] = 0;
			BTB[16'ha5][`WORD_SIZE] = 0;
			BTB[16'ha6][`WORD_SIZE] = 0;
			BTB[16'ha7][`WORD_SIZE] = 0;
			BTB[16'ha8][`WORD_SIZE] = 0;
			BTB[16'ha9][`WORD_SIZE] = 0;
			BTB[16'haa][`WORD_SIZE] = 0;
			BTB[16'hab][`WORD_SIZE] = 0;
			BTB[16'hac][`WORD_SIZE] = 0;
			BTB[16'had][`WORD_SIZE] = 0;
			BTB[16'hae][`WORD_SIZE] = 0;
			BTB[16'haf][`WORD_SIZE] = 0;
			BTB[16'hb0][`WORD_SIZE] = 0;
			BTB[16'hb1][`WORD_SIZE] = 0;
			BTB[16'hb2][`WORD_SIZE] = 0;
			BTB[16'hb3][`WORD_SIZE] = 0;
			BTB[16'hb4][`WORD_SIZE] = 0;
			BTB[16'hb5][`WORD_SIZE] = 0;
			BTB[16'hb6][`WORD_SIZE] = 0;
			BTB[16'hb7][`WORD_SIZE] = 0;
			BTB[16'hb8][`WORD_SIZE] = 0;
			BTB[16'hb9][`WORD_SIZE] = 0;
			BTB[16'hba][`WORD_SIZE] = 0;
			BTB[16'hbb][`WORD_SIZE] = 0;
			BTB[16'hbc][`WORD_SIZE] = 0;
			BTB[16'hbd][`WORD_SIZE] = 0;
			BTB[16'hbe][`WORD_SIZE] = 0;
			BTB[16'hbf][`WORD_SIZE] = 0;
			BTB[16'hc0][`WORD_SIZE] = 0;
			BTB[16'hc1][`WORD_SIZE] = 0;
			BTB[16'hc2][`WORD_SIZE] = 0;
			BTB[16'hc3][`WORD_SIZE] = 0;
			BTB[16'hc4][`WORD_SIZE] = 0;
			BTB[16'hc5][`WORD_SIZE] = 0;
			BTB[16'hc6][`WORD_SIZE] = 0;
			BTB[16'hc7][`WORD_SIZE] = 0;
			BTB[16'hc8][`WORD_SIZE] = 0;
			BTB[16'hc9][`WORD_SIZE] = 0;
			BTB[16'hca][`WORD_SIZE] = 0;
			BTB[16'hcb][`WORD_SIZE] = 0;
			BTB[16'hcc][`WORD_SIZE] = 0;
			BTB[16'hcd][`WORD_SIZE] = 0;
			BTB[16'hce][`WORD_SIZE] = 0;
			BTB[16'hcf][`WORD_SIZE] = 0;
			BTB[16'hd0][`WORD_SIZE] = 0;
			BTB[16'hd1][`WORD_SIZE] = 0;
			BTB[16'hd2][`WORD_SIZE] = 0;
			BTB[16'hd3][`WORD_SIZE] = 0;
			BTB[16'hd4][`WORD_SIZE] = 0;
			BTB[16'hd5][`WORD_SIZE] = 0;
			BTB[16'hd6][`WORD_SIZE] = 0;
			BTB[16'hd7][`WORD_SIZE] = 0;
			BTB[16'hd8][`WORD_SIZE] = 0;
			BTB[16'hd9][`WORD_SIZE] = 0;
			BTB[16'hda][`WORD_SIZE] = 0;
			BTB[16'hdb][`WORD_SIZE] = 0;
			BTB[16'hdc][`WORD_SIZE] = 0;
			BTB[16'hdd][`WORD_SIZE] = 0;
			BTB[16'hde][`WORD_SIZE] = 0;
			BTB[16'hdf][`WORD_SIZE] = 0;
			BTB[16'he0][`WORD_SIZE] = 0;
			BTB[16'he1][`WORD_SIZE] = 0;
			BTB[16'he2][`WORD_SIZE] = 0;
			BTB[16'he3][`WORD_SIZE] = 0;
			BTB[16'he4][`WORD_SIZE] = 0;
			BTB[16'he5][`WORD_SIZE] = 0;
			BTB[16'he6][`WORD_SIZE] = 0;
			BTB[16'he7][`WORD_SIZE] = 0;
			BTB[16'he8][`WORD_SIZE] = 0;
			BTB[16'he9][`WORD_SIZE] = 0;
			BTB[16'hea][`WORD_SIZE] = 0;
			BTB[16'heb][`WORD_SIZE] = 0;
			BTB[16'hec][`WORD_SIZE] = 0;
			BTB[16'hed][`WORD_SIZE] = 0;
			BTB[16'hee][`WORD_SIZE] = 0;
			BTB[16'hef][`WORD_SIZE] = 0;
			BTB[16'hf0][`WORD_SIZE] = 0;
			BTB[16'hf1][`WORD_SIZE] = 0;
			BTB[16'hf2][`WORD_SIZE] = 0;
			BTB[16'hf3][`WORD_SIZE] = 0;
			BTB[16'hf4][`WORD_SIZE] = 0;
			BTB[16'hf5][`WORD_SIZE] = 0;
			BTB[16'hf6][`WORD_SIZE] = 0;
			BTB[16'hf7][`WORD_SIZE] = 0;
			BTB[16'hf8][`WORD_SIZE] = 0;
			BTB[16'hf9][`WORD_SIZE] = 0;
			BTB[16'hfa][`WORD_SIZE] = 0;
			BTB[16'hfb][`WORD_SIZE] = 0;
			BTB[16'hfc][`WORD_SIZE] = 0;
			BTB[16'hfd][`WORD_SIZE] = 0;
			BTB[16'hfe][`WORD_SIZE] = 0;
			BTB[16'hff][`WORD_SIZE] = 0;
		end
	end

	//update state & BTB in posedge (hysteresis)
	always @(posedge clk) begin
		if(is_bj) begin // update state & BTB if needed
			BTB[branch_index][`WORD_SIZE] <= 1;
		 	BTB[branch_index][`WORD_SIZE-1:0] <= actual_PC;
			case(prev_state)
				2'b00: begin
					if(actual_taken) begin
						state <= 2'b01;
					end
					else begin
						state <= 2'b00;
					end
				end
				2'b01: begin
					if(actual_taken) begin
						state <= 2'b11;
					end
					else begin
						state <= 2'b00;
					end
				end
				2'b10: begin
					if(actual_taken) begin
						state <= 2'b11;
					end
					else begin
						state <= 2'b00;
					end
				end
				default: begin
					if(actual_taken) begin
						state <= 2'b11;
					end
					else begin
						state <= 2'b10;
					end
				end
			endcase
		end
		else begin
			state <= state;
		end
	end

	// assigning outputs for 2 bit predictors
	wire temp;
	assign temp = (state == 2'b11 || state == 2'b10) && valid ? 1 : 0;
	assign taken = temp;
	assign next_PC = temp ? BTB[index][`WORD_SIZE-1:0] : PC + 1;

endmodule
