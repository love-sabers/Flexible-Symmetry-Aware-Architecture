module Pre #(
    parameter M = 4,                     // ��������λ�����λΪ����λ
    parameter N = 8                      // ����С��λ
)(
    input wire clk,
    input wire signed [M+N-1:0] x_in,    // ���붨������signed��
    output reg sign,                     // �������λ
    output reg signed [M+N-1:0] x_abs    // ����������ľ���ֵ
);

always @(posedge clk) begin
    sign <= x_in[M+N-1];                 // ��¼����λ
    x_abs <= (x_in < 0) ? -x_in : x_in;  // �������ֵ
end

endmodule
