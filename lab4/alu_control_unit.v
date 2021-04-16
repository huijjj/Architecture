`include "opcodes.v"

module alu_control_unit(alu_op, funct, opcode, funcCode, branchType);
  input [5:0] funct;
  input [3:0] opcode;
  input alu_op;

  output reg [2:0] funcCode;
  output reg [1:0] branchType;

   //TODO: implement ALU control unit
   initial begin
      funcCode = 0;
      branchType = 0;    
   end

   always @(*) begin
      if(alu_op == 0) begin
         funcCode = `FUNC_ADD;
         branchType = 2'b00;
      end
      else if(alu_op == 1) begin
         case(opcode)
            `ALU_OP: begin
               case(funct)
                  `INST_FUNC_ADD: begin
                     funcCode = `FUNC_ADD;
                     branchType = 2'b00; 
                  end
                  `INST_FUNC_SUB: begin
                     funcCode = `FUNC_SUB;
                     branchType = 2'b11;
                  end
                  `INST_FUNC_AND: begin
                     funcCode = `FUNC_AND;
                     branchType = 2'b00;
                  end
                  `INST_FUNC_ORR: begin
                     funcCode = `FUNC_ORR;
                     branchType = 2'b00;
                  end
                  `INST_FUNC_NOT: begin
                     funcCode = `FUNC_NOT;
                     branchType = 2'b00;
                  end
                  `INST_FUNC_TCP: begin
                     funcCode = `FUNC_TCP;
                     branchType = 2'b00;
                  end
                  `INST_FUNC_SHL: begin
                     funcCode = `FUNC_SHL;
                     branchType = 2'b00;
                  end
                  `INST_FUNC_SHR: begin
                     funcCode = `FUNC_SHR;
                     branchType = 2'b00;
                  end
                  default: begin
                     funcCode = 0;
                     branchType = 0;
                  end
               endcase
            end
            `ADI_OP: begin
               funcCode = `FUNC_ADD;
               branchType = 2'b00;
            end
            `ORI_OP: begin
               funcCode = `FUNC_ORR;
               branchType = 2'b00;
            end
            `LHI_OP: begin
               funcCode = `FUNC_SHL;
               branchType = 2'b01;
            end
            `LWD_OP: begin
               funcCode = `FUNC_ADD;
               branchType = 2'b00;
            end
            `SWD_OP: begin
               funcCode = `FUNC_ADD;
               branchType = 2'b00;
            end
            `BNE_OP: begin
               funcCode = `FUNC_SUB;
               branchType = 2'b00;
            end
            `BEQ_OP: begin
               funcCode = `FUNC_SUB;
               branchType = 2'b01;
            end
            `BGZ_OP: begin
               funcCode = `FUNC_ADD;
               branchType = 2'b10;
            end
            `BLZ_OP: begin
               funcCode = `FUNC_ADD;
               branchType = 2'b11;
            end
            default: begin
               funcCode = 0;
               branchType = 0;
            end
         endcase
      end
   end
endmodule