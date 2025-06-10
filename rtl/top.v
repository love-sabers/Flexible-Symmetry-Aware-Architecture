module top #(//include the adder
    parameter M = 2,                     // ��������λ�����λΪ����λ
    parameter N = 10,                      // ����С��
    parameter FUNC_TYPE = 4             // ѡ��������(Sigmoid,Tanh,Swish,GELU,Softplos)
)(
    input wire clk,
    input wire signed [M+N-1:0] x_in,    // ���붨������signed��
    output wire signed [M+N-1:0] f_out    // ���������
);


wire sign;
wire [M+N-1:0] x_abs;

Pre #(
    .M(M),
    .N(N)
)pre_inst(
    .clk(clk),
    .x_in(x_in),
    .sign(sign),                     // �������
    .x_abs(x_abs)    // ����������ľ���ֵ
);

wire [M+N-1:0] s_out;
Sym #(
    .M(M),
    .N(N),
    .FUNC_TYPE(FUNC_TYPE)             // 0/1/2��ѡ��������(0,1,x)
)sym_inst(
    .clk(clk),
    .x_in(x_in),
    .sign(sign),                     // �������
    .s_out(s_out)    // ���������������ֵ��������
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
    .FUNC_TYPE(FUNC_TYPE)             //ѡ��������(-,+)
)at_inst(
    .clk(clk),
    .f_in(y_out),
    .s_in(s_out),
    .f_out(f_out)    // ���������
);

endmodule
