//|===========================================================|
//| Module_name: comparator
//| author: Mohammed Aaftab
//| Description: This module implements a comparator for two inputs
//| It compares two inputs and provides outputs indicating equality, greater than, or less than.
//|===========================================================|
//| behaviour:
//| 1. The comparator takes two inputs and compares them.
//| 2. It outputs signals indicating whether the first input is equal to, greater than, or less than the second input.
//|===========================================================|
//| ports:
//| a: First input for comparison
//| b: Second input for comparison
//| a_gt_eq_b: Output signal indicating if in1 is greater than or equal to in2
//|===========================================================|

module comparator #(
    parameter width = 32
)(
    input [width-2:0] a, // First input for comparison
    input [width-2:0] b, // Second input for comparison
    output reg a_gt_eq_b // Output signal indicating if in1 is greater than or equal to in2
);
    always @(*)
    begin
         if(a>=b) begin a_gt_eq_b = 1;  end
        else begin a_gt_eq_b = 0; end
    end

endmodule