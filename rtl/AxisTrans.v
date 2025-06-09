module AxisTrans #(//include the adder
    parameter M = 4,                     // 输入整数位，最高位为符号位
    parameter N = 8,                      // 输入小数位
    parameter FUNC_TYPE = 0             // 0/1，选择功能类型(-,+)
)(
    input wire clk,
    input wire signed [M+N-1:0] f_in,    // 输入定点数（signed）
    input wire signed [M+N-1:0] s_in,                  // 输出符号位
    output reg signed [M+N-1:0] f_out    // 输出定点数的绝对值
);

always @(posedge clk) begin
    case (FUNC_TYPE)
        0: f_out <= s_in-f_in;
        1: f_out <= s_in-f_in;
        default: f_out <= s_in+f_in;
    endcase
end

endmodule
