`include "opcodes.v"

module control_unit(opcode, func_code, clk, pc_write_cond, pc_write, i_or_d, mem_read, mem_to_reg, mem_write, ir_write, pc_to_reg, pc_src, halt, wwd, new_inst, reg_write, alu_src_A, alu_src_B, alu_op);
  input [3:0] opcode;
  input [5:0] func_code;
  input clk;

  output reg pc_write_cond, pc_write, i_or_d, mem_read, mem_to_reg, mem_write, ir_write, pc_src;
  //additional control signals. pc_to_reg: to support JAL, JRL. halt: to support HLT. wwd: to support WWD. new_inst: new instruction start
  output reg pc_to_reg, halt, wwd, new_inst;
  output reg [1:0] reg_write, alu_src_A, alu_src_B;
  output reg alu_op;


   //TODO: implement control unit


endmodule
