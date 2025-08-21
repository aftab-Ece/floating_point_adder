module leading_zero_counter_4_bit(
    input [3:0] in, // 4-bit input
    output reg [1:0] count, // 2-bit output for leading zero count
    output wire is_zero // Output signal indicating if input is zero
);

assign is_zero = (in == 4'b0000); // Check if input is zero
always @(*)
begin
    casez (in) 
        4'b0001: count = 2'b11; // three leading zero
        4'b001?: count = 2'b10; // Two leading zeros
        4'b01??: count = 2'b01; // One leading zero
        4'b1???: count = 2'b00; // No leading zeros
        default: count = 2'b00; // Default case
    endcase
end
endmodule