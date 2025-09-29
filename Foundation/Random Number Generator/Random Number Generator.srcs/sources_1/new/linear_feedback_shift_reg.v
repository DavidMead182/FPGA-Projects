`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: David Mead
// 
// Create Date: 29.09.2025 23:47
// Design Name: Random Number Gen
// Module Name: linear_feedback_shift_reg
// Project Name: FPGA Foundations
// Description: 
//      module uses a linear feedback shift reg to create pseudo random number
// 
//////////////////////////////////////////////////////////////////////////////////

module linear_feedback_shift_reg(
    input clk,
    output [3:0] rand_num
    );
    reg [4:1] r_LFSR = 0;
    reg  r_XNOR;
    always @(posedge clk)
    begin
            r_LFSR <= {r_LFSR[3:1], r_LFSR[4] ^~ r_LFSR[3]};
    end
   
   assign rand_num = r_LFSR[4:1];
    
endmodule
