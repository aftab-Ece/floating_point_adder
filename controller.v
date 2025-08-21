module controller (
    input clk,reset,sign_a,sign_b,a_gt_eq_b,eqz,alu_carry,spl_case,start,lzc_flag,
    output reg add_sub,load_a,load_b,sel_larger,sel_result,load_result,flush_exp,normalize_enable,normalize_mode,op_sign,finished
);
localparam state_idle = 3'b000,
              state_load_a = 3'b001,
              state_load_b = 3'b010,
              state_align_and_aluop = 3'b011,
              state_normalize_round = 3'b100, 
              state_output = 3'b101,
              state_finish = 3'b110;
reg [2:0] state;
always @(posedge clk or posedge reset) begin
    if(reset) state <= state_idle;
    else begin
        case(state)
            state_idle: begin
                if(start) state <= state_load_a; // Transition to load A state on start signal
            end
            state_load_a: state <= state_load_b; // Transition to load B state after loading A
            state_load_b: state <= state_align_and_aluop; // Transition to compare state after loading B
            state_align_and_aluop: begin
                if(spl_case) state <= state_output;
                else state <= state_normalize_round; // If special case, go to output, else normalize
            end
            state_normalize_round: state <= state_output; // Transition to output state after normalization
            state_output: state <= state_finish; // Transition to finish state after output
            state_finish: begin
                if(start) state <= state_load_a; // If start is asserted again, go back to load A state
                else state <= state_finish; // Otherwise, stay in finish state
            end
        endcase
    end
end
    always @(*) begin
        case(state)
            state_idle: begin load_a=0; load_b=0; sel_larger=0; add_sub=0; sel_result=0; load_result=0; flush_exp=0; normalize_enable=0; normalize_mode=0; op_sign=0; finished=0; end
            state_load_a: begin load_a=1; load_b=0; sel_larger=0; add_sub=0; sel_result=0; load_result=0; flush_exp=0; normalize_enable=0; normalize_mode=0; op_sign=0; finished=0; end
            state_load_b: begin load_b=1; load_a=0; end
            state_align_and_aluop: begin
                load_b=0;
                case({sign_a,sign_b})
                    2'b00: begin add_sub=0; op_sign=0; end // Both positive
                    2'b01: begin add_sub=1; op_sign=1; end // A positive, B negative
                    2'b10: begin add_sub=1; op_sign=0; end // A negative, B positive
                    2'b11: begin add_sub=0; op_sign=1; end // Both negative
                endcase
                sel_larger = (a_gt_eq_b) ? 0 : 1;
            end
            state_normalize_round: begin 
                
                 if(alu_carry) begin normalize_enable=1; normalize_mode=0; end
                 else if(eqz) begin flush_exp=1; end
                else begin normalize_enable=1; normalize_mode=1; end
                if(eqz) op_sign=0;
                else if(a_gt_eq_b) op_sign=sign_a; // Use sign of A if A >= B
                else op_sign=sign_b; // Use sign of B if A < B
             end
             state_output:begin
                if(spl_case) begin
                    sel_result=1; // Select special case result
                end else begin
                    sel_result=0; // Select normal result
                end
                
                load_result=1; // Load result into output
                flush_exp=0; // Do not flush exponent in output state
            end
            state_finish: begin
                load_result=0; // Reset load result signal
                normalize_enable=0; // Disable normalization
                finished=1; // Indicate that the operation is finished
            end
        endcase
    end
endmodule