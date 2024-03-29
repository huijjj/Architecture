
`include "vending_machine_def.v"
	

module calculate_current_state(i_input_coin,i_select_item,item_price,coin_value,current_total,
input_total, output_total, return_total,current_total_nxt,wait_time,o_return_coin,o_available_item,o_output_item);


	
	input [`kNumCoins-1:0] i_input_coin,o_return_coin;
	input [`kNumItems-1:0]	i_select_item;			
	input [31:0] item_price [`kNumItems-1:0];
	input [31:0] coin_value [`kNumCoins-1:0];	
	input [`kTotalBits-1:0] current_total;
	input [31:0] wait_time;
	output reg [`kNumItems-1:0] o_available_item,o_output_item;
	output reg  [`kTotalBits-1:0] input_total, output_total, return_total,current_total_nxt;
	integer i;	

	reg [`kTotalBits-1:0] current_coin;
 	reg [`kNumItems-1:0] select_item;
	reg [`kNumItems-1:0] available_item;
	reg is_dispensed;

	initial begin
		input_total = 0;
		current_coin = 0;
		select_item = 0;
		available_item = 0;
		is_dispensed = 0;

		current_total_nxt = 0;
	end

	// Combinational logic for the next states
	always @(*) begin
		// TODO: current_total_nxt
		// You don't have to worry about concurrent activations in each input vector (or array).
		// Calculate the next current_total state.
		if(current_total == 0 && i_input_coin) begin
			current_total_nxt = 1;
		end
		else begin
		end
		
		if(current_total == 1 && i_input_coin)begin
			current_total_nxt = 1;
		end
		else begin
		end

		if(current_total ==1 && i_select_item) begin
			current_total_nxt = 3 ;
		end
		else begin
		end

		if(wait_time == 0)begin
			current_total_nxt = 0;
		end
		else begin
		end

		if(current_total == 3) begin
			current_total_nxt = 1;
			is_dispensed = 0;
		end
		else begin
		end
	end
	
	// Combinational logic for the outputs
	always @(*) begin
		// TODO: o_available_item
		// TODO: o_output_item

		// calculate available item
		if(current_total == 0) begin
			is_dispensed = 0;
			current_coin = 0;
			available_item = 0;
			o_available_item = 0;
			o_output_item = 0;
			input_total = 0;
			return_total = 0;
			select_item = 0;
		end

		if(current_total == 1) begin
			current_coin = current_coin + (i_input_coin[0]*coin_value[0]) + (i_input_coin[1]*coin_value[1]) + (i_input_coin[2]*coin_value[2]);	
			input_total = input_total+ (i_input_coin[0]*coin_value[0]) + (i_input_coin[1]*coin_value[1]) + (i_input_coin[2]*coin_value[2]);
			return_total = current_coin;
			
			if(current_coin >= item_price[0]) begin
				o_available_item[0] = 1;
				available_item[0] = 1;
			end
			else begin
				o_available_item[0] = 0;
				available_item[0] = 0;
			end
		
			if(current_coin >= item_price[1]) begin
				o_available_item[1] = 1;
				available_item[1] = 1;
			end
			else begin
				o_available_item[1] = 0;
				available_item[1] = 0;
			end

			if(current_coin >= item_price[2]) begin
				o_available_item[2] = 1;
				available_item[2] = 1;
			end
			else begin
				o_available_item[2] = 0;
				available_item[2] = 0;
			end

			if(current_coin >= item_price[3]) begin
				o_available_item[3] = 1;
				available_item[3] = 1;
			end
			else begin
				o_available_item[3] = 0;
				available_item[3] = 0;
			end	

		end

		if(current_total == 3) begin
			if(i_select_item[0] && available_item[0]) begin
				o_output_item[0] = 1;
				current_coin = current_coin - item_price[0];
				is_dispensed = 1;
			end
			else begin
				o_output_item[0] = 0;
			end
			
			if(i_select_item[1] && available_item[1]) begin
				o_output_item[1] = 1;
				current_coin = current_coin - item_price[1];
				is_dispensed = 1;
			end
			else begin
				o_output_item[1] = 0;
			end

			if(i_select_item[2] && available_item[2]) begin
				o_output_item[2] = 1;
				current_coin = current_coin - item_price[2];
				is_dispensed = 1;
			end
			else begin
				o_output_item[2] = 0;
			end

			if(i_select_item[3] && available_item[3]) begin
				o_output_item[3] = 1;
				current_coin = current_coin - item_price[3]; 
				is_dispensed = 1; 
			end
			else begin
				o_output_item[3] = 0;
			end

			return_total = current_coin;
		end
	end
endmodule 