module memory_reg (
    clk,
    M_bubble,
    e_stat, e_icode, e_CND, e_valE, e_valA, e_dstE, e_dstM,
    M_stat, M_icode, M_CND, M_valE, M_valA, M_dstE, M_dstM
);

input clk;

input M_bubble;
input [2:0] e_stat;
input [3:0] e_icode;
input e_CND;
input [63:0] e_valE, e_valA;
input [3:0] e_dstE, e_dstM;

output reg [2:0] M_stat;
output reg [3:0] M_icode;
output reg M_CND;
output reg [63:0] M_valE, M_valA;
output reg [3:0] M_dstE, M_dstM;



always @(posedge clk) begin
    if (M_bubble==1'b0) 
    begin
        M_stat  = e_stat;
        M_icode = e_icode;
        M_CND   = e_CND;
        M_valE  = e_valE;
        M_valA  = e_valA;
        M_dstE  = e_dstE;
        M_dstM  = e_dstM;
    end
    else if (M_bubble==1'b1)
    begin
        M_stat  = 3'bx;
        M_icode = 4'bx;
        M_CND   = 1'bx;
        M_valE  = 64'bx;
        M_valA  = 64'bx;
        M_dstE  = 4'hF;
        M_dstM  = 4'hF;
    end
end

endmodule