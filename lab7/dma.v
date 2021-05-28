`define WORD_SIZE 16

module DMA_controller (clk, startdma, length, address, o_address, BG,
 BR, use_bus, idx, interrupt);
    input clk;
    input startdma;
    input [3:0] length;
    input [`WORD_SIZE-1:0] address;
    input BG;

    output [`WORD_SIZE-1:0] o_address;
    output BR;
    output reg use_bus;
    output [3:0] idx;
    output reg interrupt;

    reg [5:0] state;
    reg bus_request;
    reg [5:0] index;

    initial begin
        state = 0;
        bus_request = 0;
        index = 0;
        interrupt = 0;
        use_bus = 0;
    end


    always @(posedge clk) begin
        case(state)
            0: begin
                if(startdma) begin
                    bus_request <= 1;
                    state <= 1;
                end
                else begin
                    state <= 0;
                end
            end
            
            1: begin
                if(BG) begin
                    state <= 2;
                end
                else begin
                    state <= 1;
                end
            end

            2: begin
                state <= 3;
            end

            3: begin
                state <= 4;
            end

            4: begin
                state <= 5;
            end

            5: begin
                state <= 6;
            end

            6: begin
                state <= 7;
            end

            7: begin
                use_bus <= 1;
                state <= 8;
            end

            // write index 0

            8: begin
                index <= index + 1;
                state <= 9;
            end

            // write index 1

            9: begin
                index <= index + 1;
                state <= 10;
            end

            // write index 2

            10: begin
                index <= index + 1;
                state <= 11;
            end

            // write index 3

            11: begin
                index <= index + 1;
                state <= 12;
            end

            // write index 4

            12: begin
                index <= index + 1;
                state <= 13;
            end

            // write index 5

            13: begin
                index <= index + 1;
                state <= 14;
            end

            // write index 6

            14: begin
                index <= index + 1;
                state <= 15;
            end

            // write index 7

            15: begin
                index <= index + 1;
                state <= 16;
            end

            // write index 8

            16: begin
                index <= index + 1;
                state <= 17;
            end

            // write index 9

            17: begin
                index <= index + 1;
                state <= 18;
            end

            // write index 10

            18: begin
                index <= index + 1;
                state <= 19;
            end

            // write index 11

            19: begin
                bus_request <= 0;
                use_bus <= 0;
                state <= 20;
            end

            20: begin
                if(BG) begin
                    state <= 20;
                end
                else begin
                    interrupt <= 1;
                    state <= 21;
                end
            end

            21: begin
                interrupt <= 0;
                index <= 0;
                state <= 0;
            end

            default: begin
                state <= 0;
            end
        endcase
    end

    assign BR = bus_request;
    assign idx = index;
    assign o_address = address + index;

endmodule