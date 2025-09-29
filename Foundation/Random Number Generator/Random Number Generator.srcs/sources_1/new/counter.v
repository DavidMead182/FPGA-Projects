`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: David Mead
// 
// Create Date: 29.09.2025 23:47
// Design Name: Random Number Gen
// Module Name: counter
// Project Name: FPGA Foundations
// Description: 
//      counter for converting 125MHz clk to 1Hz clk 
// 
//////////////////////////////////////////////////////////////////////////////////

module counter #(parameter FREQ = 62499999)(
    input clk,
    output reg clk_out =0
    );
    
    // 1hz 
    integer counter = 0;
    always @(posedge clk) begin
        if (counter == FREQ) begin
            counter <= 0;
            clk_out <= ~clk_out;
        end
        else counter = counter +1;
    end
    
endmodule
