`timescale 1ns / 1ps

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
