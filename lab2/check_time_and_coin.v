`include "vending_machine_def.v"

	

module check_time_and_coin(i_input_coin,i_select_item,clk,reset_n,wait_time,o_return_coin, i_trigger_return);
	input clk;
	input reset_n;
	input [`kNumCoins-1:0] i_input_coin;
	input [`kNumItems-1:0] i_select_item;
	input i_trigger_return;

	output reg  [`kNumCoins-1:0] o_return_coin;
	output reg [31:0] wait_time;


	reg [31 : 0] _wait_time;
	reg [30 : 0] remain;

	// initiate values
	initial begin
		// TODO: initiate values
		_wait_time = `kWaitTime;
		remain = 0;
	end


	// update coin return time
	always @(i_input_coin, i_select_item) begin
		// TODO: update coin return time		
		_wait_time = `kWaitTime;

		if(i_input_coin[0]) begin
			remain = remain + 100;
		end

		if(i_input_coin[1]) begin
			remain = remain + 500;
		end
		
		if(i_input_coin[2]) begin
			remain = remain + 1000;
		end

		if(i_select_item[0]) begin
			if(remain >= 400) begin
				remain = remain - 400;
			end
		end

		if(i_select_item[1]) begin
			if(remain >= 500) begin
				remain = remain - 500;
			end
		end

		if(i_select_item[2]) begin
			if(remain >= 1000) begin
				remain = remain - 1000;
			end
		end

		if(i_select_item[3]) begin
			if(remain >= 2000) begin
				remain = remain - 2000;
			end
		end
	end


	always @(*) begin
		// TODO: o_return_coin
		if(i_trigger_return)
		begin
			_wait_time = 0;
		end
		wait_time = _wait_time;
		if(!_wait_time)
		begin
			if(remain >= 1600)
			begin
				remain = remain - 1600;
				o_return_coin = 3'b111;
			end
			else if(remain >= 1500)
			begin
				remain = remain - 1500;
				o_return_coin = 3'b110;
			end
			else if(remain >= 1100)
			begin
				remain = remain - 1100;
				o_return_coin = 3'b101;
			end
			else if(remain >= 1000)
			begin
				remain = remain - 1000;
				o_return_coin = 3'b100;
			end
			else if(remain >= 600)
			begin
				remain = remain - 600;
				o_return_coin = 3'b011;
			end
			else if(remain >= 500)
			begin
				remain = remain - 500;
				o_return_coin = 3'b010;
			end
			else if(remain >= 100)
			begin
				remain = remain - 100;
				o_return_coin = 3'b001;
			end
			else
			begin
				o_return_coin = 3'b000;
			end	
		end
	end

	always @(posedge clk ) begin
		if (!reset_n) begin
		// TODO: reset all states.
			_wait_time <= `kWaitTime;
			remain <= 0;	
		end

		else begin
		// TODO: update all states.
			if(_wait_time) begin
				_wait_time <= (_wait_time - 1);
			end
			else begin
				_wait_time <= _wait_time;
			end
		end
	end
endmodule 

// i_input_coin 혹은 i_select_item이 입력되면 time을 초기화함
// 