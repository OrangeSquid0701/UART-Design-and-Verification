`timescale 1ns / 1ps

module UART_DU #(
    parameter DATA_WIDTH = 8,
    parameter PARITY_MODE = 0
    )(
    input clk, rst,
    input [DATA_WIDTH - 1:0] din,
    
    input load_en,
    input shift_en,
    input [1:0] tx_sel,
    
    output bit_done,
    output reg parity_enable,
        
    output reg tx_out
    );
    
    // shift register
    reg [DATA_WIDTH - 1:0] shift_reg;
    always@(posedge clk, negedge rst) begin
        if(!rst)
            shift_reg <= 0;
        else if(load_en)
            shift_reg <= din;
        else if(shift_en)
            shift_reg <= {1'b0, shift_reg[DATA_WIDTH - 1:1]}; // shift right
    end
    
    // bit counter
    reg [$clog2(DATA_WIDTH) - 1:0] bit_counter;
    always@(posedge clk, negedge rst) begin
        if(!rst || tx_sel == 2'b00) 
            bit_counter <= 0;
        else if(shift_en)
            bit_counter <= bit_counter + 1;
    end
    assign bit_done = (bit_counter == (DATA_WIDTH - 1));
    
    // parity_mode
    reg parity_bit;
    always@(*) begin
        case(PARITY_MODE)
            2'b00: begin // No Parity
                parity_enable = 0;
                parity_bit = 0;
            end
            2'b01: begin // Odd Parity
                parity_enable = 1;
                parity_bit = ^(din) ? 0: 1;
            end
            2'b10: begin // Even Parity
                parity_enable = 1;
                parity_bit = ^(din) ? 1: 0;
            end
            default: parity_enable = 0;
        endcase
    end
    
    // mux
    always@(*) begin
        case(tx_sel)
            2'b00: tx_out = 1'b1;
            2'b01: tx_out = shift_reg[0];
            2'b10: tx_out = 1'b0;
            2'b11: tx_out = parity_bit;
            default: tx_out = 1'b1;
        endcase
    end
    
endmodule
