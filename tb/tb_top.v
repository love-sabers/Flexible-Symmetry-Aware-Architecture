`timescale 1ns / 1ps

module top_tb;

    // 参数定义（与 top 保持一致）
    parameter M = 2;
    parameter N = 10;
    parameter WIDTH = M + N;

    reg clk;
    reg signed [WIDTH-1:0] x_in;
    wire signed [WIDTH-1:0] f_out;

    // DUT 实例化
    top #(
        .M(M),
        .N(N),
        .FUNC_TYPE(4)  // 可切换测试 Swish, GELU, Softplus 等
    ) dut (
        .clk(clk),
        .x_in(x_in),
        .f_out(f_out)
    );

    // 时钟生成
    initial clk = 0;
    always #5 clk = ~clk;  // 10ns 周期

    // 仿真主流程
    initial begin
        // 初始化波形文件（可选）
        $dumpfile("top.vcd");
        $dumpvars(0, top_tb);

        $display("Time\tclk\tx_in\t\tf_out");

        $monitor("%0t\t%b\t%0d\t%0d", $time, clk, x_in, f_out);

        // 初始值
        x_in = 0;
        #100;

        // 测试用例 1：最大正值
        x_in = 12'sd2047;  // 1.999... (Q1.10)
        #10;

        // 测试用例 2：最大负值
        x_in = -12'sd2047; // -2.000
        #10;

        // 测试用例 3：中等正数
        x_in = 12'sd1024;  // 1.0
        #10;

        // 测试用例 4：中等负数
        x_in = -12'sd1024; // -1.0
        #10;

        // 测试用例 5：非常小数值（近零）
        x_in = 12'sd16;    // ~0.0156
        #10;

        // 测试用例 6：负小数值
        x_in = -12'sd16;
        #100;

        // 测试结束
        $display("Simulation complete.");
        $finish;
    end

endmodule
