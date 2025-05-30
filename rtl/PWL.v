module pwl_eval #(
    parameter M = 4,                     // 输入整数位
    parameter N = 8,                     // 输入小数位
    parameter U = 8,                     // 查表索引位宽（使用输入高 U 位）
    parameter V = 4,                     // 分段内小数参与位宽（使用输入低 V 位）
    parameter K_WIDTH_I = 4,             // k 整数位宽
    parameter K_WIDTH_F = 12,            // k 小数位宽
    parameter B_WIDTH_I = 4,             // b 整数位宽
    parameter B_WIDTH_F = 12             // b 小数位宽
)(
    input wire clk,
    input wire signed [M+N-1:0] x_in,   // 输入定点数（signed）
    output reg signed [M+N-1:0] y_out   // 输出定点数（裁剪）
);

    localparam K_WIDTH = K_WIDTH_I + K_WIDTH_F;
    localparam B_WIDTH = B_WIDTH_I + B_WIDTH_F;
    localparam Y_FULL_WIDTH = K_WIDTH + V + 1; // k_frac 临时结果位宽，+1 防溢出
    localparam Y_TOTAL_WIDTH = (Y_FULL_WIDTH > B_WIDTH ? Y_FULL_WIDTH : B_WIDTH) + 1;

    // ROM 存储结构：拼接 k 和 b
    reg [K_WIDTH + B_WIDTH - 1:0] rom [0:(1<<U)-1];

    initial begin
        $readmemh("pwl_func.mem", rom);  // 与 Python 输出的 .mem 对应
    end

    // 拆分输入：前 U 位用于查表，后 V 位用于乘法
    wire [U-1:0] idx  = x_in[M+N-1:M+N-U]; // 高 U 位
    wire [V-1:0] frac = x_in[V-1:0];       // 低 V 位

    // 寄存器中间值
    reg signed [K_WIDTH-1:0] k;
    reg signed [B_WIDTH-1:0] b;
    reg signed [K_WIDTH+V-1:0] k_frac;
    reg signed [Y_TOTAL_WIDTH-1:0] y_full;
    reg signed [M+N-1:0] y_temp;

    always @(posedge clk) begin
        {k, b} <= rom[idx];
        k_frac <= k * frac;                        // k * frac (Qk * Qv)
        y_full <= (k_frac >>> V) + b;              // (k * frac) >> V + b

        // y_full 的小数位是 B_WIDTH_F，与目标 N 位对齐
        // 若 B_WIDTH_F > N，右移截取；若 B_WIDTH_F < N，左移补零
        if (B_WIDTH_F > N)
            y_temp <= y_full >>> (B_WIDTH_F - N);
        else
            y_temp <= y_full <<< (N - B_WIDTH_F);

        y_out <= y_temp;
    end

endmodule
