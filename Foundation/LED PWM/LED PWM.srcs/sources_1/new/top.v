`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: David Mead
// 
// Create Date: 30.09.2025 20:30:44
// Design Name: PWM Testing
// Module Name: top
// Project Name: FPGA Foundations
// Description: 
//      Controlling the brightness of an LED with a PWM 
// 
//////////////////////////////////////////////////////////////////////////////////


module top (
    input clk,
    input [3:0] switch,
    
    output reg [3:0] led
    );
    
    // Switches represent % values, i,e switch[3] MSB, switch[0] LSB
    // 0011 is 50%, 0111 is 75%
    integer FREQ = 1249999; // period of the PWM, so that duty cycle can be applied
    integer counter = 0;
    reg PWM_OUT = 1; 
    integer duty = 1250000;
    always @(posedge clk) begin
        if (counter == FREQ) begin
            counter <= 0;
            PWM_OUT = 1;
        end
        else counter = counter +1;
        
        PWM_OUT = (counter < duty)? 1 : 0;
    end
    
    always @(*) begin
        case(switch[3:0])
        4'b0001: begin 
            duty = 312499;
            led = {PWM_OUT, PWM_OUT, PWM_OUT, PWM_OUT};
        end 
        4'b0011: begin 
            duty = 625000;
            led = {PWM_OUT, PWM_OUT, PWM_OUT, PWM_OUT};
        end
        4'b0111: begin 
            duty = 937499;
            led = {PWM_OUT, PWM_OUT, PWM_OUT, PWM_OUT};
        end 
        4'b1111: begin 
            duty = 1250000;
            led = {PWM_OUT, PWM_OUT, PWM_OUT, PWM_OUT};
        end 
        default: led = 4'b0000;
        endcase
    end
    
    
    
    
endmodule
