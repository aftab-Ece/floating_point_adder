module datapath(
    input clk,add_sub,load_a,load_b,sel_larger,sel_result,load_result,flush_exp,normalize_enable,normalize_mode,op_sign,
    input [31:0] data_in,
    output wire sign_a,sign_b,a_gt_eq_b,eqz,alu_carry,spl_case,lzc_flag,
    output [31:0] data_out
);
wire [31:0] a,b,result,spl_result;
wire [23:0] mantissa_a, mantissa_b,larger_mantissa, smaller_mantissa;
wire [30:0] rounded_exp_mantissa;
wire [7:0] exp_a, exp_b, exp_out,exp_larger;
wire [22:0] rounded_mantissa;
wire [4:0] exp_diff;
wire [26:0] alu_out,aligned_mantissa,normalized_mantissa;
wire [4:0] lzc;

assign sign_a = a[31]; // Sign bit of A
assign sign_b = b[31]; // Sign bit of B
assign mantissa_a = {1'b1,a[22:0]}; // Mantissa of A
assign mantissa_b = {1'b1,b[22:0]}; // Mantissa of B
assign exp_a = a[30:23]; // Exponent of A
assign exp_b = b[30:23]; // Exponent of B
// module instantiations
pipo_register pipo_a(
    .clk(clk),
    .write_enable(load_a),
    .in(data_in),
    .out(a)
);
pipo_register pipo_b(
    .clk(clk),
    .write_enable(load_b),
    .in(data_in),
    .out(b)
);
subtractor sub(
    .a(exp_a),
    .b(exp_b),
    .out(exp_diff)
);
comparator #(.width(32)) comp(
    .a(a[30:0]),
    .b(b[30:0]),
    .a_gt_eq_b(a_gt_eq_b)
);
spl_case_handler spl_case_handler_inst(
    .A(a),
    .B(b),
    .spl_case(spl_case),
    .result(spl_result)
);
mux #(.width(8)) exp_mux(
    .sel(sel_larger),
    .a(exp_a),
    .b(exp_b),
    .out(exp_larger)
);
mux #(.width(24)) mantissa_larger_mux(
    .sel(sel_larger),
    .a(mantissa_a),
    .b(mantissa_b),
    .out(larger_mantissa)
);
mux #(.width(24)) mantissa_smaller_mux(
    .sel(sel_larger),
    .a(mantissa_b),
    .b(mantissa_a),
    .out(smaller_mantissa)
);
barrel_shifter barrel_shifter_inst(
    .in(smaller_mantissa),
    .shift_amount(exp_diff),
    .out(aligned_mantissa)
);
arithmetic_unit #(.n(27)) alu(
    .a({larger_mantissa, 3'b000}), // Append 3 zeros to the larger mantissa
    .b(aligned_mantissa),
    .add_sub(add_sub),
    .out(alu_out),
    .carry_out(alu_carry)
);
leading_zero_counter_n_bit #(.n(28),.m(5)) lzc_counter(
    .in({alu_out[26:0],1'b0}), // Count leading zeros in the 27-bit output 0 is appended to make it 28 bits as leading zero counter is 28 bits
    .count(lzc),
    .is_zero_out(eqz) // Output signal indicating if the input is zero
);
controlled_incrementer controlled_incrementer_inst(
    .clk(clk),
    .flush(flush_exp),
    .in(exp_larger),
    .increment_value(lzc), 
    .enable(normalize_enable),
    .increment_mode(normalize_mode),
    .out(exp_out)
);
normalizer normalizer_inst(
    .mantissa(alu_out[26:0]),
    .enable(normalize_enable),
    .shift_mode(normalize_mode),
    .shift_amount(lzc),
    .normalized_mantissa(normalized_mantissa)
);
rounding_handler rounding_handler_inst(
    .mantissa(normalized_mantissa),
    .exp(exp_out),
    .rounded_exp_mantissa(rounded_exp_mantissa)
);
mux #(.width(32)) result_mux(
    .sel(sel_result),
    .a({op_sign,rounded_exp_mantissa}), // Sign bit and rounded exponent
    .b(spl_result),
    .out(result)
);
pipo_register result_register(
    .clk(clk),
    .write_enable(load_result),
    .in(result),
    .out(data_out)
);
endmodule