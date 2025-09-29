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
    
    output reg [3:0] led
    );
    
    wire clk_1hz;
    counter clk_one_hz (clk, clk_1hz);
    
    wire [1:0] count;
    reg clk_reset = 1;
    
    wait_counter wait_counter (
    .clk(clk_1hz),
    .reset(clk_reset),
    .count(count)
    );
    
    // FSM
    // [00] IDLE State -> no lights waiting for button press 
    // [01] LIGHTS state -> after button press -> flashing lights
    // [10] NUMBER Display state -> show random number -> back to stable state after 20 seconds
     
    // STATES
    parameter IDLE = 2'b00;
    parameter LIGHTS = 2'b01;
    parameter NUMBER = 2'b10;
         
    reg [1:0] current_state, next_state, prev_state;
    
    // STATE MACHINE
    always @(posedge clk_1hz) begin
            prev_state <= current_state;
            current_state <= next_state;
    end
    
    reg start_lights;
    always @(posedge clk) begin
        if (btn) begin         
            start_lights <= 1'b1;
        end else if (current_state != IDLE) begin
            start_lights <= 1'b0;
        end 
    end

    // COMB LOGIC FOR STATES
    always @(*) begin
        case(current_state)
            IDLE: begin
                clk_reset = 1;
                led[3:0] = 4'b0000;
                if (start_lights) next_state = LIGHTS;
                else next_state = IDLE;
            end
            LIGHTS: begin
                clk_reset = 0;
                led[3:0] = 4'b0000;
                next_state = LIGHTS;
                case(count)
                    2'b00: led[3:0] = 4'b0001;
                    2'b01: led[3:0] = 4'b0011;
                    2'b10: led[3:0] = 4'b0111;
                    2'b11: begin 
                            led[3:0] = 4'b1111;
                            next_state = NUMBER;
                        end
                endcase
            end
            NUMBER: begin
                clk_reset = 0;
                led[3:0] = 4'b0110; //replace this with a FPGA compatable random number generator
                next_state = IDLE;
            end
        endcase 
      end

    
    
    
endmodule
