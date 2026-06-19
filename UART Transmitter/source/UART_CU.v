`timescale 1ns / 1ps

module UART_CU(
    input clk, rst, 
    input tx_start,
  
    input bit_done,
    input parity_enable,
    
    output reg load_en,
    output reg shift_en,
    output reg [1:0] tx_sel,
    output reg ready
    );
    
    parameter [2:0] IDLE = 3'b000, START = 3'b001, DATA = 3'b010, PARITY = 3'b011, STOP = 3'b100;
    reg [2:0] NS, PS;
    
    always@(posedge clk, negedge rst) begin
        if(!rst)
            PS <= IDLE;
        else
            PS <= NS;
    end
    
    always@(*) begin
        load_en = 0;
        shift_en = 0;
        tx_sel = 2'b00;
        ready = 0;
        case(PS)
            IDLE: begin
                ready = 1;
                NS = IDLE;
                if(tx_start) begin
                    load_en = 1;
                    NS = START;
                end
            end
            
            START: begin
                tx_sel = 2'b10;
                NS = DATA;
            end
            
            DATA: begin
                tx_sel = 2'b01;
                if(bit_done)
                    if(parity_enable)
                        NS = PARITY;
                    else
                        NS = STOP;
                else begin
                    NS = DATA;
                    shift_en = 1;
                end
            end
            
            PARITY: begin
                tx_sel = 2'b11;
                NS = STOP;
            end
            
            STOP: begin
                tx_sel = 2'b00;
                NS = IDLE;
            end
            default: NS = IDLE;
        endcase
    end
    
endmodule
