`timescale 1ns/100ps																											  

`define PERIOD1 100						// timing for single cycles
`define READ_DELAY 30   					// delay before memory data is ready
`define WRITE_DELAY 30  					// delay in writing to memory
`define STABLE_TIME 10  					// time data is stable after end-of-read
`define MEMORY_SIZE 256	// size of memory is 2^8 words (reduced size)
`define WORD_SIZE 16    					//   instead of 2^16 words to reduce memory

module tb_cpu();						  
  	wire readM;										// read from memory									
  	wire writeM;										// write to memory
  	wire [`WORD_SIZE-1:0] address;				// current address for data input or output
  	wire [`WORD_SIZE-1:0] data;    				// data being input or output	
  	reg ackOutput;						// acknowledge of data receipt from output port
  	reg inputReady; 					// indicates that data is ready from the input port
  	reg reset_n;    									// active-low RESET signal
  	reg clk;        										// clock signal																																  
  												
  	cpu UUT (readM, writeM, address, data, ackOutput, inputReady, reset_n, clk);																				   
  																  														  										    
  	always #(`PERIOD1/2)clk = ~clk;  			// generates a clock (period = `PERIOD1)
			  
  	initial begin
    	clk = 0;
		ackOutput = 0;
		inputReady = 0;								 		
	
		// generate a LOW pulse for reset_n
    	reset_n = 1;       
    	#(`PERIOD1/4) reset_n = 0;
    	#`PERIOD1 reset_n = 1;
  	end
																																							 
  	reg [`WORD_SIZE-1:0] memory [0:`MEMORY_SIZE-1];
  	reg [`WORD_SIZE-1:0] loadedData;  			// data loaded during a memory read  
																						  
  	assign data = (readM || inputReady) ? loadedData : `WORD_SIZE'bz;
  	always begin
    	loadedData = `WORD_SIZE'bz;
    	#`PERIOD1;
		forever begin
      		wait (readM == 1 || writeM == 1);
	  		if (readM == 1) begin
      			#`READ_DELAY;
      			loadedData = memory[address];  
	  			inputReady = 1;		  
      			#(`STABLE_TIME);			
	  			inputReady = 0;
      			loadedData = `WORD_SIZE'bz;	 
	  		end else if (writeM == 1) begin
				memory[address] = data;
				#`WRITE_DELAY;
				ackOutput = 1;
				#(`STABLE_TIME);								  
				ackOutput = 0;							
	  		end
    	end  // of forever loop
  	end  // of always block for memory read
  
  	// store programs and data in the memory
	initial begin
    	#`PERIOD1;   // delay for a while
		memory[0]  = 16'h530a;	//	0: ORI $3, $0, 10
		memory[1]  = 16'h421e;	//	1: ADI $2, $0, 30
 		memory[2]  = 16'h8b02;	//	2: SWD $3, $2, 2
		memory[3]  = 16'h7320;	//	3: LWD $3, $0, 32
		memory[4]  = 16'hf300;	//	4: ADD $0, $0, $3
		memory[5]  = 16'hfcc7;	//	5: SHR $3, $3
		memory[6]  = 16'h8b00;	//	6: SWD $3, $2, 0
		memory[7]  = 16'h8801;	//	7: SWD $0, $2, 1
		memory[8]  = 16'h07fb;	//	8: BNE $1, $3, -5
		memory[9]  = 16'h900e;	//	9: JMP 14
		memory[10] = 16'hf600;	//	10: ADD $0, $1, $2
		memory[11] = 16'hfb41;	//	11: SUB $1, $2, $3
		memory[12] = 16'hf183;	//	12: ORR $2, $0, $1
		memory[13] = 16'hf404;	//	13: NOT $0, $1
		memory[14] = 16'h8803;	//	14: SWD $0, $2, 3
		memory[15] = 16'hf881;	//	15: SUB $2, $2, $0
		memory[16] = 16'h8210;	//	16: SWD $2, $0, 16
		memory[17] = 16'hf845;	//	17: TCP $1, $2
		memory[18] = 16'hf4c7;	//	18: SHR $3, $1
		memory[19] = 16'h7914;	//	19: LWD $1, $2, 20
		memory[20] = 16'hfb43;	//	20: ORR $1, $2, $3
		memory[21] = 16'hfcc4;	//	21: NOT $3, $3
		memory[22] = 16'hf806;	//	22: SHL $0, $2
		memory[23] = 16'hf740;	//	23: ADD $1, $1, $3
		memory[24] = 16'h63ff;	//	24: LHI $3, 255
		memory[25] = 16'hf7c1;	//	25: SUB $3, $1, $3
		memory[26] = 16'h8006;	//	26: SWD $0, $0, 6
		memory[27] = 16'h8107;	//	27: SWD $1, $0, 7
		memory[28] = 16'h8208;	//	28: SWD $2, $0, 8
		memory[29] = 16'h8309;	//	29: SWD $3, $0, 9
		memory[30] = 0;
		memory[31] = 0;
		memory[32] = 0;
		memory[33] = 0;
		memory[34] = 0;
		memory[35] = 0;
 	end
  
 	// Test cpu behavior 									
	integer Passed;
	integer Failed;
 	reg [`WORD_SIZE-1:0] num_cycle;	// number of instruction during execution	  
 	initial begin
		 Passed = 0;
		 Failed = 0;
		 num_cycle = 0;	  
	end
 	always @(posedge clk) begin
		if (!reset_n) num_cycle = 0;
		else num_cycle = num_cycle + 1;
		if (num_cycle > 45) begin
			$display("Passed = %0d, Failed = %0d", Passed, Failed);	
			$finish();
		end
 	end				  
  	
  	task Test;						  
	  	input [`WORD_SIZE-1:0] num_cycle_;
	  	input [`WORD_SIZE-1:0] target_address_;
	  	input [`WORD_SIZE-1:0] expected_value_;
		  					
		begin		   
		$display("#%d :", num_cycle_);			
		if (memory[target_address_] == expected_value_)
			begin								   
				$display("PASSED");
				Passed = Passed + 1;
			end
		else   
			begin											  
				$display("FAILED");
				$display("num_cycle = %d, memory[%0d] = %d (Ans : %d)", num_cycle_, target_address_, memory[target_address_], expected_value_);
				Failed = Failed + 1;
			end
		end
	endtask
  
  always @(posedge clk) begin
	 #(`PERIOD1)
     case (num_cycle)
        3: Test(num_cycle, 32, 10);	 
        7: Test(num_cycle, 30, 5);		 
        8: Test(num_cycle, 31, 10);		 
        12: Test(num_cycle, 30, 2);		 
        13: Test(num_cycle, 31, 15);	 
        17: Test(num_cycle, 30, 1);	  
        18: Test(num_cycle, 31, 17);  
        22: Test(num_cycle, 30, 0);	   
        23: Test(num_cycle, 31, 18);   
        26: Test(num_cycle, 33, 18);   
        28: Test(num_cycle, 34, 12);   
        38: Test(num_cycle, 30, 24);   
        39: Test(num_cycle, 31, 3);	    
        40: Test(num_cycle, 32, 12);    
        41: Test(num_cycle, 33, 259);
     endcase
  end
endmodule 
