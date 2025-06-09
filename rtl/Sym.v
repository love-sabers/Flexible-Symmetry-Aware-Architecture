module Sym #(
    parameter M = 4,                     // ��������λ�����λΪ����λ
    parameter N = 8,                     // ����С��λ
    parameter FUNC_TYPE = 0             // 0/1/2��ѡ��������(0,1,x)
)(
    input wire clk,
    input wire signed [M+N-1:0] x_in,    // ���붨������signed��
    input wire sign,                     // �������λ
    output reg signed [M+N-1:0] s_out    // ���������������ֵ��������
);

always @(posedge clk) begin
    case (FUNC_TYPE)
        0: s_out <= 0;
        1: s_out <= (sign == 0) ? 0 : (1 << N);
        default: s_out <= (sign == 0) ? 0 : x_in;
    endcase
end

endmodule
