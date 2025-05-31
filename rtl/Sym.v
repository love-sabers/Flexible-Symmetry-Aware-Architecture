module Sym #(
    parameter M = 4,                     // 输入整数位，最高位为符号位
    parameter N = 8,                     // 输入小数位
    parameter FUNC_TYPE = 0             // 0/1/2，选择功能类型
)(
    input wire clk,
    input wire signed [M+N-1:0] x_in,    // 输入定点数（signed）
    input wire sign,                     // 输入符号位
    output reg signed [M+N-1:0] s_out    // 输出定点数（绝对值或其他）
);

always @(posedge clk) begin
    case (FUNC_TYPE)
        0: s_out <= 0;
        1: s_out <= (sign == 0) ? 0 : (1 << N);
        2: s_out <= (sign == 0) ? 0 : x_in;
        default: s_out <= 0;
    endcase
end

endmodule
