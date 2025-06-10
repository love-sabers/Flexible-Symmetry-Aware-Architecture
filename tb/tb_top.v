`timescale 1ns / 1ps

module top_tb;

    // �������壨�� top ����һ�£�
    parameter M = 2;
    parameter N = 10;
    parameter WIDTH = M + N;

    reg clk;
    reg signed [WIDTH-1:0] x_in;
    wire signed [WIDTH-1:0] f_out;

    // DUT ʵ����
    top #(
        .M(M),
        .N(N),
        .FUNC_TYPE(4)  // ���л����� Swish, GELU, Softplus ��
    ) dut (
        .clk(clk),
        .x_in(x_in),
        .f_out(f_out)
    );

    // ʱ������
    initial clk = 0;
    always #5 clk = ~clk;  // 10ns ����

    // ����������
    initial begin
        // ��ʼ�������ļ�����ѡ��
        $dumpfile("top.vcd");
        $dumpvars(0, top_tb);

        $display("Time\tclk\tx_in\t\tf_out");

        $monitor("%0t\t%b\t%0d\t%0d", $time, clk, x_in, f_out);

        // ��ʼֵ
        x_in = 0;
        #100;

        // �������� 1�������ֵ
        x_in = 12'sd2047;  // 1.999... (Q1.10)
        #10;

        // �������� 2�����ֵ
        x_in = -12'sd2047; // -2.000
        #10;

        // �������� 3���е�����
        x_in = 12'sd1024;  // 1.0
        #10;

        // �������� 4���еȸ���
        x_in = -12'sd1024; // -1.0
        #10;

        // �������� 5���ǳ�С��ֵ�����㣩
        x_in = 12'sd16;    // ~0.0156
        #10;

        // �������� 6����С��ֵ
        x_in = -12'sd16;
        #100;

        // ���Խ���
        $display("Simulation complete.");
        $finish;
    end

endmodule
