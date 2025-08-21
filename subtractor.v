module subtractor (
    input [7:0] a, // First input for subtraction
    input [7:0] b, // Second input for subtraction
    output reg [4:0] out // Output for the subtraction result
);
    reg [7:0] result; // Temporary variable to hold the subtraction result
    always @(*) begin
        if(a>=b)begin
            result=a-b;
        end
        else begin
            result=b-a;
        end
        if(result > 8'h1f)begin
            out = 5'b11111; // If result exceeds 31, set to maximum value
        end
        else begin
            out = result[4:0]; // Assign lower 5 bits of result to output
        end
    end
        
endmodule