
module tb;
// testbench for fp_adder
reg [31:0] data_in; // Input data
reg reset, start, clk; // Control signals
wire [31:0] data_out; // Output data
wire finished; // Signal indicating completion of operation
fp_adder uut (
    .data_in(data_in),
    .reset(reset),
    .start(start),
    .clk(clk),
    .data_out(data_out),
    .finished(finished)
);


initial
begin
    clk = 0; // Initialize clock to 0
    forever #5 clk = ~clk; // Toggle clock every 5 time units 
end


initial begin
    #3; // Wait for a short time before starting the test
    reset = 1; // Assert reset
    start = 0; // Start signal is low
    data_in = 32'h00000000; // Initialize input data to zero
    #10; // Wait for 10 time units
    reset = 0; // Deassert reset
    start = 1; // Assert start signal
    #10; // Wait for 10 time units
    start=0; // Deassert start signal
    data_in = 32'h00000000; // Initialize input data to zero
    #10; // Wait for 10 time units
    data_in =32'h00000000 ;
    wait (finished); // Wait for the finish signal from the unit under test

    #13; // Wait for 10 time units to observe the output
    start = 1; // Assert start signal again
    #10; // Wait for 10 time units
    data_in =32'h7F7FFFFF; // Set input data to a new value
    start = 0; // Deassert start signal
    #10; // Wait for 10 time units
    data_in = 32'h7F7FFFFF;
    wait (finished); // Wait for the finish signal from the unit under test
    #10; // Wait for 10 time units to observe the output
    start = 1; // Assert start signal again
    #10; // Wait for 10 time units
    data_in = 32'h00800000; // Set input data to a new value
    start = 0; // Deassert start signal
    #10; // Wait for 10 time units
    data_in = 32'h80800000; // Set input data to a new value
    wait (finished); // Wait for the finish signal from the unit under test

    #10; // Wait for 10 time units to observe the output
    $finish; // End the simulation

end

initial begin
    // Monitor the outputs
    $monitor("Time: %0t, Data In: %h, Data Out: %h, Reset: %b, Start: %b ,finished: %b", 
             $time, data_in, data_out, reset, start, finished);
end

initial begin
    // Dump waveform data for analysis
    $dumpfile("fp_adder_tb.vcd");
    $dumpvars(0, tb);
end


endmodule