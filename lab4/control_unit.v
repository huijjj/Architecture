`include "opcodes.v"
`defind IF 3'd0;
`defind EX_1 3'd1;
`defind EX_2 3'd2;
`defind MEM 3'd3;
`defind WB 3'd4;


module control_unit(opcode, func_code, clk, mem_wirte, mem_read, reg_write, reg_dst, pc_to_reg, mem_to_reg, alu_src_A, alu_src_B, pc_store, branch_dst_store, branch, jal, jalr, PVSupdate ,alu_op, halt, wwd);
  input [3:0] opcode;
  input [5:0] func_code;
  input clk;

  //얘네들은 어떻게 해야할지 좀 더 고민해보기ㅕㅓ
  //output reg halt, wwd;

  output reg mem_write, mem_read;
  output reg reg_write;
  output reg reg_dst, pc_to_reg, mem_to_reg;
  output reg alu_src_A, alu_src_B;
  output reg pc_store, branch_dst_store;
  output reg branch, jal, jalr; 
  output reg PVSupdate;
  output reg alu_op;

  reg [2:0] cur_state;
  reg [2:0] next_state;

  initial begin
    mem_write = 0;
    mem_read = 0;
    reg_write = 0;
    reg_dst = 0;
    pc_to_reg = 0;
    mem_to_reg = 0;
    alu_src_A = 0;
    alu_src_B = 0;
    pc_store = 0;
    branch_dst_store = 0;
    branch = 0;
    jal = 0;
    jalr = 0;
    PVSupdate = 0;

    cur_state = 0;
    next_state = 0;
  end
  
  always @(posedge clk) begin
    cur_state <= next_state;
  end

  always @(*) begin
    case(opcode)
      `ALU_OP: begin
        case(func_code)
          `INST_FUNC_ADD,
          `INST_FUNC_SUB,
          `INST_FUNC_AND,
          `INST_FUNC_ORR,
          `INST_FUNC_NOT,
          `INST_FUNC_TCP,
          `INST_FUNC_SHL,
          `INST_FUNC_SHR: begin
            case(cur_state)
              `IF: begin
                mem_write = 0;
                mem_read = 0;
                reg_write = 0;
                reg_dst = 0;
                pc_to_reg = 0;
                mem_to_reg = 0;
                alu_src_A = 0;
                alu_src_B = 0;
                pc_store = 1;
                branch_dst_store = 0;
                branch = 0;
                jal = 0;
                jalr = 0;
                PVSupdate = 0;
                next_state = 1;
                alu_op = 0; //pc+1 계산
              end
              `EX_1: begin
                mem_write = 0;
                mem_read = 0;
                reg_write = 0;
                reg_dst = 0;
                pc_to_reg = 0;
                mem_to_reg = 0;
                alu_src_A = 1;
                alu_src_B = 0;
                pc_store = 0;
                branch_dst_store = 0;
                branch = 0;
                jal = 0;
                jalr = 0;
                PVSupdate = 0;
                next_state = 4;
                alu_op = 1; // op 계산
              end
              `WB: begin
                mem_write = 0;
                mem_read = 0;
                reg_write = 1;
                reg_dst = 0;
                pc_to_reg = 0;
                mem_to_reg = 0;
                alu_src_A = 1;
                alu_src_B = 0;
                pc_store = 0;
                branch_dst_store = 0;
                branch = 0;
                jal = 0;
                jalr = 0;
                PVSupdate = 1;
                next_state = 0;
                alu_op = 1; // op 계산
              end
              default: begin
                mem_write = 0;
                mem_read = 0;
                reg_write = 0;
                reg_dst = 0;
                pc_to_reg = 0;
                mem_to_reg = 0;
                alu_src_A = 0;
                alu_src_B = 0;
                pc_store = 0;
                branch_dst_store = 0;
                branch = 0;
                jal = 0;
                jalr = 0;
                PVSupdate = 0;
                next_state = 0;
                alu_op = 0;
              end
            endcase
          end
          `INST_FUNC_JPR: begin
            case(cur_state)
              `IF: begin
                mem_write = 0;
                mem_read = 0;
                reg_write = 0;
                reg_dst = 0;
                pc_to_reg = 0;
                mem_to_reg = 0;
                alu_src_A = 0;
                alu_src_B = 0;
                pc_store = 0;
                branch_dst_store = 0;
                branch = 0;
                jal = 0;
                jalr = 1;
                PVSupdate = 0;
                next_state = 1;
                alu_op = 0;
              end
              `EX_1: begin
                mem_write = 0;
                mem_read = 0;
                reg_write = 0;
                reg_dst = 0;
                pc_to_reg = 0;
                mem_to_reg = 0;
                alu_src_A = 0;
                alu_src_B = 0;
                pc_store = 0;
                branch_dst_store = 0;
                branch = 0;
                jal = 0;
                jalr = 1;
                PVSupdate = 1;
                next_state = 0;
                alu_op = 0;
              end
              default: begin
                mem_write = 0;
                mem_read = 0;
                reg_write = 0;
                reg_dst = 0;
                pc_to_reg = 0;
                mem_to_reg = 0;
                alu_src_A = 0;
                alu_src_B = 0;
                pc_store = 0;
                branch_dst_store = 0;
                branch = 0;
                jal = 0;
                jalr = 0;
                PVSupdate = 0;
                next_state = 0;
                alu_op = 0;
              end
            endcase
          end
          `INST_FUNC_JRL: begin
            case(cur_state)
              `IF: begin
                mem_write = 0;
                mem_read = 0;
                reg_write = 0;
                reg_dst = 0;
                pc_to_reg = 0;
                mem_to_reg = 0;
                alu_src_A = 0;
                alu_src_B = 0;
                pc_store = 1;
                branch_dst_store = 0;
                branch = 0;
                jal = 0;
                jalr = 0;
                PVSupdate = 0;
                next_state = 4;
                alu_op = 0; // pc+1 계산
              end
              `WB: begin
                mem_write = 0;
                mem_read = 0;
                reg_write = 1;
                reg_dst = 0;
                pc_to_reg = 1;
                mem_to_reg = 0;
                alu_src_A = 0;
                alu_src_B = 0;
                pc_store = 0;
                branch_dst_store = 0;
                branch = 0;
                jal = 0;
                jalr = 1;
                PVSupdate = 1;
                next_state = 0;
                alu_op = 0; // pc+1 계산
              end
              default: begin
                mem_write = 0;
                mem_read = 0;
                reg_write = 0;
                reg_dst = 0;
                pc_to_reg = 0;
                mem_to_reg = 0;
                alu_src_A = 0;
                alu_src_B = 0;
                pc_store = 0;
                branch_dst_store = 0;
                branch = 0;
                jal = 0;
                jalr = 0;
                PVSupdate = 0;
                next_state = 0;
                alu_op = 0;
              end
            endcase
          end
          default: begin
            mem_write = 0;
            mem_read = 0;
            reg_write = 0;
            reg_dst = 0;
            pc_to_reg = 0;
            mem_to_reg = 0;
            alu_src_A = 0;
            alu_src_B = 0;
            pc_store = 0;
            branch_dst_store = 0;
            branch = 0;
            jal = 0;
            jalr = 0;
            PVSupdate = 0;
            next_state = 0;
            alu_op = 0;
          end
        endcase
      end
      `ADI_OP,
      `ORI_OP,
      `LHI_OP: begin
        case(cur_state)
          `IF: begin
            mem_write = 0;
            mem_read = 0;
            reg_write = 0;
            reg_dst = 0;
            pc_to_reg = 0;
            mem_to_reg = 0;
            alu_src_A = 0;
            alu_src_B = 0;
            pc_store =1;
            branch_dst_store = 0;
            branch = 0;
            jal = 0;
            jalr = 0;
            PVSupdate = 0;
            next_state = 1;
            alu_op = 0; // pc+1 계산
          end
          `EX_1: begin
            mem_write = 0;
            mem_read = 0;
            reg_write = 0;
            reg_dst = 0;
            pc_to_reg = 0;
            mem_to_reg = 0;
            alu_src_A = 1;
            alu_src_B = 1;
            pc_store = 0;
            branch_dst_store = 0;
            branch = 0;
            jal = 0;
            jalr = 0;
            PVSupdate = 0;
            next_state = 4;
            alu_op = 1; // op 계산
          end
          `WB: begin
            mem_write = 0;
            mem_read = 0;
            reg_write = 1;
            reg_dst = 1;
            pc_to_reg = 0;
            mem_to_reg = 0;
            alu_src_A = 1;
            alu_src_B = 1;
            pc_store = 0;
            branch_dst_store = 0;
            branch = 0;
            jal = 0;
            jalr = 0;
            PVSupdate = 1;
            next_state = 0;
            alu_op = 1; // op 계산
          end
          default: begin
            mem_write = 0;
            mem_read = 0;
            reg_write = 0;
            reg_dst = 0;
            pc_to_reg = 0;
            mem_to_reg = 0;
            alu_src_A = 0;
            alu_src_B = 0;
            pc_store = 0;
            branch_dst_store = 0;
            branch = 0;
            jal = 0;
            jalr = 0;
            PVSupdate = 0;
            next_state = 0;
            alu_op = 0;
          end
        endcase
      end
      `LWD_OP: begin
        case(cur_state)
          `IF: begin
            mem_write = 0;
            mem_read = 0;
            reg_write = 0;
            reg_dst = 0;
            pc_to_reg = 0;
            mem_to_reg = 0;
            alu_src_A = 0;
            alu_src_B = 0;
            pc_store = 1;
            branch_dst_store = 0;
            branch = 0;
            jal = 0;
            jalr = 0;
            PVSupdate = 0;
            next_state = 1;
            alu_op = 0;
          end
          `EX_1: begin
            mem_write = 0;
            mem_read = 0;
            reg_write = 0;
            reg_dst = 0;
            pc_to_reg = 0;
            mem_to_reg = 0;
            alu_src_A = 1;
            alu_src_B = 1;
            pc_store = 0;
            branch_dst_store = 0;
            branch = 0;
            jal = 0;
            jalr = 0;
            PVSupdate = 0;
            next_state = 3;
            alu_op = 1; // op 계산
          end
          `MEM: begin
            mem_write = 0;
            mem_read = 1;
            reg_write = 0;
            reg_dst = 0;
            pc_to_reg = 0;
            mem_to_reg = 0;
            alu_src_A = 1;
            alu_src_B = 1;
            pc_store = 0;
            branch_dst_store = 0;
            branch = 0;
            jal = 0;
            jalr = 0;
            PVSupdate = 0;
            next_state = 4;
            alu_op = 1; // op 계산
          end
          `WB: begin
            mem_write = 0;
            mem_read = 0;
            reg_write = 1;
            reg_dst = 1;
            pc_to_reg = 0;
            mem_to_reg = 1;
            alu_src_A = 0;
            alu_src_B = 0;
            pc_store = 0;
            branch_dst_store = 0;
            branch = 0;
            jal = 0;
            jalr = 0;
            PVSupdate = 1;
            next_state = 0;
            alu_op = 1; // op 계산
          end
          default: begin
            mem_write = 0;
            mem_read = 0;
            reg_write = 1;
            reg_dst = 1;
            pc_to_reg = 0;
            mem_to_reg = 1;
            alu_src_A = 0;
            alu_src_B = 0;
            pc_store = 0;
            branch_dst_store = 0;
            branch = 0;
            jal = 0;
            jalr = 0;
            PVSupdate = 0;
            next_state = 0;
            alu_op = 0;
          end
      end
      `SWD_OP: begin
        case(cur_state)
          `IF: begin
            mem_write = 0;
            mem_read = 0;
            reg_write = 0;
            reg_dst = 0;
            pc_to_reg = 0;
            mem_to_reg = 0;
            alu_src_A = 0;
            alu_src_B = 0;
            pc_store = 1;
            branch_dst_store = 0;
            branch = 0;
            jal = 0;
            jalr = 0;
            PVSupdate = 0;
            next_state = 1;
            alu_op = 0;
          end
          `EX_1: begin
            mem_write = 0;
            mem_read = 0;
            reg_write = 0;
            reg_dst = 0;
            pc_to_reg = 0;
            mem_to_reg = 0;
            alu_src_A = 1;
            alu_src_B = 1;
            pc_store = 0;
            branch_dst_store = 0;
            branch = 0;
            jal = 0;
            jalr = 0;
            PVSupdate = 0;
            next_state = 3;
            alu_op = 1;
          end
          `MEM: begin
            mem_write = 1;
            mem_read = 0;
            reg_write = 0;
            reg_dst = 0;
            pc_to_reg = 0;
            mem_to_reg = 0;
            alu_src_A = 1;
            alu_src_B = 1;
            pc_store = 0;
            branch_dst_store = 0;
            branch = 0;
            jal = 0;
            jalr = 0;
            PVSupdate = 1;
            next_state = 0;
            alu_op = 1;
          end
          default: begin
            em_write = 0;
            mem_read = 0;
            reg_write = 0;
            reg_dst = 0;
            pc_to_reg = 0;
            mem_to_reg = 0;
            alu_src_A = 0;
            alu_src_B = 0;
            pc_store = 0;
            branch_dst_store = 0;
            branch = 0;
            jal = 0;
            jalr = 0;
            PVSupdate = 0;
            next_state = 0; 
            alu_op = 1;
        endcase
      end
      `BNE_OP,
      `BEQ_OP,
      `BGZ_OP,
      `BLZ_OP: begin
        case(cur_state)
          `IF: begin
            mem_write = 0;
            mem_read = 0;
            reg_write = 0;
            reg_dst = 0;
            pc_to_reg = 0;
            mem_to_reg = 0;
            alu_src_A = 0;
            alu_src_B = 0;
            pc_store = 1;
            branch_dst_store = 0;
            branch = 1;
            jal = 0;
            jalr = 0;
            PVSupdate = 0;
            next_state = 1;
            alu_op = 0;
          end
          `EX_1: begin
            mem_write = 0;
            mem_read = 0;
            reg_write = 0;
            reg_dst = 0;
            pc_to_reg = 0;
            mem_to_reg = 0;
            alu_src_A = 1;
            alu_src_B = 1;
            pc_store = 0;
            branch_dst_store = 1;
            branch = 1;
            jal = 0;
            jalr = 0;
            PVSupdate = 0;
            next_state = 2;
            alu_op = 0;
          end
          `EX_2: begin
            mem_write = 0;
            mem_read = 0;
            reg_write = 0;
            reg_dst = 0;
            pc_to_reg = 0;
            mem_to_reg = 0;
            alu_src_A = 1;
            alu_src_B = 0;
            pc_store = 0;
            branch_dst_store = 0;
            branch = 1;
            jal = 0;
            jalr = 0;
            PVSupdate = 1;
            next_state = 0;
            alu_op = 1;
          end
          default: begin
            mem_write = 0;
            mem_read = 0;
            reg_write = 0;
            reg_dst = 0;
            pc_to_reg = 0;
            mem_to_reg = 0;
            alu_src_A = 0;
            alu_src_B = 0;
            pc_store = 0;
            branch_dst_store = 0;
            branch = 0;
            jal = 0;
            jalr = 0;
            PVSupdate = 0;
            next_state = 0;
            alu_op = 0;
          end
        endcase
      `JMP_OP: begin
        case(cur_state)
          `IF: begin
            mem_write = 0;
            mem_read = 0;
            reg_write = 0;
            reg_dst = 0;
            pc_to_reg = 0;
            mem_to_reg = 0;
            alu_src_A = 0;
            alu_src_B = 0;
            pc_store = 0;
            branch_dst_store = 0;
            branch = 0;
            jal = 1;
            jalr = 0;
            PVSupdate = 0;
            next_state = 1;
            alu_op = 0;
          end
          `EX_1: begin
            mem_write = 0;
            mem_read = 0;
            reg_write = 0;
            reg_dst = 0;
            pc_to_reg = 0;
            mem_to_reg = 0;
            alu_src_A = 0;
            alu_src_B = 0;
            pc_store = 0;
            branch_dst_store = 0;
            branch = 0;
            jal = 1;
            jalr = 0;
            PVSupdate = 1;
            next_state = 0;
            alu_op = 1;
          end
          default: begin
            mem_write = 0;
            mem_read = 0;
            reg_write = 0;
            reg_dst = 0;
            pc_to_reg = 0;
            mem_to_reg = 0;
            alu_src_A = 0;
            alu_src_B = 0;
            pc_store = 0;
            branch_dst_store = 0;
            branch = 0;
            jal = 0;
            jalr = 0;
            PVSupdate = 0;
            next_state = 0; 
            alu_op = 0;
          end
        endcase
      end
      `JAL_OP: begin
        case(cur_state)
          `IF: begin
            mem_write = 0;
            mem_read = 0;
            reg_write = 0;
            reg_dst = 0;
            pc_to_reg = 0;
            mem_to_reg = 0;
            alu_src_A = 0;
            alu_src_B = 0;
            pc_store = 1;
            branch_dst_store = 0;
            branch = 0;
            jal = 1;
            jalr = 0;
            PVSupdate = 0;
            next_state = 4;
            alu_op = 0;
          end
          `WB: begin
            mem_write = 0;
            mem_read = 0;
            reg_write = 0;
            reg_dst = 0;
            pc_to_reg = 0;
            mem_to_reg = 0;
            alu_src_A = 0;
            alu_src_B = 0;
            pc_store = 0;
            branch_dst_store = 0;
            branch = 0;
            jal = 1;
            jalr = 0;
            PVSupdate = 1;
            next_state = 0;
            alu_op = 0;
          end
          default: begin
            mem_write = 0;
            mem_read = 0;
            reg_write = 0;
            reg_dst = 0;
            pc_to_reg = 0;
            mem_to_reg = 0;
            alu_src_A = 0;
            alu_src_B = 0;
            pc_store = 0;
            branch_dst_store = 0;
            branch = 0;
            jal = 0;
            jalr = 0;
            PVSupdate = 0;
            next_state = 0; 
          end
        endcase
    endcase
  end
endmodule