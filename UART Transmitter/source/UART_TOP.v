`timescale 1ns / 1ps

module UART_TOP #(
    parameter BAUD = 5,
    parameter DATA_WIDTH = 8,
    parameter PARITY_MODE = 0 // 0: no parity, 1: odd parity, 2: even parity
    )(
    input clk_sys, rst, 
    input [DATA_WIDTH - 1:0] tx_din,
    input tx_start,
    
    output tx_pin,
    output tx_ready
    );
    
    wire bit_done, load_en, shift_en;
    wire [1:0] tx_sel;
    wire clk_baud;
    wire parity_enable;
    
    UART_BAUD #(BAUD) tx_baud (
        .clk_in(clk_sys),
        .rst(rst),
        .clk_out(clk_baud)
    );
    
    UART_CU tx_cu (
        .clk(clk_baud), 
        .rst(rst), 
        .tx_start(tx_start),
        
        .bit_done(bit_done),
        .parity_enable(parity_enable),
        
        .load_en(load_en), 
        .shift_en(shift_en),
        .tx_sel(tx_sel), 
        .ready(tx_ready)
    );
    
    UART_DU #(
        .DATA_WIDTH(DATA_WIDTH),
        .PARITY_MODE(PARITY_MODE)
    ) tx_du (
        .clk(clk_baud), 
        .rst(rst), 
        .din(tx_din),
        
        .load_en(load_en), 
        .shift_en(shift_en),
        .tx_sel(tx_sel),
        .bit_done(bit_done), 
        .tx_out(tx_pin),
        .parity_enable(parity_enable)
    );
    
endmodule
