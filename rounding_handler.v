module rounding_handler(
    input [26:0] mantissa, // 27-bit mantissa input
    input [7:0] exp,
    output reg [30:0] rounded_exp_mantissa // 31-bit output for rounded exponent and mantissa
);
wire round_up = mantissa[2] & ((mantissa[1] | mantissa[0]) | mantissa[3]); // Determine if rounding up is needed
reg [7:0] exp_out; // Output exponent after rounding
reg carry_out; // Carry out signal for rounding
reg [23:0] intermediate_mantissa;
always @(*)
begin
    intermediate_mantissa= mantissa[26:3];
    {carry_out, intermediate_mantissa} = intermediate_mantissa+round_up; // Initialize rounded mantissa with the upper bits
    if(carry_out) begin
        intermediate_mantissa = {1'b1, intermediate_mantissa[23:1]}; // Shift right if carry out occurs
        exp_out = exp + 1; // Increment exponent if carry out occurs
    end
    else begin
        exp_out = exp; // Keep exponent unchanged if no carry out
    end
    rounded_exp_mantissa = {exp_out,intermediate_mantissa[22:0]}; // Assign the final rounded mantissa
end

endmodule