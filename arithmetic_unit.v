
module arithmetic_unit #(parameter n = 16) (
input [n-1:0] a, b, // Input operands
input add_sub, // add_sub signal: 0 for addition, 1 for subtraction
output reg [n-1:0] out, // Output result
output reg carry_out
);
always @(*)
begin
    if (add_sub == 0) // Addition mode
        {carry_out,out} = a + b; // Perform addition
    else
    begin // Subtraction mode
        out = a - b; // Perform subtraction
        carry_out = 0; // No carry out in subtraction
    end
end
endmodule