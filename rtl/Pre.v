module Pre #(
    parameter M = 4,                     // 输入整数位,最高位为符号位
    parameter N = 8                     // 输入小数位
)(
    input wire signed [M+N-1:0] x_in,   // 输入定点数（signed）
    output wire sign,//符号位
    output wire [M+N-1:0] x_out   // 输出定点数（裁剪掉符号位）
);

assign sign = x_in[M+N-1];   // 取最高位（符号位）
assign x_out = {1'b0, x_in[M+N-2:0]}; // 将符号位清零

endmodule
