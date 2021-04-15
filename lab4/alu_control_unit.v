`include "opcodes.v"

module alu_control_unit(alu_op, funct, opcode, cycle_count, funcCode, branchType);
  input [1:0] cycle_count;
  input [5:0] funct;
  input [3:0] opcode;
  input [3:0] alu_op;

  output reg [2:0] funcCode;
  output reg [1:0] branchType;

   //TODO: implement ALU control unit
   initial begin
      funcCode = 0;
      branchType = 0;    
   end

   always @(*) begin
      case(opcode)
         `ALU_OP: begin
            case(funct)
               `INST_FUNC_ADD: begin
                  case(cycle_count)
                     2'b10: begin
                        funcCode = `FUNC_ADD;
                        branchType = 2'b00;
                     end
                     2'b01: begin
                        funcCode = `FUNC_ADD;
                        branchType = 2'b00;
                     end
                     default: begin
                        funcCode = 0;
                        branchType = 0;
                     end
                  endcase
               end
               `INST_FUNC_SUB: begin
                  case(cycle_count)
                     2'b10: begin
                        funcCode = `FUNC_ADD;
                        branchType = 2'b00;
                     end
                     2'b01: begin
                        funcCode = `FUNC_SUB;
                        branchType = 2'b11;
                     end
                     default: begin
                        funcCode = 0;
                        branchType = 0;
                     end
                  endcase
               end
               `INST_FUNC_AND: begin
                  case(cycle_count)
                     2'b10: begin
                        funcCode = `FUNC_ADD;
                        branchType = 2'b00;
                     end
                     2'b01: begin
                        funcCode = `FUNC_AND;
                        branchType = 2'b00;
                     end
                     default: begin
                        funcCode = 0;
                        branchType = 0;
                     end
                  endcase
               end
               `INST_FUNC_ORR: begin
                  case(cycle_count)
                     2'b10: begin
                        funcCode = `FUNC_ADD;
                        branchType = 2'b00;
                     end
                     2'b01: begin
                        funcCode = `FUNC_ARR;
                        branchType = 2'b00;
                     end
                     default: begin
                        funcCode = 0;
                        branchType = 0;
                     end
                  endcase
               end
               `INST_FUNC_NOT: begin
                  case(cycle_count)
                     2'b10: begin
                        funcCode = `FUNC_ADD;
                        branchType = 2'b00;
                     end
                     2'b01: begin
                        funcCode = `FUNC_NOT;
                        branchType = 2'b00;
                     end
                     default: begin
                        funcCode = 0;
                        branchType = 0;
                     end
                  endcase
               end
               `INST_FUNC_TCP: begin
                  case(cycle_count)
                     2'b10: begin
                        funcCode = `FUNC_ADD;
                        branchType = 2'b00;
                     end
                     2'b01: begin
                        funcCode = `FUNC_TCP;
                        branchType = 2'b00;
                     end
                     default: begin
                        funcCode = 0;
                        branchType = 0;
                     end
                  endcase
               end
               `INST_FUNC_SHL: begin
                  case(cycle_count)
                     2'b10: begin
                        funcCode = `FUNC_ADD;
                        branchType = 2'b00;
                     end
                     2'b01: begin
                        funcCode = `FUNC_SHL;
                        branchType = 2'b00;
                     end
                     default: begin
                        funcCode = 0;
                        branchType = 0;
                     end
                  endcase
               end
               `INST_FUNC_SHR: begin
                  case(cycle_count)
                     2'b10: begin
                        funcCode = `FUNC_ADD;
                        branchType = 2'b00;
                     end
                     2'b01: begin
                        funcCode = `FUNC_SHR;
                        branchType = 2'b00;
                     end
                     default: begin
                        funcCode = 0;
                        branchType = 0;
                     end
                  endcase
               end
               `INST_FUNC_JRL: begin
                  case(cycle_count)
                     2'b01: begin
                        funcCode = `FUNC_ADD;
                        branchType = 2'b00;
                     end
                     default: begin
                        funcCode = 0;
                        branchType = 0;
                     end
                  endcase
               end
               default: begin
                  funcCode = 0;
                  branchType = 0;
               end
            endcase
         end
         `ADI_OP: begin
            case(cycle_count)
               2'b10: begin
                  funcCode = `FUNC_ADD;
                  branchType = 2'b00;
               end
               2'b01: begin
                  funcCode = `FUNC_AND;
                  branchType = 2'b00;
               end
               default: begin
                  funcCode = 0;
                  branchType = 0;
               end
            endcase
         end
         `ORI_OP: begin
            case(cycle_count)
               2'b10: begin
                  funcCode = `FUNC_ADD;
                  branchType = 2'b00;
               end
               2'b01: begin
                  funcCode = `FUNC_ORR;
                  branchType = 2'b00;
               end
               default: begin
                  funcCode = 0;
                  branchType = 0;
               end
            endcase
         end
         `LHI_OP: begin
            case(cycle_count)
               2'b10: begin
                  funcCode = `FUNC_ADD;
                  branchType = 2'b00;
               end
               2'b01: begin
                  funcCode = `FUNC_SHL;
                  branchType = 2'b01;
               end
               default: begin
                  funcCode = 0;
                  branchType = 0;
               end
            endcase
         end
         `LWD_OP: begin
            case(cycle_count)
               2'b11: begin
                  funcCode = `FUNC_ADD;
                  branchType = 2'b00;
               end
               2'b10: begin
                  funcCode = `FUNC_ADD;
                  branchType = 2'b00;
               end
               2'b01: begin
                  funcCode = `FUNC_ADD;
                  branchType = 2'b00;
               end
               default: begin
                  funcCode = 0;
                  branchType = 0;
               end
            endcase
         end
         `SWD_OP: begin
            case(cycle_count)
               2'b10: begin
                  funcCode = `FUNC_ADD;
                  branchType = 2'b00;
               end
               2'b01: begin
                  funcCode = `FUNC_ADD;
                  branchType = 2'b00;
               end
               default: begin
                  funcCode = 0;
                  branchType = 0;
               end
            endcase
         end
         `BNE_OP: begin
            case(cycle_count)
               2'b11: begin
                  funcCode = `FUNC_ADD;
                  branchType = 2'b00;
               end
               2'b10: begin
                  funcCode = `FUNC_ADD;
                  branchType = 2'b00;
               end
               2'b01: begin
                  funcCode = `FUNC_SUB;
                  branchType = 2'b00;
               end
               default: begin
                  funcCode = 0;
                  branchType = 0;
               end
            endcase
         end
         `BEQ_OP: begin
            case(cycle_count)
               2'b11: begin
                  funcCode = `FUNC_ADD;
                  branchType = 2'b00;
               end
               2'b10: begin
                  funcCode = `FUNC_ADD;
                  branchType = 2'b00;
               end
               2'b01: begin
                  funcCode = `FUNC_SUB;
                  branchType = 2'b01;
               end
               default: begin
                  funcCode = 0;
                  branchType = 0;
               end
            endcase
         end
         `BGZ_OP: begin
            case(cycle_count)
               2'b11: begin
                  funcCode = `FUNC_ADD;
                  branchType = 2'b00;
               end
               2'b10: begin
                  funcCode = `FUNC_ADD;
                  branchType = 2'b00;
               end
               2'b01: begin
                  funcCode = `FUNC_ADD;
                  branchType = 2'b10;
               end
               default: begin
                  funcCode = 0;
                  branchType = 0;
               end
            endcase
         end
         `BLZ_OP: begin
            case(cycle_count)
               2'b11: begin
                  funcCode = `FUNC_ADD;
                  branchType = 2'b00;
               end
               2'b10: begin
                  funcCode = `FUNC_ADD;
                  branchType = 2'b00;
               end
               2'b01: begin
                  funcCode = `FUNC_ADD;
                  branchType = 2'b11;
               end
               default: begin
                  funcCode = 0;
                  branchType = 0;
               end
            endcase
         end
         `JAL_OP: begin
            case(cycle_count)
               2'b01: begin
                  funcCode = `FUNC_ADD;
                  branchType = 0;
               end
               default: begin
                  funcCode = 0;
                  branchType = 0;
               end
            endcase
         end
         default: begin
            funcCode = 0;
            branchType = 0;
         end
      endcase
   end
endmodule