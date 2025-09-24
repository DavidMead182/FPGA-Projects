`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: David Mead
// 
// Create Date: 24.09.2025 21:02:35
// Design Name: Blinking LEDS
// Module Name: top
// Project Name: FPGA Foundations
// Description: 
//      Creating a counter that counts to the value of the switches (left(MSB) to right(LSB) )
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input clk,
    input [3:0] switch,
    output [3:0] led
    );
    reg clk_1hz = 0;
    
    // 1hz 
    integer counter = 0;
    always @(posedge clk) begin
        if (counter == 62499999) begin
            counter <= 0;
            clk_1hz <= ~clk_1hz;
        end
        else counter = counter +1;
    end
    
    reg [3:0] count = 4'd0;
    
    always @(posedge clk_1hz) begin
        if (count == count_val) begin
            count <= 4'd0;
        end
        else count = count + 4'd1;
    end
    
    reg [3:0] count_val = 4'd0;
    always @(*) begin
        count_val[0] = switch[0];
        count_val[1] = switch[1];
        count_val[2] = switch[2];
        count_val[3] = switch[3];
    end
    
    assign led[0] = count[0];
    assign led[1] = count[1];
    assign led[2] = count[2];
    assign led[3] = count[3];
endmodule
