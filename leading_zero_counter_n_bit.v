module leading_zero_counter_n_bit #(
    parameter n = 28, // Default parameter for n-bit input
    parameter m = 5 // Default parameter for m-bit output
)
(
    input [n-1:0] in, // 16-bit input
    output reg [m-1:0] count, // 4-bit output for leading zero count
    output wire is_zero_out // Output signal indicating if input is zero
);
localparam groups = n>>2 ; // Number of 4-bit groups in n-bit input(n must be a multiple of 4)
wire [groups-1:0] is_zero; // Intermediate signal for zero detection
wire [1:0] count_4_bit [groups-1:0]; // 2-bit count from each 4-bit group
reg found; // Flag to indicate if a leading zero count is found
genvar i;
// Generate leading zero counters for each 4-bit group
generate for(i = 0; i <= groups-1; i = i+1)
begin : gen_lzc
    leading_zero_counter_4_bit lzc (
        .in(in[(i<<2)+3:(i<<2)]), // Select 4 bits for each instance
        .count(count_4_bit[i]), // Connect to the count output
        .is_zero(is_zero[i]) // Connect to the zero detection output
    );
end
endgenerate

assign is_zero_out = &is_zero; // Check if all nibbles are zero

integer j;
always @(*) begin
    count = {m{1'b0}}; // Default count to zero
    found = 0; // Reset the found flag
    if (is_zero_out) begin
        count = {m{1'b1}}; // If input is zero, set count to all ones
        found = 1; // Exit early if input is zero
    end
    // Iterate through the groups in reverse order to find the first non-zero group
    for (j = groups-1; j >= 0; j = j-1) begin
        if(!found && !is_zero[j]) begin
            count = ((groups - 1 - j) << 2) + count_4_bit[j];
            found = 1; // Set the flag to indicate a leading zero count is found
        end
    end
end
endmodule