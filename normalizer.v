module normalizer(
    input [26:0] mantissa, // 27-bit mantissa input
    input enable, shift_mode, // Enable signal and shift mode
    input [4:0] shift_amount, // Amount to shift
    output reg [26:0] normalized_mantissa // 26-bit normalized mantissa output
);
    reg sticky;
    // lsb is the sticky bit in input mantissa
    always @(*) begin
        sticky = 0; // Initialize sticky bit
        if (enable) begin
            if (!shift_mode) begin // Right shift mode
            sticky =mantissa [0] | mantissa [1] ; // sticky bit is the or of previous sticky and round bit
                normalized_mantissa = {1'b1,mantissa[26:1]}; // Perform right shift by 1 bit because in normalization, we shift the mantissa right by 1 bit if alu carry is generated
                normalized_mantissa[0] = sticky; // Assign sticky bit to the least significant bit
            end else begin // Left shift mode
                normalized_mantissa = mantissa << shift_amount; // Perform left shift
            end
        end else begin
            normalized_mantissa = mantissa; // Maintain current value if not enabled
        end
    end
endmodule