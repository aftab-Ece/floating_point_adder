`timescale 1ns / 1ps;
module tb;
parameter width = 24;
parameter shift_width = 5;
reg [width-1:0] in;
reg [shift_width-1:0] shift_amount;
wire [width+1:0] out;
wire sticky;
barrel_shifter #(
    .width(width),
    .shift_width(shift_width)
) uut (
    .in(in),
    .shift_amount(shift_amount),
    .out(out),
    .sticky(sticky)
);
initial 
begin
    // test case 1: shift by 1
    in = 24'h123456;
    shift_amount = 5'b00001;
    #10;
    // test case 2: shift by 10
    in = 24'h123456;
    shift_amount = 5'b01010;
    #10;
    // test case 3: shift by 24
    in = 24'h123456;
    shift_amount = 5'b11000;
    #10;
    // test case 4: shift by 25
    in = 24'h123456;
    shift_amount = 5'b11001;
    #10;
    // test case 5: shift by 30
    in = 24'h123456;
    shift_amount = 5'b11110;
    #10;
    // test case 6: shift by 3
    in = 24'hffffff;
    shift_amount = 5'b00011;
    #10;
    $finish; // End the simulation
end
initial begin
    $monitor("Time: %0t, in: %h, shift_amount: %b, out: %h, GRS: %b , sticky:%b", $time, in, shift_amount, out[width+1:2], out[1:0], sticky);
end
initial begin
    $dumpfile("barrel_shifter.vcd");
    $dumpvars(0, tb);
end


endmodule