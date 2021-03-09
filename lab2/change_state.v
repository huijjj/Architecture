`include "vending_machine_def.v"


module change_state(clk,reset_n,current_total_nxt,current_total);

	input clk;
	input reset_n;
	input [`kTotalBits-1:0] current_total_nxt;
	output reg [`kTotalBits-1:0] current_total;
	
	// Sequential circuit to reset or update the states
	always @(posedge clk ) begin
		if (!reset_n) begin
			// TODO: reset all states.
		end
		else begin
			// TODO: update all states.
		end
	end
endmodule 