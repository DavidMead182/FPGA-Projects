`timescale 1ns / 1ps

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
