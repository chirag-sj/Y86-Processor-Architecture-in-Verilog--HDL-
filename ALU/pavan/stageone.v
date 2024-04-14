module stageone (icode,ifun,valA,valB,valC,alu_A,alu_B,alu_fun,set_cc);
input [3:0] icode,ifun;
input signed [63:0] valA,valB,valC;
output reg signed [63:0] alu_A,alu_B;
output reg [3:0] alu_fun;
output reg set_cc;

 initial begin

   
   if ((icode==4'b0010)||(icode==4'b0110))          //aluA
      alu_A=valA;

   else if((icode==4'b0011)||(icode==4'b0100)||(icode==4'b0101))
      alu_A=valC;

   else if((icode==4'b1000)||(icode==4'b1010))
      alu_A=-64'd8; 

   else if((icode==4'b1001)||(icode==4'b1011))
      alu_A=64'd8;


   
   if ((icode==4'b0010)||(icode==4'b0011))                  //aluB
      alu_B=64'b0;

   else if((icode==4'b0110)||(icode==4'b0100)||(icode==4'b0101)||(icode==4'b1011)||(icode==4'b1001)||(icode==4'b1010)||(icode==4'b1000))
      alu_B=valB;

   
   
   if (icode==4'b0110)                          //alu_fun   and set_cc                      
      begin
      set_cc=1'b1;
      alu_fun=ifun;
      end
   else
      begin
      alu_fun=4'b0000;
      set_cc=1'b0;
      end
 end

endmodule
   

   