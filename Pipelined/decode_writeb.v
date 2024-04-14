module decode_wb (
D_stat, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, 
e_dstE, e_valE, 
M_dstE, M_valE, M_dstM, m_valM, 
W_dstM, W_valM, W_dstE, W_valE, W_stat, W_icode,
d_stat,d_icode, d_ifun, d_valC, d_valA, d_valB, d_dstE, d_dstM, d_srcA, d_srcB,
rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14,r15
);

//decode input
//D reg
input [2:0] D_stat;
input [3:0] D_icode, D_ifun;
input [3:0] D_rA, D_rB;
input [63:0] D_valC, D_valP;
//bypass path
input [3:0] e_dstE, M_dstE, M_dstM;
input [3:0] W_dstM, W_dstE; //w_reg
input [63:0] e_valE, M_valE, m_valM;
input [63:0] W_valM, W_valE; //w_reg
//decode wires
reg [63:0] d_rvalA, d_rvalB;
//decode output
//E reg
output reg [2:0] d_stat;
output reg [3:0] d_icode, d_ifun;
output reg [63:0] d_valC, d_valA, d_valB;
output reg [3:0] d_dstE, d_dstM, d_srcA, d_srcB;
//writeback
//input
input [2:0] W_stat;
input [3:0] W_icode;
//register file
output reg [63:0] rax;
output reg [63:0] rcx;
output reg [63:0] rdx;
output reg [63:0] rbx;
output reg [63:0] rsp;
output reg [63:0] rbp;
output reg [63:0] rsi;
output reg [63:0] rdi;
output reg [63:0] r8 ;
output reg [63:0] r9 ;
output reg [63:0] r10;
output reg [63:0] r11;
output reg [63:0] r12;
output reg [63:0] r13;
output reg [63:0] r14;
output reg [63:0] r15;


    //decode
    always @(*) begin
    //d_srcA
    if (( (D_icode==4'b0010) || (D_icode==4'b0100) ) || ( (D_icode==4'b0110) || (D_icode==4'b1010) ))
        begin
            d_srcA<=D_rA;
        end
    else if( (D_icode==4'b1001) || (D_icode==4'b1011))
        begin
            d_srcA<=4'h4;
        end
    else
        begin
            d_srcA<=4'hF;
        end

    //d_srcB

    if ( (D_icode==4'b0110)||((D_icode==4'b0100)||(D_icode==4'b0101)))
        begin
            d_srcB<=D_rB;
        end
    else if(( (D_icode==4'b1010)||(D_icode==4'b1011) )||((D_icode==4'b1000)||(D_icode==4'b1001)))
        begin
            d_srcB<=4'h4;
        end
    else
        d_srcB<=4'hF;
/////////////////////////
    //d_dstE 
    if ( (D_icode==4'b0011) ||(D_icode==4'b0110) || (D_icode==4'h2))
        d_dstE<=D_rB;
    else if(((D_icode==4'b1010)||(D_icode==4'b1011))||((D_icode==4'b1000)||(D_icode==4'b1001)))
        d_dstE<=4'h4;
    else
        d_dstE=4'hF;

    //d_dstM
    if ((D_icode==4'b0101)||(D_icode==4'b1011))
        d_dstM<=D_rA;
    else
        d_dstM<=4'hF;
/////////////////////////
    //reg file
        case (d_srcA)
        4'h0:d_rvalA <= rax;
        4'h1:d_rvalA <= rcx;
        4'h2:d_rvalA <= rdx;
        4'h3:d_rvalA <= rbx;
        4'h4:d_rvalA <= rsp;
        4'h5:d_rvalA <= rbp;
        4'h6:d_rvalA <= rsi;
        4'h7:d_rvalA <= rdi;
        4'h8:d_rvalA <= r8 ;
        4'h9:d_rvalA <= r9 ;
        4'hA:d_rvalA <= r10;
        4'hB:d_rvalA <= r11;
        4'hC:d_rvalA <= r12;
        4'hD:d_rvalA <= r13;
        4'hE:d_rvalA <= r14;
        default: r15 <= 64'hF;
    endcase
    case (d_srcB)
        4'h0:d_rvalB <= rax;
        4'h1:d_rvalB <= rcx;
        4'h2:d_rvalB <= rdx;
        4'h3:d_rvalB <= rbx;
        4'h4:d_rvalB <= rsp;
        4'h5:d_rvalB <= rbp;
        4'h6:d_rvalB <= rsi;
        4'h7:d_rvalB <= rdi;
        4'h8:d_rvalB <= r8 ;
        4'h9:d_rvalB <= r9 ;
        4'hA:d_rvalB <= r10;
        4'hB:d_rvalB <= r11;
        4'hC:d_rvalB <= r12;
        4'hD:d_rvalB <= r13;
        4'hE:d_rvalB <= r14;
        default: r15 <= 64'hF;
    endcase
    
    //sel+fwd A

    if ((D_icode==4'b1000)||(D_icode==4'b0111)) begin
        d_valA = D_valP;
    end
    else begin
        case (d_srcA)
            e_dstE: d_valA = e_valE;
            M_dstM: d_valA = m_valM;
            M_dstE: d_valA = M_valE;
            W_dstM: d_valA = W_valM;
            W_dstE: d_valA = W_valE;
            default:d_valA = d_rvalA;
        endcase
    end

    //Fwd B

    begin
        case (d_srcB)
            e_dstE: d_valB = e_valE;
            M_dstM: d_valB = m_valM;
            M_dstE: d_valB = M_valE;
            W_dstM: d_valB = W_valM;
            W_dstE: d_valB = W_valE;
            default:d_valB = d_rvalB;
        endcase
    end

    //Reg assign
    d_stat = D_stat;
    d_icode = D_icode;
    d_ifun = D_ifun;
    d_valC = D_valC;
    end

    //writeback
    always @(*) begin
        
            //reg file
            case (W_dstM)
                4'h0:rax <= W_valM;
                4'h1:rcx <= W_valM;
                4'h2:rdx <= W_valM;
                4'h3:rbx <= W_valM;
                4'h4:rsp <= W_valM;
                4'h5:rbp <= W_valM;
                4'h6:rsi <= W_valM;
                4'h7:rdi <= W_valM;
                4'h8:r8  <= W_valM;
                4'h9:r9  <= W_valM;
                4'hA:r10 <= W_valM;
                4'hB:r11 <= W_valM;
                4'hC:r12 <= W_valM;
                4'hD:r13 <= W_valM;
                4'hE:r14 <= W_valM;
                default: r15 <= 64'hF;
            endcase
            case (W_dstE)
                4'h0:rax <= W_valE;
                4'h1:rcx <= W_valE;
                4'h2:rdx <= W_valE;
                4'h3:rbx <= W_valE;
                4'h4:rsp <= W_valE;
                4'h5:rbp <= W_valE;
                4'h6:rsi <= W_valE;
                4'h7:rdi <= W_valE;
                4'h8:r8  <= W_valE;
                4'h9:r9  <= W_valE;
                4'hA:r10 <= W_valE;
                4'hB:r11 <= W_valE;
                4'hC:r12 <= W_valE;
                4'hD:r13 <= W_valE;
                4'hE:r14 <= W_valE;
                default: r15 <= 64'hF;
            endcase
    end

endmodule