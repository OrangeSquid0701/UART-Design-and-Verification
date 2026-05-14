`timescale 1ns / 1ps

module UART_DU (
    input clk, rst,
    input [7:0] din,
    
    input load_en,
    input shift_en,
    input [1:0] tx_sel,
    
    output baud_tick,
    output bit_done,
    output reg tx_out 
    );
    
    reg [2:0] bit_counter;
    reg [7:0] shift_reg;
    
    // shift register
    always@(posedge clk, negedge rst) begin
        if(!rst)
            shift_reg <= 8'b0;
        else if(load_en)
            shift_reg <= din;
        else if(shift_en)
            shift_reg <= {1'b0, shift_reg[7:1]}; // shift right
    end
    
    // bit counter
    always@(posedge clk, negedge rst) begin
        if(!rst || tx_sel == 2'b00) 
            bit_counter <= 8'b0;
        else if(shift_en)
            bit_counter <= bit_counter + 1;
    end
    assign bit_done = (bit_counter == 7);
    
    always@(*) begin
        case(tx_sel)
            2'b00: tx_out = 1'b1;
            2'b01: tx_out = shift_reg[0];
            2'b10: tx_out = 1'b0;
            default: tx_out = 1'b1;
        endcase
    end
    
endmodule
