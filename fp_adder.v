module fp_adder(
    input [31:0] data_in,
    input clk,reset,start, // Clock, reset, and start signals
    output [31:0] data_out,
    output finished
);
wire add_sub,load_a,load_b,sel_larger,sel_result,load_result,flush_exp,normalize_enable,normalize_mode,op_sign,
    sign_a,sign_b,a_gt_eq_b,eqz,alu_carry,spl_case;
// module instantiations
controller ctrl(
    .clk(clk),
    .reset(reset),
    .sign_a(sign_a),
    .sign_b(sign_b),
    .a_gt_eq_b(a_gt_eq_b),
    .eqz(eqz),
    .alu_carry(alu_carry),
    .spl_case(spl_case),
    .start(start),
    .add_sub(add_sub),
    .load_a(load_a),
    .load_b(load_b),
    .sel_larger(sel_larger),
    .sel_result(sel_result),
    .load_result(load_result),
    .flush_exp(flush_exp),
    .normalize_enable(normalize_enable),
    .normalize_mode(normalize_mode),
    .op_sign(op_sign),
    .finished(finished)
);
datapath dp(
    .clk(clk),
    .add_sub(add_sub),
    .load_a(load_a),
    .load_b(load_b),
    .sel_larger(sel_larger),
    .sel_result(sel_result),
    .load_result(load_result),
    .flush_exp(flush_exp),
    .normalize_enable(normalize_enable),
    .normalize_mode(normalize_mode),
    .op_sign(op_sign),
    .data_in(data_in),
    .sign_a(sign_a),
    .sign_b(sign_b),
    .a_gt_eq_b(a_gt_eq_b),
    .eqz(eqz),
    .alu_carry(alu_carry),
    .spl_case(spl_case),
    .data_out(data_out)
);
endmodule