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


module top #(
        parameter int LONG = 200,
        parameter int SHORT = 50,
        parameter real SMOOTHING = 2.0     
        )(
        
        input logic clk,
        input logic reset, 
        input real close_price,
        
        output reg buy ,
        output reg sell ,
        output reg holding
    );
    
    real EMA_Short = 0.0;
    real EMA_Long  = 0.0;
    real prev_EMA_Short = 0.0;
    real prev_EMA_Long  = 0.0;
    real multiplier_long;
    real multiplier_short;
    
    // Number of Inputs counters (Days counter)
    int  days = 0;
    
    // SMA Counters -> both long and short will use the same counter
    real sumSMA = 0;
    
    // Setting constants from the module input parameters
    initial begin
        multiplier_long  = SMOOTHING / (1.0 + LONG);
        multiplier_short = SMOOTHING / (1.0 + SHORT);
    end
    
    localparam int SHORT_MINUS_1 = SHORT - 1;
    localparam int LONG_MINUS_1 = LONG - 1;
    
    
    logic ema_ready;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            ema_ready <= 1'b0;
        end else if (days > SHORT_MINUS_1) begin
            ema_ready <= 1'b1;     // both EMAs computed at least once
        end
    end
        
   
    
    // Formula for EMA: EMA_today = (Price_today * (smoothing / (1 + days))) + EMA_yesterday * (1 - (smoothing / (1 + days)))
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            days <= 0;
            EMA_Short <= 0.0;
            EMA_Long <= 0.0;
            prev_EMA_Short <= 0.0;
            prev_EMA_Long <= 0.0;
            sumSMA  <= 0.0;
        end
        else begin
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
            prev_EMA_Short <= EMA_Short;
            prev_EMA_Long <= EMA_Long;
        end
    end
   
   always_ff @(posedge clk) begin
        if (reset) begin
            buy <=0;
            sell <=0;
            holding <=0;
        end
        else begin
            if ((EMA_Short > EMA_Long) & ema_ready & (~holding)) begin
                buy <= 1;
                sell <= 0;
                holding <= 1;
            end else if ((EMA_Short < EMA_Long) & ema_ready & holding) begin
                buy <= 0;
                sell <= 1;
                holding <= 0;
            end else begin
                buy <= 0;
                sell <= 0;
                holding <= holding;
            end
        end
    end 
   
endmodule
