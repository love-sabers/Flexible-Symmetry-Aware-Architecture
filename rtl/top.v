module top #(//include the adder
    parameter M = 4,                     // 输入整数位，�?高位为符号位
    parameter N = 8,                      // 输入小数�?
    parameter FUNC_TYPE = 4             // 选择函数类型(Sigmoid,Tanh,Swish,GELU,Softplos)
)(
    input wire clk,
    input wire signed [M+N-1:0] x_in,    // 输入定点数（signed�?
    output wire signed [M+N-1:0] f_out    // 输出定点�?
);


wire sign;
wire [M+N-1:0] x_abs;

Pre #(
    .M(M),
    .N(N)
)pre_inst(
    .clk(clk),
    .x_in(x_in),
    .sign(sign),                     // 输出符号�?
    .x_abs(x_abs)    // 输出定点数的绝对�?
);

wire [M+N-1:0] s_out;
Sym #(
    .M(M),
    .N(N),
    .FUNC_TYPE(FUNC_TYPE)             // 0/1/2，�?�择功能类型(0,1,x)
)sym_inst(
    .clk(clk),
    .x_in(x_in),
    .sign(sign),                     // 输入符号�?
    .s_out(s_out)    // 输出定点数（绝对值或其他�?
);

wire [M+N-1:0] y_out;
PWL #(
    .M(M),
    .N(N),
    .U(8),
    .V(4),
    .K_WIDTH_I(4),
    .K_WIDTH_F(12),
    .B_WIDTH_I(4),
    .B_WIDTH_F(12)
) pwl_inst (
    .clk(clk),
    .x_in(x_abs),
    .y_out(y_out)
);

AxisTrans #(
    .M(M),
    .N(N),
    .FUNC_TYPE(FUNC_TYPE)             //选择功能类型(-,+)
)at_inst(
    .clk(clk),
    .f_in(y_out),
    .s_in(s_out),
    .f_out(f_out)    // 输出定点数（绝对值或其他�?
);

endmodule
