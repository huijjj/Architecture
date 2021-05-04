module forwarding_unit(rs_IFID, rt_IFID, rs_IDEX, rt_IDEX, writeReg_EXMEM, writeReg_MEMWB, reg_write_mem, reg_write_wb, dist3_regout2_forwarding, dist3_regout2_forwarding, dist2_or_dist1_regout1_forwarding, dist2_or_dist1_regout2_forwarding);
    input [1:0] rs_IFID;
    input [1:0] rt_IFID;
    input [1:0] rs_IDEX;
    input [1:0] rt_IDEX;
    
    input [1:0] writeReg_EXMEM;
    input [1:0] writeReg_MEMWB;
    
    input reg_write_mem;
    input reg_write_wb;

    output dist3_regout1_forwarding, dist3_regout2_forwarding;
    output [1:0] dist2_or_dist1_regout1_forwarding;
    output [1:0] dist2_or_dist1_regout2_forwarding;

    //dist 3 rs
    if((rs_IFID == writeReg_MEMWB) && reg_write_wb) begin
        dist3_regout1_forwarding = 1;
    end
    else begin
        dist3_regout1_forwarding = 0;
    end

    //dist 3 rt
    if((rt_IFID == writeReg_MEMWB) && reg_write_wb) begin
        dist3_regout2_forwarding = 1;
    end
    else begin
        dist3_regout1_forwarding = 0;
    end

    // dist 1 and 2 rs
    if((rs_IDEX == writeReg_EXMEM) && reg_write_mem) begin
        dist2_or_dist1_regout1_forwarding = 2'b01;
    end
    else if ((rs_IDEX) == writeReg_MEMWB) && reg_write_wb) begin
        dist2_or_dist1_regout1_forwarding = 2'b10;
    end
    else begin
        dist2_or_dist1_regout1_forwarding = 2'b00;
    end

    // dist 1 and 2 rs
    if((rt_IDEX == writeReg_EXMEM) && reg_write_mem) begin
        dist2_or_dist1_regout1_forwarding = 2'b01;
    end
    else if ((rt_IDEX) == writeReg_MEMWB) && reg_write_wb) begin
        dist2_or_dist1_regout1_forwarding = 2'b10;
    end
    else begin
        dist2_or_dist1_regout1_forwarding = 2'b00;
    end
endmodule
