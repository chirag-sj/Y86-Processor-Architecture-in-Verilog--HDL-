module decode_reg (
    clk,
    D_stall, D_bubble,
    f_stat, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP,
    D_stat, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP
);
    input clk;

    input D_stall, D_bubble;

    input [2:0] f_stat;
    input [3:0] f_icode, f_ifun, f_rA, f_rB;
    input [63:0] f_valC, f_valP;

    output reg [2:0] D_stat;
    output reg [3:0] D_icode, D_ifun, D_rA, D_rB;
    output reg [63:0] D_valC, D_valP;

  

    always @(posedge clk ) begin
        if ((D_stall==1'b0) && (D_bubble==1'b0))
            begin    
                D_stat = f_stat;
                D_icode = f_icode;
                D_ifun = f_ifun;
                D_rA = f_rA;
                D_rB = f_rB;
                D_valC = f_valC;
                D_valP = f_valP;
            end
        else if (D_bubble==1'b1)
            begin
                D_stat  = 3'bx;
                D_icode = 4'bx;
                D_ifun  = 4'bx;
                D_rA    = 4'hF;
                D_rB    = 4'hF;
                D_valC  = 64'bx;
                D_valP  = 64'bx;
            end
    end
endmodule