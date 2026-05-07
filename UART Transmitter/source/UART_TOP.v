`timescale 1ns / 1ps

module UART_TOP #(parameter BAUD = 1)(
    input clk, rst, 
    input [7:0] tx_din,
    input tx_start,
    
    output tx_pin,
    output tx_ready
    );
    
    wire baud_tick, bit_done, load_en, shift_en;
    wire [1:0] tx_sel;
    
    UART_CU cu (
        .clk(clk), 
        .rst(rst), 
        .tx_start(tx_start),
        .baud_tick(baud_tick), 
        .bit_done(bit_done),
        .load_en(load_en), 
        .shift_en(shift_en),
        .tx_sel(tx_sel), 
        .ready(tx_ready)
    );
    
    UART_DU #(BAUD) du (
        .clk(clk), 
        .rst(rst), 
        .din(tx_din),
        .load_en(load_en), 
        .shift_en(shift_en),
        .tx_sel(tx_sel), 
        .baud_tick(baud_tick),
        .bit_done(bit_done), 
        .tx_out(tx_pin)
    );
    
endmodule
