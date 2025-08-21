module barrel_shifter #(
    parameter width = 24,
    parameter shift_width = 5
)
(
    input [width-1:0] in,
    input [shift_width-1:0] shift_amount,
    output reg [width+2:0] out

);
    reg[width+1:0] stage;
    reg sticky; // Sticky bit to indicate if any bits were shifted out
    always @(*) begin
        sticky=0;
        stage = {in, 2'b00};
        if(shift_amount[0])begin
            stage = {1'b0, stage[width+1:1]};
        end
        if(shift_amount[1])begin
            sticky= (|stage[1:0])|sticky; 
            stage = {2'b00, stage[width+1:2]};
        end
        if(shift_amount[2])begin
            sticky = (|stage[3:0])|sticky;
            stage = {4'b0000, stage[width+1:4]};
        end
        if(shift_amount[3])begin
            sticky = (|stage[7:0])|sticky;
            stage = {8'b00000000, stage[width+1:8]};
        end
        if(shift_amount[4])begin
            sticky = (|stage[15:0])|sticky;
            stage = {16'b0000000000000000, stage[width+1:16]};
        end
        out = {stage,sticky}; // Assign output

    end
endmodule