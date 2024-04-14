module pipe_control (
    D_icode, d_srcA, d_srcB, E_icode, E_dstM, e_CND, M_icode, m_stat, W_stat,
    F_stall, D_stall, D_bubble, E_bubble, M_bubble, W_stall
);
input [3:0] D_icode, d_srcA, d_srcB, E_icode, E_dstM, M_icode; 
input e_CND;
input [2:0] m_stat, W_stat;
output reg F_stall,D_stall, D_bubble, E_bubble, set_cc, M_bubble, W_stall;

initial 
begin
F_stall=1'b0;
D_stall=1'b0;
D_bubble=1'b0; 
E_bubble=1'b0;
M_bubble=1'b0;
W_stall=1'b0;
end

always @(*) begin

//bool F_stall =
//      # Conditions for a load/use hazard
//      E_icode in { MRMOVQ, POPQ } &&
//      E_dstM in { d_srcA, d_srcB } ||
//      # Stalling at fetch while ret passes through pipeline
//      IRET in { D_icode, E_icode, M_icode };

    if ((((E_icode == 4'h5)||(E_icode == 4'hB))&&((E_dstM == d_srcA)||(E_dstM == d_srcB)))||((D_icode==4'h9)||(E_icode==4'h9)||(M_icode==4'h9)))
        F_stall = 1'b1;
    else 
        F_stall=1'b0;

//bool D_stall =
//      # Conditions for a load/use hazard
//      E_icode in { IMRMOVQ, IPOPQ } &&
//      E_dstM in { d_srcA, d_srcB };

    if (((E_icode == 4'h5)||(E_icode == 4'hB))&&((E_dstM == d_srcA)||(E_dstM == d_srcB)))
        D_stall = 1'b1;
    else 
        D_stall = 1'b0;
//bool D_bubble =
//        # Mispredicted branch
//        (E_icode == IJXX && !e_Cnd) ||
//        # Stalling at fetch while ret passes through pipeline
//        # but not condition for a load/use hazard
//        !(E_icode in { MRMOVQ, POPQ } && E_dstM in { d_srcA, d_srcB }) &&
//        IRET in { D_icode, E_icode, M_icode };

    if (((E_icode==4'h7)&&(e_CND==1'b0))||
    (( (((E_icode==4'h5)||(E_icode==4'hB)) && ((E_dstM == d_srcA)||(E_dstM == d_srcB))) )==1'b0)
    &&((D_icode==4'h9)||(E_icode==4'h9)||(M_icode==4'h9)))
        D_bubble = 1'b1;
    else 
        D_bubble = 1'b0; 

//bool E_bubble =
//      # Mispredicted branch
//      (E_icode == IJXX && !e_Cnd) ||
//      # Conditions for a load/use hazard
//      E_icode in { IMRMOVQ, IPOPQ } &&
//      E_dstM in { d_srcA, d_srcB};

    if(((E_icode==4'h7)&&(e_CND==1'b0))||(((E_icode == 4'h5)||(E_icode == 4'hB))&&((E_dstM == d_srcA)||(E_dstM == d_srcB))))
        E_bubble = 1'b1;
    else
        E_bubble = 1'b0;

//bool set_cc = 
//      E_icode == OPQ &&
//      # State changes only during normal operation
//      !m_stat in { SADR, SINS, SHLT } && !W_stat in { SADR, SINS, SHLT }; 
        
   // if((E_icode==4'h6)&&(((m_stat==3'h2)||(m_stat==3'h3)||(m_stat==3'h4))==0)&&(((W_stat==3'h2)||(W_stat==3'h3)||(W_stat==3'h4))==0))
   //     set_cc = 1'b1;
   // else 
   //     set_cc = 1'b0;

//bool M_bubble = m_stat in { SADR, SINS, SHLT } || W_stat in { SADR, SINS, SHLT };

    if(((m_stat==3'h2)||(m_stat==3'h3)||(m_stat==3'h4)) || ((W_stat==3'h2)||(W_stat==3'h3)||(W_stat==3'h4)))
        M_bubble = 1'b1;
    else 
        M_bubble = 1'b0;

//bool W_stall = W_stat in { SADR, SINS, SHLT };
    
    if ((W_stat==3'h2)||(W_stat==3'h3)||(W_stat==3'h4))
        W_stall = 1'b1;
    else
        W_stall = 1'b0;
end
endmodule