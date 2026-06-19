`timescale 1ns / 1ps

module uart_tx_tb();
    parameter BAUD = 3;
    parameter DATA_WIDTH = 16;
    parameter PARITY_MODE = 1; // 0: no parity, 1: odd parity, 2: even parity
    
    reg clk_in, rst;
    reg [DATA_WIDTH - 1:0] tx_din;
    reg tx_start;
    wire tx_pin, tx_ready;
    wire clk_baud;
    
    UART_TOP #(
        .BAUD(BAUD),
        .DATA_WIDTH(DATA_WIDTH),
        .PARITY_MODE(PARITY_MODE)
    ) dut (
        .clk_sys(clk_in),
        .rst(rst),
        .tx_din(tx_din),
        .tx_start(tx_start),
        .tx_pin(tx_pin),
        .tx_ready(tx_ready)
    );
    
    assign clk_baud = dut.tx_baud.clk_out;
    
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end
    
    initial begin
        rst = 0;
        tx_start = 0;
        tx_din = 16'b0;
        #10 rst = 1;
        
        packet(16'h55AC);
        packet(16'hAB57);
        packet(16'h5510);
        
        #200 $finish;
    end
    
    initial begin
        $monitor("Present State: %d", dut.tx_cu.PS);
    end
    
    task packet(input [DATA_WIDTH - 1:0] data); begin
        tx_din = data;
        tx_start = 1;
        @(posedge tx_ready);
        tx_start = 0;
        #50;
    end
    endtask

endmodule
