`timescale 1ns/1ns


module insturction_cache(input [15:0] addr, input [15:0] i_data, input reset_n, input [15:0] instruction_count, input read, input clk, input flush,
 output [15:0] address, output reg [15:0] o_data, output hit, output read_m1, output [2:0] o_state);
    
	reg [2:0] state;
	reg [15:0] address1;

    reg set0_way0_valid;
    reg [12 : 0] set0_way0_tag;
    reg [15 : 0] set0_way0_data [0 : 3];
    reg [15 : 0] set0_way0_last_access;

    reg set0_way1_valid;
    reg [12 : 0] set0_way1_tag;
    reg [15 : 0] set0_way1_data [0 : 3];
    reg [15 : 0] set0_way1_last_access;


    reg set1_way0_valid;
    reg [12 : 0] set1_way0_tag;
    reg [15 : 0] set1_way0_data [0 : 3];
    reg [15 : 0] set1_way0_last_access;


    reg set1_way1_valid;
    reg [12 : 0] set1_way1_tag;
    reg [15 : 0] set1_way1_data [0 : 3];
    reg [15 : 0] set1_way1_last_access;
    
    
    reg [12 : 0] temp_tag;
    reg [15 : 0] temp_data [0 : 3];
    reg [15 : 0] temp_last_access;


    wire [1 : 0] offset;
    wire index;
    wire [12 : 0] tag;
	wire temp_hit;
	reg is_hit;

    assign offset = addr[1 : 0];
    assign index = addr[2];
    assign tag = addr[15 : 3];
    
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

        end
    end


    assign temp_hit = (index == 0) ? ((tag == set0_way0_tag) & set0_way0_valid) | ((tag == set0_way1_tag)  & set0_way1_valid)
        : ((tag == set1_way0_tag) & set1_way0_valid) | ((tag == set1_way1_tag)  & set1_way1_valid);

	assign hit = complete | temp_hit;

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

    reg [15:0] data;


    wire [15:0] hit_data;
    assign hit_data = temp_hit ? (index == 0) ? (((tag == set0_way0_tag) & set0_way0_valid) ? set0_way0_data[offset] : set0_way1_data[offset]) 
        : (((tag == set1_way0_tag) & set1_way0_valid) ? set1_way0_data[offset] : set1_way1_data[offset])
        : data; // miss

    assign o_data = hit_data;




    always @(posedge clk) begin
        case(state)
            3'b000: begin
               
                if(read) begin
                    if(index == 0) begin
                        if((tag == set0_way0_tag) && set0_way0_valid) begin
                            set0_way0_last_access <= instruction_count;
						
                            // case(offset)
                            //     2'b00: begin
                            //         data <= set0_way0_data[0];
                            //     end
                            //     2'b01: begin
                            //         data <= set0_way0_data[1];
                            //     end
                            //     2'b10: begin
                            //         data <= set0_way0_data[2];                    
                            //     end 
                            //     default: begin
                            //         data <= set0_way0_data[3];                                    
                            //     end
                            // endcase
                        end
                        else if((tag == set0_way1_tag) && set0_way1_valid) begin
                            set0_way1_last_access <= instruction_count;
						
                            // case(offset)
                            //     2'b00: begin
                            //         data <= set0_way1_data[0];
                            //     end
                            //     2'b01: begin
                            //         data <= set0_way1_data[1];
                            //     end
                            //     2'b10: begin
                            //         data <= set0_way1_data[2];                    
                            //     end 
                            //     default: begin
                            //         data <= set0_way1_data[3];                                    
                            //     end
                            // endcase
                        end

                        else begin // miss
                            state <= 3'b001;
							address1 <= block0;
							read1 <= 1;
                        end
                    end
                    else begin // index == 1
                        if((tag == set1_way0_tag) && set1_way0_valid) begin
                            set1_way0_last_access <= instruction_count;
                            // case(offset)
                                // 2'b00: begin
                                //     data <= set1_way0_data[0];
                                // end
                                // 2'b01: begin
                                //     data <= set1_way0_data[1];
                                // end
                                // 2'b10: begin
                                //     data <= set1_way0_data[2];                    
                                // end 
                                // default: begin
                                //     data <= set1_way0_data[3];                                    
                                // end
                            // endcase
                        end
                        else if((tag == set1_way1_tag) && set1_way1_valid) begin
                            set1_way1_last_access <= instruction_count; 
                            // case(offset)
                            //     2'b00: begin
                            //         data <= set1_way1_data[0];
                            //     end
                            //     2'b01: begin
                            //         data <= set1_way1_data[1];
                            //     end
                            //     2'b10: begin
                            //         data <= set1_way1_data[2];                    
                            //     end 
                            //     default: begin
                            //         data <= set1_way1_data[3];                                    
                            //     end
                            // endcase
                        end

                        else begin // miss
                            state <= 3'b001;
							address1 <= block0;
							read1 <= 1;
							
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
                    temp_tag <= tag;
                    temp_last_access <= instruction_count;
                    temp_data[0] <= i_data;

                    address1 <= block1;
                    state <= 3'b010;
                    read1 <= 1;
                end
            end
            3'b010: begin
                if(flush) begin
                    state <= 3'b000;
                    read1 <= 0;
                end
                else begin
                    temp_data[1] <= i_data;
                    address1 <= block2;
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
                    temp_data[2] <= i_data;
                    address1 <= block3;
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
                    temp_data[3] <= i_data;
                    address1 <= block3;
                    state <= 3'b101;
                    read1 <= 0;
                end
            end

            3'b101: begin
                if(flush) begin
                    state <= 3'b000;
                    read1 <= 0;
                    complete <= 0;
                end
                else begin
                    state <= 3'b110;
                    read1 <= 0;
                    complete <= 1;
                    case(offset)
                        2'b00: begin
                            data <= temp_data[0];
                        end
                        2'b01: begin
                            data <= temp_data[1];
                        end
                        2'b10: begin
                            data <= temp_data[2];                           
                        end
                        default: begin
                            data <= temp_data[3];                            
                        end
                    endcase
                end
            end
            default: begin
                if(flush) begin
                    state <= 3'b000;
                    read1 <= 0;
                    complete <= 0;
                end
                else begin
                    complete <= 0;
                    read1 <= 0;
                    state <= 3'b000;
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

	// assigning test outputs
	assign o_state = state;
	assign address = address1;

endmodule