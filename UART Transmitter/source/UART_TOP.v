`timescale 1ns / 1ps

module UART_TOP #(parameter BAUD = 5)(
    input clk_sys, rst, 
    input [7:0] tx_din,
    input tx_start,
    
    output tx_pin,
    output tx_ready
    );
    
    wire baud_tick, bit_done, load_en, shift_en;
    wire [1:0] tx_sel;
    wire clk_baud;
    
    UART_BAUD #(BAUD) baud (
        .clk_in(clk_sys),
        .rst(rst),
        .baud_tick(baud_tick),
        .clk_out(clk_baud)
    );
    
    UART_CU cu (
        .clk(clk_baud), 
        .rst(rst), 
        .tx_start(tx_start),
        .baud_tick(baud_tick), 
        .bit_done(bit_done),
        .load_en(load_en), 
        .shift_en(shift_en),
        .tx_sel(tx_sel), 
        .ready(tx_ready)
    );
    
    UART_DU du (
        .clk(clk_baud), 
        .rst(rst), 
        .din(tx_din),
        .load_en(load_en), 
        .shift_en(shift_en),
        .tx_sel(tx_sel),
        .bit_done(bit_done), 
        .tx_out(tx_pin)
    );
    
endmodule
