`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 
// 
// Create Date: 24.09.2025 23:15:26
// Design Name: Random Number Gen
// Module Name: top
// Project Name: FPGA Foundations
// Description: 
//      Creating a number gen that can be used as a dice.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input clk,
    input btn,
    input reset,
    
    output reg [2:0] led
    );
    
    wire clk_1hz;
    counter clk_one_hz (clk, clk_1hz);
    
    // FSM
    // [00] Stable State -> no lights waiting for button press 
    // [01] post press state -> after button press -> flashing lights
    // [10]   Number Display state -> show random number -> back to stable state after 20 seconds
    
    reg [1:0] current, next;
    reg button_press = 0;
    
    always @(posedge clk) begin
        if (reset) begin
            current <= 2'b00;
        end
        else current <= next;
    end
    
    
    always @(*) begin
        case (current)
            2'b00: begin
                    next = (button_press)? 2'b01: 2'b00;
                    led = 2'b00;
                   end
//            2'b01: 
//            2'b10: 
            
            default: next = (button_press)? 2'b01: 2'b00;
        endcase
    end
    
    
    
    
endmodule
