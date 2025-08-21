module spl_case_handler(
    input [31:0] A,B, // Inputs A and B
    output reg spl_case,
    output reg [31:0] result
);
    wire NaN_A,NaN_B,infinity_A,infinity_B;

    assign NaN_A = (&A[30:23]) & |A[22:0]; // Check if A is NaN
    assign NaN_B = (&B[30:23]) & |B[22:0]; // Check if B is NaN
    assign infinity_A = (&A[30:23]) & ~|A[22:0]; // Check if A is infinity
    assign infinity_B = (&B[30:23]) & ~|B[22:0]; // Check if B is infinity
    assign zero_A=(A==0);
    assign zero_B=(B==0);
    always @(*)
    begin
        if (NaN_A || NaN_B)
        begin
            spl_case = 1; // Set spl_case for NaN
            result = 32'h7FC00000; // Result is NaN
        end
        else if (infinity_A && infinity_B)
        begin
            if( A[31] == B[31] ) 
            begin
                spl_case = 1; // Set spl_case for equal infinities
                result = A; // Result is the same infinity
            end 
            else 
            begin
                spl_case = 0; // Set spl_case for opposite infinities
                result = 32'h7FC00000; // Result is NaN
            end
        end
        else if (infinity_A || infinity_B)
        begin
            spl_case = 1; // Set spl_case for one infinity
            result = 32'h7F800000; // Result is the other infinity
        end
        // else if (zero_A && zero_B)
        // begin
        //     spl_case = 1; // Set spl_case for oboth zeros
        //     result = 32'h00000000; // Result is the 0
        // end
        
        
    end
endmodule