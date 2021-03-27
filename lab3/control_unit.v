`include "opcodes.v" 	   

module control_unit (instr, alu_src, reg_write, mem_read, mem_to_reg, mem_write, branch, jal, jalr, pc_to_reg, reg_dst);
input [`WORD_SIZE-1:0] instr;
output reg alu_src;
output reg reg_write;
output reg mem_read;
output reg mem_to_reg;
output reg mem_write;
output reg branch;
output reg jal;
output reg jalr;
output reg pc_to_reg;
output reg reg_dst;

reg [3:0] opcode;
reg [5:0] funcode;

always @(*) begin
    opcode = instr[15:12];
    funcode = instr[5:0];
    case(opcode)
        `ALU_OP: begin
            case(funcode)
                `INST_FUNC_JPR: begin
                    alu_src = 0;
                    reg_write = 0;
                    mem_read = 0;
                    mem_to_reg = 0;
                    mem_write = 0;
                    branch = 0;
                    jal = 0;
                    jalr = 1;
                    pc_to_reg = 0;
                    reg_dst = 0;
                end
                `INST_FUNC_JRL: begin
                    alu_src = 0;
                    reg_write = 1;
                    mem_read = 0;
                    mem_to_reg = 0;
                    mem_write = 0;
                    branch = 0;
                    jal = 0;
                    jalr = 1;
                    pc_to_reg = 1;
                    reg_dst = 0;
                end
                default: begin
                    alu_src = 0;
                    reg_write = 1;
                    mem_read = 0;
                    mem_to_reg = 0;
                    mem_write = 0;
                    branch = 0;
                    jal = 0;
                    jalr = 0;
                    pc_to_reg = 0;
                    reg_dst = 0;
                end
            endcase
        end
        `ADI_OP: begin
            alu_src = 1;
            reg_write = 1;
            mem_read = 0;
            mem_to_reg = 0;
            mem_write = 0;
            branch = 0;
            jal = 0;
            jalr = 0;
            pc_to_reg = 0;
            reg_dst = 1;
        end
        `ORI_OP: begin
            alu_src = 1;
            reg_write = 1;
            mem_read = 0;
            mem_to_reg = 0;
            mem_write = 0;
            branch = 0;
            jal = 0;
            jalr = 0;
            pc_to_reg = 0;
            reg_dst = 1;
        end
        `LHI_OP: begin
            alu_src = 1;
            reg_write = 1;
            mem_read = 0;
            mem_to_reg = 0;
            mem_write = 0;
            branch = 0;
            jal = 0;
            jalr = 0;
            pc_to_reg = 0;
            reg_dst = 1;
        end
        `LWD_OP: begin
            alu_src = 1;
            reg_write = 1;
            mem_read = 1;
            mem_to_reg = 1;
            mem_write = 0;
            branch = 0;
            jal = 0;
            jalr = 0;
            pc_to_reg = 0;
            reg_dst = 1;
        end
        `SWD_OP: begin
            alu_src = 1;
            reg_write = 0;
            mem_read = 0;
            mem_to_reg = 0;
            mem_write = 1;
            branch = 0;
            jal = 0;
            jalr = 0;
            pc_to_reg = 0;
            reg_dst = 1;
        end 
        `BNE_OP: begin
            alu_src = 0;
            reg_write = 0;
            mem_read = 0;
            mem_to_reg = 0;
            mem_write = 0;
            branch = 1;
            jal = 0;
            jalr = 0;
            pc_to_reg = 0;
            reg_dst = 1;
        end
        `BEQ_OP: begin
            alu_src = 0;
            reg_write = 0;
            mem_read = 0;
            mem_to_reg = 0;
            mem_write = 0;
            branch = 1;
            jal = 0;
            jalr = 0;
            pc_to_reg = 0;
            reg_dst = 1;
        end
        `BGZ_OP: begin
            alu_src = 0;
            reg_write = 0;
            mem_read = 0;
            mem_to_reg = 0;
            mem_write = 0;
            branch = 1;
            jal = 0;
            jalr = 0;
            pc_to_reg = 0;
            reg_dst = 1;
        end
        `BLZ_OP: begin
            alu_src = 0;
            reg_write = 0;
            mem_read = 0;
            mem_to_reg = 0;
            mem_write = 0;
            branch = 1;
            jal = 0;
            jalr = 0;
            pc_to_reg = 0;
            reg_dst = 1;
        end
        `JMP_OP: begin
            alu_src = 0;
            reg_write = 0;
            mem_read = 0;
            mem_to_reg = 0;
            mem_write = 0;
            branch = 0;
            jal = 1;
            jalr = 0;
            pc_to_reg = 0;
            reg_dst = 1;
        end
        `JAL_OP: begin
            alu_src = 0;
            reg_write = 1;
            mem_read = 0;
            mem_to_reg = 0;
            mem_write = 0;
            branch = 0;
            jal = 1;
            jalr = 0;
            pc_to_reg = 1;
            reg_dst = 1;
        end
        `JRL_OP: begin
            
        end
    endcase
end
endmodule