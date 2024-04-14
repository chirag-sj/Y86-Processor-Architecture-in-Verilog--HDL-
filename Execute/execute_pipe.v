`include "ALU_64.v"


module execute(E_stat,E_icode,E_ifun,E_valC,E_valA,E_valB,E_dstE,E_dstM,E_srcA,E_srcB,e_valE,e_cnd,EE_valA,e_dstE,EE_stat,EE_icode,EE_dstM,zf,sf,of);
input [2:0] E_stat;
input [3:0] E_icode,E_ifun;
input signed [63:0] E_valA,E_valB,E_valC;
input [3:0] E_dstE,E_dstM,E_srcA,E_srcB;

output signed [63:0] e_valE;
output reg e_cnd;
output reg [3:0] EE_icode,EE_dstM;
output reg [2:0] EE_stat;
output reg signed [63:0] EE_valA;
output reg [3:0] e_dstE;
output reg  zf,sf,of;
reg signed [63:0] alu_A,alu_B;
reg [1:0] alu_fun;
reg set_cc;
wire overflow;

ALU_64 instant(alu_fun[1:0],alu_A,alu_B,e_valE,overflow); 


always @ (*)
begin
if (set_cc==1'b1)
    of = overflow;
end

always @(e_valE)
 begin
       if(set_cc==1'b1)
        begin
        if(e_valE==64'd0)
            zf=1'b1;
        else
            zf=1'b0;

        if(e_valE[63]==1'b1)
            sf=1'b1;
        else
            sf=1'b0;

        end



 end


always @(E_icode,E_valC,E_valA,E_valB,E_ifun)
begin
if((E_icode==4'b0010)||(E_icode==4'b0110))          //aluA
      alu_A = E_valA;

   else if((E_icode==4'b0011)||(E_icode==4'b0100)||(E_icode==4'b0101))
      alu_A = E_valC;

   else if((E_icode==4'b1000)||(E_icode==4'b1010))
      alu_A = -64'd8; 

   else if((E_icode==4'b1001)||(E_icode==4'b1011))
      alu_A = 64'd8;


if((E_icode==4'b0010)||(E_icode==4'b0011))                  //aluB
      alu_B = 64'b0;

   else if((E_icode==4'b0110)||(E_icode==4'b0100)||(E_icode==4'b0101)||(E_icode==4'b1011)||(E_icode==4'b1001)||(E_icode==4'b1010)||(E_icode==4'b1000))
      alu_B = E_valB;

    


if (E_icode==4'b0110)                          //alu_fun   and set_cc                      
      begin
      set_cc=1'b1;
      alu_fun=E_ifun;
      end
   else
      begin
      alu_fun=4'b0000;
      set_cc=1'b0;
      end

end
    always@(*)
    begin
          if((E_icode==4'b0010)||(E_icode==4'b0111))
          begin
              case(E_ifun)
              4'b0000:e_cnd<=1'b1;
              4'b0001:e_cnd<=(sf^of)|zf;
              4'b0010:e_cnd<=sf^of;
              4'b0011:e_cnd<=zf;
              4'b0100:e_cnd<=~zf;
              4'b0101:e_cnd<=~(sf^of);
              4'b0110:e_cnd<=~(sf^of)&~zf;
              endcase
              
          end

          else
          begin
          e_cnd=1'bx;
          e_dstE=E_dstE;
          end
          
    end

    always@(*)
    begin
             if (e_cnd==1'b0)
                 e_dstE=4'b1111;
              else if(e_cnd==1'b1)
                 e_dstE=E_dstE;
     end

     

    always@(E_stat,E_icode,E_dstM)
    begin
    EE_stat=E_stat;
    EE_icode=E_icode;
    EE_dstM=E_dstM;
    EE_valA=E_valA;
    end


endmodule