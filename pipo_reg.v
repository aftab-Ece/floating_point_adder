//|===========================================================|
//| Module_name: pipo_reg   
//| author: Mohammed Aaftab
//| Description: This module implements a PIPO (Parallel In Parallel Out) register
//|              for storing a floating-point number with a sign bit, mantissa, and exponent
//|              and provides separate outputs for each component.
//|===========================================================|
//| behaviour:
//| 1. The register captures the input data on the rising edge of the clock when write_enable is high.
//| 2. The reset signal initializes the register to zero.
//| 3. The sign bit, mantissa, and exponent are outputted separately.
//|===========================================================|




module pipo_reg (
    input clk, // Clock signal to synchronize operations
    input reset, // Reset signal to initialize the register
    input write_enable,// Enable signal to allow writing to the register
    input [31:0] in, // Input data to be stored in the register
    output reg sign_bit, // Sign bit of the floating-point number
    output reg [22:0] mantissa, // Mantissa of the floating-point number
    output reg [7:0] exponent // Exponent of the floating-point number
);
reg [31:0] reg_data; // Internal register to hold the input data
    always @(posedge clk)
    begin
        if(reset)
            reg_data <= 32'b0; // Reset the register to zero
        else if(write_enable)
            reg_data <= in; // Capture input data on write enable
    end
    always @(*) begin
        sign_bit = reg_data[31]; // Extract the sign bit from the register
        mantissa = reg_data[22:0]; // Extract the mantissa from the register
        exponent = reg_data[30:23]; // Extract the exponent from the register
    end

endmodule