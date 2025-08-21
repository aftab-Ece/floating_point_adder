module controlled_incrementer (
    input clk, // Clock signal
    input flush,
    input [7:0] in, // Input value to be incremented
    input [4:0] increment_value, // Value to increment by
    input enable, // Enable signal for incrementing
    input increment_mode, // Mode for incrementing
    output reg [7:0] out // Output value after incrementing
);
always @(posedge clk or posedge flush) begin
    if (flush) begin
        out <= 8'b0; // Reset output to zero on flush
    end else if (enable) begin
        if (!increment_mode) begin
            out <= in +  1'b1; // Increment by the specified value
        end else begin
            out <= in - increment_value; // Decrement by the specified value
        end
    end
    else begin
        out <= in; // Maintain current value if not enabled
    end
end
endmodule