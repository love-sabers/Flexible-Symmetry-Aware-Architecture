module AxisTrans #(//include the adder
    parameter M = 4,                     // ��������λ�����λΪ����λ
    parameter N = 8,                      // ����С��λ
    parameter FUNC_TYPE = 0             // 0/1��ѡ��������(-,+)
)(
    input wire clk,
    input wire signed [M+N-1:0] f_in,    // ���붨������signed��
    input wire signed [M+N-1:0] s_in,                  // �������λ
    output reg signed [M+N-1:0] f_out    // ����������ľ���ֵ
);

always @(posedge clk) begin
    case (FUNC_TYPE)
        0: f_out <= s_in-f_in;
        1: f_out <= s_in-f_in;
        default: f_out <= s_in+f_in;
    endcase
end

endmodule
