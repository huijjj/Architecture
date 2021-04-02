`include "opcodes.v"

`define NumBits 16

module alu (A, B, func_code, branch_type, C, overflow_flag, bcond);
   input [`NumBits-1:0] A; //input data A
   input [`NumBits-1:0] B; //input data B
   input [3:0] func_code; //function code for the operation
   input [1:0] branch_type; //branch type for bne, beq, bgz, blz
   output reg [`NumBits-1:0] C; //output data C
   output reg overflow_flag; 
   output reg bcond; //1 if branch condition met, else 0

   //TODO: implement ALU
   
endmodule