module Pre #(
    parameter M = 4,                     // 输入整数位，最高位为符号位
    parameter N = 8                      // 输入小数位
)(
    input wire clk,
    input wire signed [M+N-1:0] x_in,    // 输入定点数（signed）
    output reg sign,                     // 输出符号位
    output reg signed [M+N-1:0] x_abs    // 输出定点数的绝对值
);

always @(posedge clk) begin
    sign <= x_in[M+N-1];                 // 记录符号位
    x_abs <= (x_in < 0) ? -x_in : x_in;  // 计算绝对值
end

endmodule
