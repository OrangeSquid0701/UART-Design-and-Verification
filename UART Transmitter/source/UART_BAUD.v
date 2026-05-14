`timescale 1ns / 1ps

module UART_BAUD #(parameter BAUD = 5)(
    input  clk_in, rst,
    output baud_tick,
    output reg clk_out
);

    reg [15:0] baud_counter;

    always @(posedge clk_in or negedge rst) begin
        if (!rst) begin
            baud_counter <= 0;
            clk_out <= 0;
        end
        else if (baud_tick) begin
                baud_counter <= 0;
                clk_out <= ~clk_out;
        end 
        else begin
                baud_counter <= baud_counter + 1;
        end
    end
    
    assign baud_tick = (baud_counter == (BAUD - 1));

endmodule