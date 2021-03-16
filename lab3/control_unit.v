`include "opcodes.v" 	   

module control_unit (instr, alu_src, reg_write, mem_read, mem_to_reg, mem_write, jp, branch);
input [`WORD_SIZE-1:0] instr;
output reg alu_src;
output reg reg_write;
output reg mem_read;
output reg mem_to_reg;
output reg mem_write;
output reg jp;
output reg branch;

endmodule