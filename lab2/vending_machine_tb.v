// revised 04/06
// Title         : vending_machine_TB.v
// Author      : Dongup Kwon (nankdu7@postech.ac.kr)

`timescale 10ps / 10ps

`include "vending_machine_def.v"

module vending_machine_tb;

	
	
/* 
A note of caution:
To cover various design choices, I used Verilog "wait" statements in the testbench file. I think many students are not familiar with the "wait" statement. 
The "wait(condition)" statement will waits unitl the condition is true. So, your simulation will keep running if the condition is never true. 

*** Check out where the wait statements are used in the testbench file. 
*** If your simulation keeps running, stop the simulation and check out the waveform (or your own debug messages). 

*/
	

/*	
User's Action

(1) Insert100Coin(): Insert one 100 coin; It keeps the i_input_coin[0] signal high in one clock cycle.
(2) Insert500Coin(): Insert one 500 coin; It keeps the i_input_coin[1] signal high in one clock cycle.
(3) Insert1000Coin(): Insert one 1000 coin; It keeps the i_input_coin[2] signal high in one clock cycle.

(4) Select1stItem(): Select one 1st item; It keeps the i_select_item[0] high in one clock cycle.
(5) Select2ndItem(): Select one 2nd item; It keeps the i_select_item[1] high in one clock cycle.
(6) Select3rdItem(): Select one 3rd item; It keeps the i_select_item[2] high in one clock cycle.
(7) Select4thItem(): Select one 4th item; It keeps the i_select_item[3] high in one clock cycle.
==> If the vending machine does not give a item, a user (= your simulation) keeps waiting the item. If then, please stop the simulation and debug your code. 

(8) TriggerReturn(): Trigger the return button; It keeps i_trigger_return high.

*/

// integer for file
	
//Internal signals declarations:
reg clk;
reg reset_n;
reg [2:0]i_input_coin;
reg [3:0]i_select_item;
reg i_trigger_return;
wire [3:0]o_available_item;
wire [3:0]o_output_item;
wire [2:0]o_return_coin;

integer Passed;			// # of passes
integer Failed;			// # of fails
integer Current;	        // # current_total for "checking returned money"

// Unit Under Test port map
	vending_machine UUT (
		.clk(clk),
		.reset_n(reset_n),
		.i_input_coin(i_input_coin),
		.i_select_item(i_select_item),
		.i_trigger_return(i_trigger_return),
		.o_available_item(o_available_item),
		.o_output_item(o_output_item),
		.o_return_coin(o_return_coin));

// clock signal
initial clk <= 0;
always #50 clk <= ~clk; // a clock cycle: # 100, a half cycle: # 50
	
initial begin
	// Reset the device
	reset_n = 1;
	#50 reset_n = 0;
	#100 reset_n = 1;
	
	// Initialize input signals
	i_input_coin[0] = 0;
	i_input_coin[1] = 0;
	i_input_coin[2] = 0;
	i_select_item[0] = 0;
	i_select_item[1] = 0;
	i_select_item[2] = 0;
	i_select_item[3] = 0;
	i_trigger_return = 0;
	
	// Initialize variables
	Passed = 0;
	Failed = 0;
	Current = 0;

	# 200; // Wait until the output signals are stable.
	
	// == Tests start.
	InitialTest();
	Insert100CoinTest();
	Insert500CoinTest();
	Insert1000CoinTest();
	
	// After you fully implement o_output_item, run the tests.
	Select1stItemTest();
	Select2ndItemTest();
	Select3rdItemTest();
	Select4thItemTest();
	
	// After you fully implement o_return_coin, run the tests.
	WaitReturnTest();
	TriggerReturnTest();
	// == Tests end.

	$display("Passed = %0d, Failed = %0d", Passed, Failed);
	

	#100 $finish(0);
end

task InitialTest;
	begin
		AvailableItemTest("InitialTest",  4'b0);
	end
endtask

// ==
task Insert100CoinTest;
	begin
		Insert100Coin();
		Insert100Coin();
		Insert100Coin();
		Insert100Coin(); // 400
		AvailableItemTest("Insert100CoinTest-1", 4'b0001);
		Insert100Coin(); // 500
		AvailableItemTest("Insert100CoinTest-2", 4'b0011);
	end
endtask

task Insert500CoinTest;
	begin
		reset_n = 1;
		#100 reset_n = 0;
		#100 reset_n = 1;
		Current = 0;
		Insert500Coin(); // 500
		AvailableItemTest("Insert500CoinTest-1", 4'b0011);
		Insert500Coin(); // 1000
		AvailableItemTest("Insert500CoinTest-2", 4'b0111);
		Insert500Coin();
		Insert500Coin(); // 2000
		AvailableItemTest("Insert500CoinTest-3", 4'b1111);
	end
endtask

task Insert1000CoinTest;
	begin
		reset_n = 1;
		#100 reset_n = 0;
		#100 reset_n = 1;
		Current = 0;
		Insert1000Coin(); // 1000
		AvailableItemTest("Insert1000CoinTest-1", 4'b0111);
		Insert1000Coin(); // 2000
		AvailableItemTest("Insert1000CoinTest-2", 4'b1111);
	end
endtask

task Select1stItemTest;
	begin
		Insert1000Coin(); // 3000
		Select1stItem();
		Select1stItem(); // 2200
		AvailableItemTest("Select1stItemTest-1", 4'b1111);
		Select1stItem(); // 1800
		AvailableItemTest("Select1stItemTest-2", 4'b0111);
		Select1stItem();
		Select1stItem();
		Select1stItem(); // 600
		AvailableItemTest("Select1stItemTest-3", 4'b0011);
		Select1stItem(); // 200
		AvailableItemTest("Select1stItemTest-4", 4'b0000);
	end
endtask

task Select2ndItemTest;
	begin
		Insert1000Coin();
		Insert1000Coin();
		Insert1000Coin(); // 3200
		Select2ndItem();
		Select2ndItem(); // 2200
		AvailableItemTest("Select2ndItemTest-1", 4'b1111);
		Select2ndItem(); // 1700
		AvailableItemTest("Select2ndItemTest-2", 4'b0111);
		Select2ndItem();
		Select2ndItem(); // 700
		AvailableItemTest("Select2ndItemTest-3", 4'b0011);
		Select2ndItem(); // 200
		AvailableItemTest("Select2ndItemTest-4", 4'b0000);
	end
endtask

task Select3rdItemTest;
	begin
		Insert100Coin();
		Insert100Coin();
		Insert1000Coin();
		Insert1000Coin();
		Insert1000Coin(); // 3400
		Select3rdItem();	// 2400
		AvailableItemTest("Select3rdItemTest-1", 4'b1111);
		Select3rdItem();	// 1400
		AvailableItemTest("Select3rdItemTest-2", 4'b0111);
		Select3rdItem();	// 400
		AvailableItemTest("Select3rdItemTest-3", 4'b0001);
	end
endtask

task Select4thItemTest;
	begin
		Insert1000Coin();
		Insert1000Coin();
		Insert1000Coin(); // 3400
		Select4thItem(); // 1400
		AvailableItemTest("Select4thItemTest-1", 4'b0111);
		Insert1000Coin(); // 2400
		Select4thItem(); // 400
		AvailableItemTest("Select4thItemTest-2", 4'b0001);
	end
endtask

task WaitReturnTest;
	begin
		Insert100Coin();
		Insert100Coin();
		Insert100Coin();
		Insert100Coin();
		Insert500Coin();
		Insert500Coin();
		Insert1000Coin(); // 2800
		ReturnTest("WaitReturnTest");
	end
endtask

task TriggerReturnTest;
	begin
		Insert100Coin();
		Insert100Coin();
		Insert100Coin();
		Insert500Coin();
		Insert500Coin();
		Insert500Coin();
		Insert1000Coin(); 
		Insert1000Coin();
		Insert1000Coin();
		TriggerReturn(); // 4800
		ReturnTest("TriggerReturnTest");
	end
endtask

// ==
task AvailableItemTest; 
	input [32 * 8 : 0] Testname;
	input [3:0] o_available_item_expected;

	begin
		$display("TEST %s :", Testname);
		// $display("%d", Current);
		# 200; // Wait until the o_available_item signal is stable.
		if (o_available_item == o_available_item_expected)
			begin
				$display("PASSED");
				Passed = Passed + 1;
			end
		else
			begin
				$display("FAILED");
				$display("o_available_item = %0b (Ans: %0b)", o_available_item, o_available_item_expected);
				Failed = Failed + 1;
			end	
	end
endtask

task ReturnTest; 	 
	input [32 * 8 : 0] Testname;

	begin
		$display("TEST %s :", Testname);
	
		while (Current > 0) begin
			 $display("Current %d", Current);
			 $display("o_return_coin %b", o_return_coin);
			 $display("o_return_coin %z", o_return_coin);
			 $display("o_return_coin %d", o_return_coin);

			wait (o_return_coin);	// ** Wait until the o_return_coin is true
			# 50; // To safely fetch the o_return_coin signal, add a half cycle here.
			if (o_return_coin[0]) Current = Current - 'd100;
			if (o_return_coin[1]) Current = Current - 'd500;
			if (o_return_coin[2]) Current = Current - 'd1000;
			# 50;
		end
		
		if (Current == 0)
			begin
				$display("PASSED");
			    Passed = Passed + 1;
			end
		else
			begin
				$display("FAILED");
				$display("%d", Current);
				Failed = Failed + 1;
			end
	end
endtask

// User's Action
task Insert100Coin;
	begin
		# 100 i_input_coin[0] = 1;
		# 100 i_input_coin[0] = 0;	// After one cycle, deactivate the signal
		Current = Current + 'd100;
	end
endtask

task Insert500Coin;
	begin
		# 100 i_input_coin[1] = 1;
		# 100 i_input_coin[1] = 0;	// After one cycle, deactivate the signal
		Current = Current + 'd500;
	end
endtask

task Insert1000Coin;
	begin
		# 100 i_input_coin[2] = 1;
		# 100 i_input_coin[2] = 0;	// After one cycle, deactivate the signal
		Current = Current + 'd1000;
	end
endtask

task Select1stItem;
	begin
		# 100 i_select_item[0] = 1;
		wait (o_output_item[0]); 	// ** Wait until the o_output_item[0] is true
		ItemCollect();
		# 100 i_select_item[0] = 0;	// After one cycle, deactivate the signal
	end
endtask

task Select2ndItem;
	begin
		# 100 i_select_item[1] = 1;
		wait (o_output_item[1]); 	// ** Wait until the o_output_item[1] is true
		ItemCollect();
		# 100 i_select_item[1] = 0;	// After one cycle, deactivate the signal
	end
endtask

task Select3rdItem;
	begin
		# 100 i_select_item[2] = 1;
		wait (o_output_item[2]);	// ** Wait until the o_output_item[2] is true
		ItemCollect();
		# 100 i_select_item[2] = 0;	// After one cycle, deactivate the signal
	end
endtask

task Select4thItem;
	begin
		# 100 i_select_item[3] = 1;
		wait (o_output_item[3]);	// ** Wait until the o_output_item[3] is true
		ItemCollect();
		# 100 i_select_item[3] = 0; 	// After one cycle, deactivate the signal
	end
endtask

task ItemCollect;
	begin
		if(o_output_item[0]) Current = Current - 'd400;
		if(o_output_item[1]) Current = Current - 'd500;
		if(o_output_item[2]) Current = Current - 'd1000;
		if(o_output_item[3]) Current = Current - 'd2000;
	end
endtask

task TriggerReturn;
	begin
		# 100 i_trigger_return = 1;
	end
endtask

endmodule
