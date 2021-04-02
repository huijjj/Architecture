`include "opcodes.v"

module alu_control_unit(funct, opcode, ALUOp, clk, funcCode, branchType);
  input ALUOp;
  input clk;
  input [5:0] funct;
  input [3:0] opcode;

  output reg [3:0] funcCode;
  output reg [1:0] branchType;

   //TODO: implement ALU control unit
  
endmodule