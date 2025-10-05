`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.10.2025 00:07:31
// Design Name: 
// Module Name: tb_EMA_Integer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_ema;

    // File I/O variables
    integer file, status;
    real price;

    reg clk = 0;
    real close_price;

    // Variables to store EMA outputs for display
    real EMA_Short_val;
    real EMA_Long_val;

    // Instantiate your EMA module
    top #(200, 50, 2) uut (
        .clk(clk),
        .close_price(close_price)
    );

    // Clock generator
    always #5 clk = ~clk; // 10ns period


    // Feed input data
   
    initial begin
        // Open the file for reading
        file = $fopen("C:/Users/david/FPGA_REPOS/FPGA-Projects/Intermediate/Exponatial Moving Average/Data/APPL_closing_prices.txt", "r");
        if (file == 0) begin
            $display("ERROR: Could not open file!");
            $finish;
        end

        // Read values one by one
        while (!$feof(file)) begin
            status = $fscanf(file, "%f\n", price); // read a real from file
            if (status == 1) begin
                close_price = price;
                #10; // wait 10 time units before next price
            end
        end
        #20;
        $fclose(file);
        $display("All data processed. Finishing simulation.");
        $finish;
    end

    // Display EMA outputs at each clock edge
    always @(posedge clk) begin
        EMA_Short_val = uut.EMA_Short; // Read internal real from module
        EMA_Long_val  = uut.EMA_Long;  // Read internal real from module

        $display("Time=%0t | Close=%.4f | EMA_Short=%.4f | EMA_Long=%.4f",
                 $time, close_price, EMA_Short_val, EMA_Long_val);
    end

endmodule