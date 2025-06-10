`timescale 1ns / 1ps

module Pre_tb;

    // Parameters
    parameter M = 4;
    parameter N = 8;
    parameter WIDTH = M + N;

    // Testbench signals
    reg clk;
    reg signed [WIDTH-1:0] x_in;
    wire sign;
    wire signed [WIDTH-1:0] x_abs;

    // Instantiate the module under test
    Pre #(M, N) uut (
        .clk(clk),
        .x_in(x_in),
        .sign(sign),
        .x_abs(x_abs)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;  // 10ns period

    // Test sequence
    initial begin
        $display("Time\tclk\tx_in\tsign\tx_abs");
        $monitor("%0t\t%b\t%0d\t%b\t%0d", $time, clk, x_in, sign, x_abs);

        // Initialization
        x_in = 0;

        // Wait for a few clock cycles
        #10;

        // Test 1: Positive input
        x_in = 12'sd50;   // 50
        #10;

        // Test 2: Negative input
        x_in = -12'sd50;  // -75
        #10;

        // Test 3: Maximum positive
        x_in = 12'sd2047; // Max for 12-bit signed
        #10;

        // Test 4: Maximum negative
        x_in = -12'sd2048; // Min for 12-bit signed
        #10;

        // Test 5: Zero
        x_in = 0;
        #10;

        $finish;
    end

endmodule
