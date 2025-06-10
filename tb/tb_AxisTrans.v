`timescale 1ns / 1ps

module AxisTrans_tb;

    // 参数定义
    parameter M = 4;
    parameter N = 8;
    parameter WIDTH = M + N;

    // 信号定义
    reg clk;
    reg signed [WIDTH-1:0] f_in;
    reg signed [WIDTH-1:0] s_in;

    wire signed [WIDTH-1:0] f_out_0;
    wire signed [WIDTH-1:0] f_out_1;
    wire signed [WIDTH-1:0] f_out_default;

    // 时钟生成
    initial clk = 0;
    always #5 clk = ~clk;  // 10ns 周期

    // 不同功能类型的模块实例
    AxisTrans #(M, N, 0) uut_0 (
        .clk(clk),
        .f_in(f_in),
        .s_in(s_in),
        .f_out(f_out_0)
    );

    AxisTrans #(M, N, 1) uut_1 (
        .clk(clk),
        .f_in(f_in),
        .s_in(s_in),
        .f_out(f_out_1)
    );

    AxisTrans #(M, N, 6) uut_default (
        .clk(clk),
        .f_in(f_in),
        .s_in(s_in),
        .f_out(f_out_default)
    );

    // 仿真过程
    initial begin
        $display("Time\tclk\tf_in\ts_in\tf_out_0\tf_out_1\tf_out_def");
        $monitor("%0t\t%b\t%0d\t%0d\t%0d\t%0d\t%0d",
                 $time, clk, f_in, s_in, f_out_0, f_out_1, f_out_default);

        // 初始值
        f_in = 0; s_in = 0;
        #10;

        // 测试用例 1：正数减法/加法
        f_in = 12'sd50; s_in = 12'sd100; #10;

        // 测试用例 2：负数减法/加法
        f_in = -12'sd30; s_in = 12'sd80; #10;

        // 测试用例 3：两个负数
        f_in = -12'sd45; s_in = -12'sd20; #10;

        // 测试用例 4：零
        f_in = 0; s_in = -12'sd100; #10;

        // 测试用例 5：极限值
        f_in = 12'sd2047; s_in = -12'sd2047; #10;

        $display("Testbench completed.");
        $finish;
    end

endmodule
