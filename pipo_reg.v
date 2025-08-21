//|===========================================================|
//| Module_name: pipo_reg   
//| author: Mohammed Aaftab
//| Description: This module implements a PIPO (Parallel In Parallel Out) register
//|| It captures a 32-bit input on the rising edge of the clock when write_enable is high
//| and outputs the sign bit, mantissa, and exponent of a floating-point number.
//|===========================================================|
//| behaviour:
//| 1. The register captures the input data on the rising edge of the clock when write_enable is high.
//| 2. The reset signal initializes the register to zero.
//| 3. The sign bit, mantissa, and exponent can be extracted from the input data.
//|===========================================================|




module pipo_register (
    input clk, // Clock signal to synchronize operations
    input reset, // Reset signal to initialize the register
    input write_enable,// Enable signal to allow writing to the register
    input [31:0] in, // Input data to be stored in the register
    output reg [31:0] out
);
    always @(posedge clk)
    begin
        if(reset)
            out <= 32'b0; // Reset the register to zero
        else if(write_enable)
            out <= in; // Capture input data on write enable
			else
			   out <= out;
    end

endmodule