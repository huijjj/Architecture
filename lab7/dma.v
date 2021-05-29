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

    reg [7:0] state;
    reg bus_request;
    reg [6:0] index;

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
                if(startdma) begin // receive signal from CPU
                    bus_request <= 1; // request the ownership of the bus
                    state <= 1;
                end
                else begin
                    state <= 0;
                end
            end
            
            1: begin
                if(BG) begin // bus ownership is granted
                    state <= 2;
                end
                else begin
                    state <= 1;
                end
            end

            // waiting for memory latency
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
            end // write Mem[index]

            8: begin
                use_bus <= 0;
                if(index == 11) begin
                    state <= 9;
                end
                else begin
                    index <= index + 1;
                    state <= 2;
                end
            end    

            9: begin // return the ownership of the bus
                bus_request <= 0;
                state <= 10;
            end

            10: begin
                if(BG) begin // ownership not removed yet
                    state <= 10;
                end
                else begin // ownership removed
                    interrupt <= 1; // send DMA interrupt to CPU so that CPU can notice that the DMA operation is done
                    state <= 11;
                end
            end

            11: begin
                interrupt <= 0; // remove the interrupt
                index <= 0; // initialize DMA module for next DMA operation
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