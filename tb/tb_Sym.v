`timescale 1ns / 1ps

module Sym_tb;

    // Parameters
    parameter M = 4;
    parameter N = 8;
    parameter WIDTH = M + N;

    // Common signals
    reg clk;
    reg signed [WIDTH-1:0] x_in;
    reg sign;

    wire signed [WIDTH-1:0] s_out_0;
    wire signed [WIDTH-1:0] s_out_1;
    wire signed [WIDTH-1:0] s_out_2;

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Instantiate three versions with different FUNC_TYPE
    Sym #(M, N, 0) uut_0 (
        .clk(clk),
        .x_in(x_in),
        .sign(sign),
        .s_out(s_out_0)
    );

    Sym #(M, N, 1) uut_1 (
        .clk(clk),
        .x_in(x_in),
        .sign(sign),
        .s_out(s_out_1)
    );

    Sym #(M, N, 2) uut_2 (
        .clk(clk),
        .x_in(x_in),
        .sign(sign),
        .s_out(s_out_2)
    );

    // Test sequence
    initial begin
        $display("Starting Sym module testbench...");
        $display("Time\tclk\tsign\tx_in\ts_out_0\ts_out_1\ts_out_2");

        // Monitor all outputs
        $monitor("%0t\t%b\t%b\t%0d\t%0d\t%0d\t%0d", 
                 $time, clk, sign, x_in, s_out_0, s_out_1, s_out_2);

        // Wait one cycle
        #10;

        // Test case 1
        x_in = 12'sd50; sign = 0; #10;
        x_in = -12'sd100; sign = 1; #10;
        x_in = 12'sd77; sign = 1; #10;
        x_in = 12'sd123; sign = 0; #10;
        x_in = -12'sd88; sign = 1; #10;

        $display("Test complete.");
        $finish;
    end

endmodule
