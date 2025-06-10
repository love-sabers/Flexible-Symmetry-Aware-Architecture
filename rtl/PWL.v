module PWL #(
    parameter M = 2,                     // ��������λ
    parameter N = 10,                     // ����С��λ
    parameter U = 8,                     // �������λ��ʹ������� U λ��
    parameter V = 4,                     // �ֶ���С������λ��ʹ������� V λ��
    parameter K_WIDTH_I = 4,             // k ����λ��
    parameter K_WIDTH_F = 12,            // k С��λ��
    parameter B_WIDTH_I = 4,             // b ����λ��
    parameter B_WIDTH_F = 12             // b С��λ��
)(
    input wire clk,
    input wire signed [M+N-1:0] x_in,   // ���붨������signed��
    output reg signed [M+N-1:0] y_out   // ������������ü���
);

    localparam K_WIDTH = K_WIDTH_I + K_WIDTH_F;
    localparam B_WIDTH = B_WIDTH_I + B_WIDTH_F;
    localparam Y_FULL_WIDTH = K_WIDTH + V + 1; // k_frac ��ʱ���λ��+1 �����
    localparam Y_TOTAL_WIDTH = (Y_FULL_WIDTH > B_WIDTH ? Y_FULL_WIDTH : B_WIDTH) + 1;

    // ROM �洢�ṹ��kǰb��
    reg [K_WIDTH + B_WIDTH - 1:0] rom [0:(1<<U)-1];

    initial begin
        $readmemh("D:\\Desktop\\Vivado\\work\\Flexible-Symmetry-Aware-Architecture\\parameter\\pwl_gelu_inputi0_inputf12_findLUT8_LinearCalc4_ki4kf12bi4bf12.mem", rom);  // �� Python ����� .mem ��Ӧ
    end

    // ������룺ǰ U λ���ڲ���� V λ���ڳ˷�
    wire [U-1:0] idx  = x_in[M+N-1:M+N-U]; // �� U λ
    wire signed [V:0] frac = {1'b0,x_in[V-1:0]};       // �� V λ

    // �Ĵ����м�ֵ
    reg signed [K_WIDTH-1:0] k;
    reg signed [B_WIDTH-1:0] b;
    reg signed [K_WIDTH+V-1:0] k_frac;
    reg signed [Y_TOTAL_WIDTH-1:0] y_full;
    reg signed [M+N-1:0] y_temp;

    always @(posedge clk) begin
        {k, b} <= rom[idx];
        k_frac <= k * frac;                        // k * frac (Qk * Qv)
        y_full <= (k_frac >>> V) + b;              // (k * frac) >> V + b

        // y_full ��С��λ�� B_WIDTH_F����Ŀ�� N λ����
        // �� B_WIDTH_F > N�����ƽ�ȡ���� B_WIDTH_F < N�����Ʋ���
        if (B_WIDTH_F > N)
            y_temp <= y_full >>> (B_WIDTH_F - N);
        else
            y_temp <= y_full <<< (N - B_WIDTH_F);

        y_out <= y_temp;

    end

endmodule
