`timescale 1ns / 1ps

module UART_CU(
    input clk, rst, 
    input tx_start,
    
    input baud_tick,
    input bit_done,
    
    output reg load_en,
    output reg shift_en,
    output reg [1:0] tx_sel,
    output reg ready
    );
    
    parameter [1:0] IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;
    reg [1:0] NS, PS;
    
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
                if(baud_tick) begin
                    if(tx_start) begin
                        load_en = 1;
                        NS = START;
                    end
                end
                else 
                    NS = IDLE;
            end
            
            START: begin
                tx_sel = 2'b10;
                if(baud_tick)
                    NS = DATA;
                else
                    NS = START;
            end
            
            DATA: begin
                tx_sel = 2'b01;
                if(baud_tick)
                    if(bit_done)
                        NS = STOP;
                    else begin
                        NS = DATA;
                        shift_en = 1;
                    end
            end
            
            STOP: begin
                tx_sel = 2'b00;
                if(baud_tick)
                    NS = IDLE;
                else
                    NS = STOP;
            end
            default: NS = IDLE;
        endcase
    end
    
endmodule
