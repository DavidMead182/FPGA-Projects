`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: David Mead
// 
// Create Date: 29.09.2025 23:47
// Design Name: Random Number Gen
// Module Name: wait_counter
// Project Name: FPGA Foundations
// Description: 
//      Basic 2 bit counter module
// 
//////////////////////////////////////////////////////////////////////////////////

module wait_counter(
       input wire clk,
       input wire reset,
       
       output reg [1:0]count
    );
    
    always @(posedge clk or posedge reset) begin
        if (reset | count == 2'b11) begin
            count <= 2'b00;
        end
        else begin
            count <= count + 1'b1;
        end
    end
endmodule

