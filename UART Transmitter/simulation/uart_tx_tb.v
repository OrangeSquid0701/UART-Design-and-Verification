`timescale 1ns / 1ps

module uart_tx_tb();

    reg clk, rst;
    reg [7:0] tx_din;
    reg tx_start;
    wire tx_pin, tx_ready;
    
    UART_TOP #(1) dut (
        .clk(clk),
        .rst(rst),
        .tx_din(tx_din),
        .tx_start(tx_start),
        .tx_pin(tx_pin),
        .tx_ready(tx_ready)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst = 0;
        tx_start = 0;
        tx_din = 8'b0;
        #10 rst = 1;
        
        #10 tx_din = 8'h55;
        #10 tx_start = 1;
        #210 tx_start = 0;
        
        #20 tx_din = 8'hAA;
        #40 tx_start = 1;
        #210 tx_start = 0;
        #40 $finish;
        
    end
    
    initial begin
        $monitor("Present State: %d", dut.cu.PS);
    end

endmodule
