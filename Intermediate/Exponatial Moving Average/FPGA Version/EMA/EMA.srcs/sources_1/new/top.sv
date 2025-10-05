`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: David Mead
// 
// Create Date: 04.10.2025 17:47:06
// Design Name: EMA systemVerilog module
// Module Name: top
// Project Name: FPGA Intermediate
// Description: 
//      Calculating EMA using an FPGA
// 
//////////////////////////////////////////////////////////////////////////////////


module top #(parameter int LONG = 200,
             parameter int SHORT = 50,
             parameter real SMOOTHING = 2.0)(
        input logic clk,
        // every clk_tik is a new input of data
        input real close_price,
        
        output real EMA_Short,
        output real EMA_Long
    );
    
    real prev_EMA_Short = 0.0;
    real prev_EMA_Long  = 0.0;
    real multiplier_long;
    real multiplier_short;
    
     // Number of Inputs counters (Days counter)
    int  days = 0;
    
    // Setting constants from the module input parameters
    initial begin
        multiplier_long  = SMOOTHING / (1.0 + LONG);
        multiplier_short = SMOOTHING / (1.0 + SHORT);
    end
    
    localparam int SHORT_MINUS_1 = SHORT - 1;
    localparam int LONG_MINUS_1 = LONG - 1;
        
    // SMA Counters -> both long and short will use the same counter
    real sumSMA = 0;
   
    
    // Formula for EMA: EMA_today = (Price_today * (smoothing / (1 + days))) + EMA_yesterday * (1 - (smoothing / (1 + days)))
    always_ff @(posedge clk) begin
        days <= days + 1;
        sumSMA <= (days < LONG)?  sumSMA + close_price : 0.0;
        if (days < SHORT) begin
            EMA_Short <= 0.0;
            EMA_Long  <= 0.0;
        end
        else if (days == SHORT_MINUS_1) begin
            EMA_Short <= sumSMA / SHORT ;
        end
        else if (days < LONG_MINUS_1) begin
            EMA_Short <= close_price * multiplier_short + prev_EMA_Short * (1 - multiplier_short);
        end
        else if (days == LONG_MINUS_1) begin
            EMA_Short <= sumSMA / LONG ;
        end
        else if (days > LONG_MINUS_1) begin
            EMA_Short <= close_price * multiplier_short + prev_EMA_Short * (1 - multiplier_short);
            EMA_Long <= close_price * multiplier_long + prev_EMA_Long * (1 - multiplier_long);
        end
        else begin
            EMA_Short <= 0;
            EMA_Long <= 0;
        end

        prev_EMA_Short = EMA_Short;
        prev_EMA_Long = EMA_Long;
    end
    
endmodule
