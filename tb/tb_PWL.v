`timescale 1ns / 1ps

module PWL_tb;

    // 参数定义
    parameter M = 4;
    parameter N = 8;
    parameter U = 8;
    parameter V = 4;
    parameter K_WIDTH_I = 4;
    parameter K_WIDTH_F = 12;
    parameter B_WIDTH_I = 4;
    parameter B_WIDTH_F = 12;

    parameter WIDTH = M + N;

    // DUT 接口
    reg clk;
    reg signed [WIDTH-1:0] x_in;
    wire signed [WIDTH-1:0] y_out;

    // 实例化模块
    PWL #(
        .M(M), .N(N),
        .U(U), .V(V),
        .K_WIDTH_I(K_WIDTH_I),
        .K_WIDTH_F(K_WIDTH_F),
        .B_WIDTH_I(B_WIDTH_I),
        .B_WIDTH_F(B_WIDTH_F)
    ) uut (
        .clk(clk),
        .x_in(x_in),
        .y_out(y_out)
    );

    // 时钟生成
    initial clk = 0;
    always #5 clk = ~clk;

    // 仿真主过程
    initial begin
        $display("Time\tclk\tx_in\t\ty_out");

        $monitor("%0t\t%b\t%0d\t\t%0d", $time, clk, x_in, y_out);

        // 初始值
        x_in = 0;
        #100;

        // 示例输入测试用例

        x_in = 12'sd0;     // 零
        #10;

        x_in = 12'sd1024;    // 中间正值
        #10;

        x_in = 12'sd2047;   
        #10;

        x_in = 12'sd15;
        #10;

        x_in = 12'sd1;
        #100;

        $display("Test completed.");
        $finish;
    end

endmodule
