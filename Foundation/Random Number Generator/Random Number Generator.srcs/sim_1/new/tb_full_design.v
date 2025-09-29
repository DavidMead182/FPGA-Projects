`timescale 1ns / 1ps

module tb_full_design;

    reg clk = 0;
    reg btn = 0;
    reg reset = 0;
    wire [3:0] led;

    // Instantiate DUT
    top UUT (
        .clk(clk),
        .btn(btn),
        .reset(reset),
        .led(led)
    );

    always #8 clk = ~clk;

    initial begin
        //
    end

endmodule
