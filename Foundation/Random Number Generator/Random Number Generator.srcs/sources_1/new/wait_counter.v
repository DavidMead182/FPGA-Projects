`timescale 1ns / 1ps

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

