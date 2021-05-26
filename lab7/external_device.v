`timescale 1ns/1ns
`define WORD_SIZE 16 

// TODO: implement your external_device module
module external_device (clk, reset_n);

input clk;
input reset_n;

reg [`WORD_SIZE-1:0] num_clk; // num_clk to count cycles and trigger interrupt at appropriate cycle
reg [`WORD_SIZE-1:0] data [0:`WORD_SIZE-1]; // data to transfer


always @(*) begin
	// TODO: implement your combinational logic
end

always @(posedge clk) begin
	if(!reset_n) begin
		data[16'd0] <= 16'h0001;
		data[16'd1] <= 16'h0002;
		data[16'd2] <= 16'h0003;
		data[16'd3] <= 16'h0004;
		data[16'd4] <= 16'h0005;
		data[16'd5] <= 16'h0006;
		data[16'd6] <= 16'h0007;
		data[16'd7] <= 16'h0008;
		data[16'd8] <= 16'h0009;
		data[16'd9] <= 16'h000a;
		data[16'd10] <= 16'h000b;
		data[16'd11] <= 16'h000c;
		num_clk <= 0;
	end
	else begin
		num_clk <= num_clk+1;
		// TODO: implement your sequential logic
	end
end
endmodule
