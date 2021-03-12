`include "vending_machine_def.v"

	

module check_time_and_coin(i_input_coin,i_select_item,clk,reset_n,wait_time,o_return_coin);
	input clk;
	input reset_n;
	input [`kNumCoins-1:0] i_input_coin;
	input [`kNumItems-1:0] i_select_item;

	output reg  [`kNumCoins-1:0] o_return_coin;
	output reg [31:0] wait_time;


	reg [31 : 0] _wait_time;
	reg [`kNumCoins-1 : 0] return_coin;

	// initiate values
	initial begin
		// TODO: initiate values
		_wait_time = `kWaitTime;
		return_coin = 0;
	end


	// update coin return time
	always @(i_input_coin, i_select_item) begin
		// TODO: update coin return time		
		_wait_time = `kWaitTime;
	end

	always @(*) begin
		// TODO: o_return_coin
		wait_time = _wait_time;
		return_coin = (i_input_coin & return_coin);
	end



	always @(posedge clk ) begin
		if (!reset_n) begin
		// TODO: reset all states.
			_wait_time <= `kWaitTime;
			return_coin <= 0;
			wait_time <= `kWaitTime;
			o_return_coin <= 0;
		end

		else begin
		// TODO: update all states.
			_wait_time <= (_wait_time - 1);
			o_return_coin <= return_coin;
		end
	end
endmodule 

// i_input_coin 혹은 i_select_item이 입력되면 time을 초기화함
// 