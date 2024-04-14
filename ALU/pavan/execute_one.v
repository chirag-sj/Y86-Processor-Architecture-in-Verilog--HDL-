`include "stageone.v"
`include "ALU_64.v"

module execute (valE,icode,ifun,valA,valB,valC,clk);
input [3:0] icode,ifun;
input signed [63:0] valA,valB,valC;
input clk;
output signed [63:0] valE;
wire signed [63:0] alu_A,alu_B;
wire [3:0] alu_fun;
reg zf,sf,of,zero,sign;
wire overflow,set_cc;

stageone instant(icode,ifun,valA,valB,valC,alu_A,alu_B,alu_fun,set_cc); 
ALU_64 insta(alu_fun[1:0],alu_A,alu_B,valE,overflow);


 always @(posedge clk)
  begin

   if (valE==64'b0)
      zero=1'b0;
   else
      zero=1'b1;

   if (valE[63]==1'b1)
      sign=1'b1;
   else
      sign=1'b0;

   if (set_cc==1'b1)
     begin
     zf=zero;
     sf=sign;  
     of=overflow;
     end
   
 end
endmodule
    