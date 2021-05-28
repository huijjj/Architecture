`timescale 1ns/1ns


module insturction_cache(input [15:0] i_address, input [15:0] i_data, input reset_n, input [15:0] instruction_count, input read, input clk, input flush, input d_cache_busy, input BG,
 output [15:0] address, output reg [15:0] o_data, output hit, output read_m1);
    
	reg [2:0] state;
	reg [15:0] address1;

    reg set0_way0_valid;
    reg [12:0] set0_way0_tag;
    reg [15:0] set0_way0_data [0:3];
    reg [15:0] set0_way0_last_access;
    reg set0_way1_valid;
    reg [12:0] set0_way1_tag;
    reg [15:0] set0_way1_data [0:3];
    reg [15:0] set0_way1_last_access;
    reg set1_way0_valid;
    reg [12:0] set1_way0_tag;
    reg [15:0] set1_way0_data [0:3];
    reg [15:0] set1_way0_last_access;
    reg set1_way1_valid;
    reg [12:0] set1_way1_tag;
    reg [15:0] set1_way1_data [0:3];
    reg [15:0] set1_way1_last_access;
    
    reg [12:0] temp_tag;
    reg [15:0] temp_data [0:3];
    reg [15:0] temp_last_access;

    wire [1:0] offset;
    wire index;
    wire [12:0] tag;
	wire temp_hit;
	reg is_hit;
    reg [15:0] data;

    assign offset = i_address[1:0];
    assign index = i_address[2];
    assign tag = i_address[15:3];
    
    reg complete;
    reg read1;
    assign read_m1 = read1;

    initial begin // reset
        state = 2'b00;
        set0_way0_valid = 0;
        set0_way1_valid = 0;
        set1_way0_valid = 0;
        set1_way1_valid = 0;
        read1 = 0;
        complete = 0;
		is_hit = 0;
        data = 16'hb000;
    end

    always @(*) begin // reset
        if(!reset_n) begin
            state = 2'b00;
            set0_way0_valid = 0;
            set0_way1_valid = 0;
            set1_way0_valid = 0;
            set1_way1_valid = 0;
            read1 = 0;
            complete = 0;
			is_hit = 0;
            data = 16'hb000;
        end
    end

    wire [15:0] block0;
    wire [15:0] block1;
    wire [15:0] block2;
    wire [15:0] block3;
    assign block0[15:3] = tag; 
    assign block1[15:3] = tag; 
    assign block2[15:3] = tag; 
    assign block3[15:3] = tag; 
    assign block0[2] = index; 
    assign block1[2] = index; 
    assign block2[2] = index; 
    assign block3[2] = index; 
    assign block0[1:0] = 2'b00;
    assign block1[1:0] = 2'b01;
    assign block2[1:0] = 2'b10;
    assign block3[1:0] = 2'b11;


    // combinational logic for deciding cache hit
    assign temp_hit = (index == 0) ? ((tag == set0_way0_tag) & set0_way0_valid) | ((tag == set0_way1_tag)  & set0_way1_valid)
        : ((tag == set1_way0_tag) & set1_way0_valid) | ((tag == set1_way1_tag)  & set1_way1_valid);

	assign hit = temp_hit | (complete & !temp_hit);

    wire [15:0] hit_data;
    assign hit_data = temp_hit ? (index == 0) ? (((tag == set0_way0_tag) & set0_way0_valid) ? set0_way0_data[offset] : set0_way1_data[offset]) // hit (index 0)
        : (((tag == set1_way0_tag) & set1_way0_valid) ? set1_way0_data[offset] : set1_way1_data[offset]) // hit (index 1)
        : data; // miss

    assign o_data = hit_data;

    always @(posedge clk) begin // state machine for cache operation
        case(state)
            3'b000: begin            
                if(read) begin
                    if(temp_hit) begin // hit
                        state <= 3'b000;
                        read1 <= 0;
                        if(index == 0) begin // index 0
                            if((tag == set0_way0_tag) && set0_way0_valid) begin
                                set0_way0_last_access <= instruction_count;
                            end
                            else begin
                                set0_way1_last_access <= instruction_count;
                            end
                        end
                        else begin // index 1
                            if((tag == set1_way0_tag) && set1_way0_valid) begin
                                set1_way0_last_access <= instruction_count;
                            end
                            else begin
                                set1_way1_last_access <= instruction_count;
                            end                            
                        end
                    end
                    else begin // miss
                        if(flush) begin
                            state <= 3'b000;
                        end
                        else begin
                            if(BG) begin
                                state <= 3'b000;
                            end
                            else begin
                                state <= 3'b001;
                            end
                        end
                    end
                end
                else begin
                    state <= 3'b000;
                end
            end


            3'b001: begin
                if(flush) begin
                    state <= 3'b000;
                    read1 <= 0;
                end
                else begin
                    address1 <= block0;
                    temp_tag <= tag;
                    temp_last_access <= instruction_count;
                    read1 <= 1;                  
                    state <= 3'b010;           
                end
            end
            3'b010: begin
                if(flush) begin
                    state <= 3'b000;
                    read1 <= 0;
                end
                else begin
                    temp_data[0] <= i_data;
                    address1 <= block1;
                    state <= 3'b011;
                    read1 <= 1;               
                end
            end
            3'b011: begin
                if(flush) begin
                    state <= 3'b000;
                    read1 <= 0;
                end
                else begin
                    temp_data[1] <= i_data;
                    address1 <= block2;
                    state <= 3'b100;
                    read1 <= 1;                
                end
            end

            3'b100: begin
                if(flush) begin
                    state <= 3'b000;
                    read1 <= 0;
                end
                else begin
                    temp_data[2] <= i_data;
                    address1 <= block3;                    
                    state <= 3'b101;
                    read1 <= 1;
                end
            end

            3'b101: begin
                if(flush) begin
                    state <= 3'b000;
                    read1 <= 0;
                    complete <= 0;
                end
                else begin
                    temp_data[3] <= i_data;
                    read1 <= 0;
                    state <= 3'b110;
                    complete <= 1;
                    data <= offset == 2'b11 ? i_data : temp_data[offset];
                end
            end
            
            default: begin
                if(flush) begin
                    state <= 3'b000;
                    read1 <= 0;
                    complete <= 0;
                end
                else begin
                    // if(d_cache_busy) begin
                    //     complete <= 1;
                    //     state <= 3'b110;
                    // end
                    // else begin
                    //     complete <= 0;
                    //     state <= 3'b000;
                    // end
                    read1 <= 0;
                    complete <= 0;
                    state <= 3'b000;


                    // true LRU eviction policy
                    if(index == 0) begin
                        if(set0_way0_valid == 0) begin
                            set0_way0_tag <= temp_tag;
                            set0_way0_data[0] <= temp_data[0];
                            set0_way0_data[1] <= temp_data[1];
                            set0_way0_data[2] <= temp_data[2];
                            set0_way0_data[3] <= temp_data[3];			
                            set0_way0_last_access <= temp_last_access;
                            set0_way0_valid <= 1'b1;
                        end
                        else if(set0_way1_valid == 0) begin
                            set0_way1_tag <= temp_tag;
                            set0_way1_data[0] <= temp_data[0];
                            set0_way1_data[1] <= temp_data[1];
                            set0_way1_data[2] <= temp_data[2];
                            set0_way1_data[3] <= temp_data[3];
                            set0_way1_last_access <= temp_last_access;
                            set0_way1_valid <= 1'b1;
                        end
                        else begin
                            if(set0_way0_last_access < set0_way1_last_access) begin
                                set0_way0_tag <= temp_tag;
                                set0_way0_data[0] <= temp_data[0];
                                set0_way0_data[1] <= temp_data[1];
                                set0_way0_data[2] <= temp_data[2];
                                set0_way0_data[3] <= temp_data[3];
                                set0_way0_last_access <= temp_last_access;
                                set0_way0_valid <= 1'b1;
                            end
                            else begin
                                set0_way1_tag <= temp_tag;
                                set0_way1_data[0] <= temp_data[0];
                                set0_way1_data[1] <= temp_data[1];
                                set0_way1_data[2] <= temp_data[2];
                                set0_way1_data[3] <= temp_data[3];
                                set0_way1_last_access <= temp_last_access;
                                set0_way1_valid <= 1'b1;
                            end
                        end
                    end

                    else begin
                        if(set1_way0_valid == 0) begin
                            set1_way0_tag <= temp_tag;
                            set1_way0_data[0] <= temp_data[0];
                            set1_way0_data[1] <= temp_data[1];
                            set1_way0_data[2] <= temp_data[2];
                            set1_way0_data[3] <= temp_data[3];
                            set1_way0_last_access <= temp_last_access;
                            set1_way0_valid <= 1'b1;
                        end
                        else if(set1_way1_valid == 0) begin
                            set1_way1_tag <= temp_tag;
                            set1_way1_data[0] <= temp_data[0];
                            set1_way1_data[1] <= temp_data[1];
                            set1_way1_data[2] <= temp_data[2];
                            set1_way1_data[3] <= temp_data[3];
                            set1_way1_last_access <= temp_last_access;
                            set1_way1_valid <= 1'b1;
                        end
                        else begin
                            if(set1_way0_last_access < set1_way1_last_access) begin
                                set1_way0_tag <= temp_tag;
                                set1_way0_data[0] <= temp_data[0];
                                set1_way0_data[1] <= temp_data[1];
                                set1_way0_data[2] <= temp_data[2];
                                set1_way0_data[3] <= temp_data[3];
                                set1_way0_last_access <= temp_last_access;
                                set1_way0_valid <= 1'b1;
                            end
                            else begin
                                set1_way1_tag <= temp_tag;
                                set1_way1_data[0] <= temp_data[0];
                                set1_way1_data[1] <= temp_data[1];
                                set1_way1_data[2] <= temp_data[2];
                                set1_way1_data[3] <= temp_data[3];
                                set1_way1_last_access <= temp_last_access;
                                set1_way1_valid <= 1'b1;
                            end
                        end  
                    end
                end
            end
        endcase
    end

	assign address = address1; 
endmodule

module data_cache (input reset_n, input clk, input [15:0] input_address, input read_signal, input write_signal, input [15:0] instruction_count, input BG,
output hit, output busy, input [15:0] data_cpu_in, output reg [15:0] data_cpu_out, output [15:0] output_address, inout reg [15:0] data_mem, output read_m2, output write_m2);
    
    reg [3:0] state;
    reg [15:0] data;
    reg complete;
    reg read2;
    reg write2;
    reg [15:0] address;

    reg set0_way0_valid;
    reg [12:0] set0_way0_tag;
    reg [15:0] set0_way0_data [0:3];
    reg [15:0] set0_way0_last_access;

    reg set0_way1_valid;
    reg [12:0] set0_way1_tag;
    reg [15:0] set0_way1_data [0:3];
    reg [15:0] set0_way1_last_access;

    reg set1_way0_valid;
    reg [12:0] set1_way0_tag;
    reg [15:0] set1_way0_data [0:3];
    reg [15:0] set1_way0_last_access;

    reg set1_way1_valid;
    reg [12:0] set1_way1_tag;
    reg [15:0] set1_way1_data [0:3];
    reg [15:0] set1_way1_last_access;
    
    reg [12:0] temp_tag;
    reg [15:0] temp_data [0:3];
    reg [15:0] temp_last_access;

    reg [15:0] input_addr;
    reg [15:0] write_data;

    assign input_addr = state == 0 ? input_address : input_addr;

    // initialize
    initial begin
        state = 4'b0000;
        set0_way0_valid = 0;
        set0_way1_valid = 0;
        set1_way0_valid = 0;
        set1_way1_valid = 0;
        data = 0;
        complete = 0;
        read2 = 0;
        address = 0;
        write2 = 0;
        write_data = 0;
    end

    always @(*) begin
        if(!reset_n) begin
            state = 4'b0000;
            set0_way0_valid = 0;
            set0_way1_valid = 0;
            set1_way0_valid = 0;
            set1_way1_valid = 0;
            data = 0;
            complete = 0;
            read2 = 0;
            address = 0;
            write2 = 0;
            write_data = 0;
        end   
    end

    wire [1:0] offset;
    wire index;
    wire [12:0] tag;

    assign offset = input_addr[1:0];
    assign index = input_addr[2];
    assign tag = input_addr[15:3];
    
    wire is_hit;
    assign is_hit = (index == 0) ? ((tag == set0_way0_tag) & set0_way0_valid) | ((tag == set0_way1_tag)  & set0_way1_valid)
        : ((tag == set1_way0_tag) & set1_way0_valid) | ((tag == set1_way1_tag)  & set1_way1_valid);

    assign data_cpu_out = is_hit ? (index == 0) ? ((tag == set0_way0_tag) & set0_way0_valid) ? set0_way0_data[offset] : set0_way1_data[offset] // hit index 0
        : ((tag == set1_way0_tag) & set1_way0_valid) ? set1_way0_data[offset] : set1_way1_data[offset] // hit index 1
        : data; // miss

    assign hit = is_hit;

    wire [15:0] block0;
    wire [15:0] block1;
    wire [15:0] block2;
    wire [15:0] block3;
    assign block0[15:3] = tag; 
    assign block1[15:3] = tag; 
    assign block2[15:3] = tag; 
    assign block3[15:3] = tag; 
    assign block0[2] = index; 
    assign block1[2] = index; 
    assign block2[2] = index; 
    assign block3[2] = index; 
    assign block0[1:0] = 2'b00;
    assign block1[1:0] = 2'b01;
    assign block2[1:0] = 2'b10;
    assign block3[1:0] = 2'b11;

    assign write_data = (write_signal & state == 4'b0000) ? data_cpu_in : write_data;

    always @(posedge clk) begin
        input_addr <= state == 0 ? input_address : input_addr;
        case(state)
            4'b0000: begin // idle
                if(read_signal) begin
                    if(is_hit) begin // read hit
                        state <= 4'b0000;
                        read2 <= 0;
                        if(index == 0) begin // idx 0
                            if((tag == set0_way0_tag) && set0_way0_valid) begin
                                set0_way0_last_access <= instruction_count;
                            end
                            else begin
                                set0_way1_last_access <= instruction_count;
                            end
                        end
                        else begin // idx 1
                            if((tag == set1_way0_tag) && set1_way0_valid) begin
                                set1_way0_last_access <= instruction_count;
                            end
                            else begin
                                set1_way1_last_access <= instruction_count;
                            end
                        end
                    end
                    else begin // read miss
                        if(BG) begin
                            state <= 4'b0000;
                            read2 <= 0;
                        end
                        else begin
                            state <= 4'b0001;
                            address <= block0;
                            temp_tag <= tag;
                            temp_last_access <= instruction_count;
                            read2 <= 1;
                        end

                    end
                end

                else if(write_signal) begin
                    if(BG) begin
                        state <= 4'b0000;
                    end
                    else begin
                        if(is_hit) begin
                            if(index == 0) begin // index 0
                                if((tag == set0_way0_tag) && set0_way0_valid) begin
                                    set0_way0_data[offset] <= data_cpu_in;
                                    set0_way0_last_access <= instruction_count;
                                end
                                else begin
                                    set0_way1_data[offset] <= data_cpu_in;
                                    set0_way1_last_access <= instruction_count;
                                end
                            end
                            else begin // index 1
                                if((tag == set1_way0_tag) && set1_way0_valid) begin
                                    set1_way0_data[offset] <= data_cpu_in;
                                    set1_way0_last_access <= instruction_count;
                                end
                                else begin
                                    set1_way1_data[offset] <= data_cpu_in;
                                    set1_way1_last_access <= instruction_count;
                                end
                            end
                            state <= 4'b1001;
                        end
                        else begin
                            state <= 4'b1001;
                        end
                    end
                end

                else begin
                    state <= 4'b0000;
                end
            end


            4'b0001: begin // read
                
                temp_data[0] <= data_mem;
                address <= block1;
                read2 <= 1;
                state <= 4'b0010;
            end
            4'b0010: begin
                temp_data[1] <= data_mem;
                address <= block2;
                read2 <= 1;
                state <= 4'b0011;
            end
            4'b0011: begin
                temp_data[2] <= data_mem;
                address <= block3;
                read2 <= 1;
                state <= 4'b0100;
                
            end
            4'b0100: begin
                temp_data[3] <= data_mem;
                read2 <= 0;
                state <= 4'b0110;
                complete <= 1;
                state <= 4'b0101;               
                data <= (offset == 2'b11) ? data_mem : temp_data[offset];
            end

            4'b0101: begin
                complete <= 0;
                state <= 4'b0000;

                if(index == 0) begin
                    if(set0_way0_valid == 0) begin
                        set0_way0_tag <= temp_tag;
                        set0_way0_data[0] <= temp_data[0];
                        set0_way0_data[1] <= temp_data[1];
                        set0_way0_data[2] <= temp_data[2];
                        set0_way0_data[3] <= temp_data[3];			
                        set0_way0_last_access <= temp_last_access;
                        set0_way0_valid <= 1'b1;
                    end
                    else if(set0_way1_valid == 0) begin
                        set0_way1_tag <= temp_tag;
                        set0_way1_data[0] <= temp_data[0];
                        set0_way1_data[1] <= temp_data[1];
                        set0_way1_data[2] <= temp_data[2];
                        set0_way1_data[3] <= temp_data[3];
                        set0_way1_last_access <= temp_last_access;
                        set0_way1_valid <= 1'b1;
                    end
                    else begin
                        if(set0_way0_last_access < set0_way1_last_access) begin
                            set0_way0_tag <= temp_tag;
                            set0_way0_data[0] <= temp_data[0];
                            set0_way0_data[1] <= temp_data[1];
                            set0_way0_data[2] <= temp_data[2];
                            set0_way0_data[3] <= temp_data[3];
                            set0_way0_last_access <= temp_last_access;
                            set0_way0_valid <= 1'b1;
                        end
                        else begin
                            set0_way1_tag <= temp_tag;
                            set0_way1_data[0] <= temp_data[0];
                            set0_way1_data[1] <= temp_data[1];
                            set0_way1_data[2] <= temp_data[2];
                            set0_way1_data[3] <= temp_data[3];
                            set0_way1_last_access <= temp_last_access;
                            set0_way1_valid <= 1'b1;
                        end
                    end
                end

                else begin
                    if(set1_way0_valid == 0) begin
                        set1_way0_tag <= temp_tag;
                        set1_way0_data[0] <= temp_data[0];
                        set1_way0_data[1] <= temp_data[1];
                        set1_way0_data[2] <= temp_data[2];
                        set1_way0_data[3] <= temp_data[3];
                        set1_way0_last_access <= temp_last_access;
                        set1_way0_valid <= 1'b1;
                    end
                    else if(set1_way1_valid == 0) begin
                        set1_way1_tag <= temp_tag;
                        set1_way1_data[0] <= temp_data[0];
                        set1_way1_data[1] <= temp_data[1];
                        set1_way1_data[2] <= temp_data[2];
                        set1_way1_data[3] <= temp_data[3];
                        set1_way1_last_access <= temp_last_access;
                        set1_way1_valid <= 1'b1;
                    end
                    else begin
                        if(set1_way0_last_access < set1_way1_last_access) begin
                            set1_way0_tag <= temp_tag;
                            set1_way0_data[0] <= temp_data[0];
                            set1_way0_data[1] <= temp_data[1];
                            set1_way0_data[2] <= temp_data[2];
                            set1_way0_data[3] <= temp_data[3];
                            set1_way0_last_access <= temp_last_access;
                            set1_way0_valid <= 1'b1;
                        end
                        else begin
                            set1_way1_tag <= temp_tag;
                            set1_way1_data[0] <= temp_data[0];
                            set1_way1_data[1] <= temp_data[1];
                            set1_way1_data[2] <= temp_data[2];
                            set1_way1_data[3] <= temp_data[3];
                            set1_way1_last_access <= temp_last_access;
                            set1_way1_valid <= 1'b1;
                        end
                    end  
                end
            end



            4'b1001: begin // write
                state <= 4'b1010;
            end
            4'b1010: begin
                state <= 4'b1011;                
            end
            4'b1011: begin
                state <= 4'b1100;                
            end
            4'b1100: begin
                state <= 4'b1101;
            end
            4'b1101: begin
                write2 <= 1;
                address <= input_addr;
                state <= 4'b1110;
                complete <= 1;
            end
            4'b1110: begin
                write2 <= 0;
                complete <= 0;
                state <= 4'b0000;
            end
            default: begin
                state <= 4'b0000;
                write2 <= 0;
                read2 <= 0;
            end
        endcase
    end

    assign busy = state != 4'b0000;
    assign output_address = address;
    assign read_m2 = read2;
    assign write_m2 = write2;
    assign data_mem = write2 ? write_data : 16'bz;
endmodule