`include "execute_pipe.v"


module testbench;
reg [2:0] E_stat;
reg [3:0] E_icode,E_ifun;
reg signed [63:0] E_valA,E_valB,E_valC;
reg [3:0] E_dstE,E_dstM,E_srcA,E_srcB;
wire signed [63:0] e_valE;
wire  e_cnd;
wire  [3:0] EE_icode,EE_dstM;
wire  [2:0] EE_stat;
wire  signed [63:0] EE_valA;
wire  [3:0] e_dstE;
wire zf,sf,of;

execute uut (E_stat,E_icode,E_ifun,E_valC,E_valA,E_valB,E_dstE,E_dstM,E_srcA,E_srcB,e_valE,e_cnd,EE_valA,e_dstE,EE_stat,EE_icode,EE_dstM,zf,sf,of);



initial
begin

$monitor("E_stat=%b,E_icode=%b,E_ifun=%b,E_valC=%d,E_valA=%d,E_valB=%d,E_dstE=%b,E_dstM=%b,E_srcA=%b,E_srcB=%b,e_valE=%d,e_cnd=%b,EE_valA=%d,e_dstE=%b,EE_stat=%b,EE_icode=%b,EE_dstM=%b,zf=%d,sf=%d,of=%d",E_stat,E_icode,E_ifun,E_valC,E_valA,E_valB,E_dstE,E_dstM,E_srcA,E_srcB,e_valE,e_cnd,EE_valA,e_dstE,EE_stat,EE_icode,EE_dstM,zf,sf,of);
#5   E_stat=2'b00;E_icode=4'b0110;E_ifun=4'b0001;E_valC=64'd256;E_valA=64'd100;E_valB=64'd200;E_dstE=4'b0110;E_dstM=4'b0001;E_srcA=4'b0010;E_srcB=4'b0111;  //subq
#10  E_stat=2'b00;E_icode=4'b0010;E_ifun=4'b0110;E_valC=64'dx;E_valA=64'd25;E_valB=64'd36;E_dstE=4'b0011;E_dstM=4'b0010;E_srcA=4'b0000;E_srcB=4'b0000;      //ccmovne
#10   E_stat=2'b00;E_icode=4'b0110;E_ifun=4'b0001;E_valC=64'd256;E_valA=64'd100;E_valB=64'd100;E_dstE=4'b0110;E_dstM=4'b0001;E_srcA=4'b0010;E_srcB=4'b0111; //subq
#10  E_stat=2'b00;E_icode=4'b0010;E_ifun=4'b0100;E_valC=64'dx;E_valA=64'd100;E_valB=64'd200;E_dstE=4'b0011;E_dstM=4'b0010;E_srcA=4'b0000;E_srcB=4'b0000;    //ccmovne
#10   E_stat=2'b00;E_icode=4'b0110;E_ifun=4'b0000;E_valC=64'd256;E_valA=64'd100;E_valB=64'd100;E_dstE=4'b0110;E_dstM=4'b0001;E_srcA=4'b0010;E_srcB=4'b0111; //addq
#10  E_stat=2'b00;E_icode=4'b0010;E_ifun=4'b0011;E_valC=64'dx;E_valA=64'd100;E_valB=64'd200;E_dstE=4'b0011;E_dstM=4'b0010;E_srcA=4'b0000;E_srcB=4'b0000;    //ccmove
#10   E_stat=2'b00;E_icode=4'b0100;E_ifun=4'b0000;E_valC=64'd256;E_valA=64'd100;E_valB=64'd100;E_dstE=4'b0110;E_dstM=4'b0001;E_srcA=4'b0010;E_srcB=4'b0111; //rmmovq
#10   E_stat=2'b00;E_icode=4'b0110;E_ifun=4'b0001;E_valC=64'd256;E_valA=64'd100;E_valB=64'd100;E_dstE=4'b0110;E_dstM=4'b0001;E_srcA=4'b0010;E_srcB=4'b0111; //subq
#10  E_stat=2'b00;E_icode=4'b0010;E_ifun=4'b0100;E_valC=64'dx;E_valA=64'd100;E_valB=64'd200;E_dstE=4'b0011;E_dstM=4'b0010;E_srcA=4'b0000;E_srcB=4'b0000;    //ccmovne
#10   E_stat=2'b00;E_icode=4'b0110;E_ifun=4'b0001;E_valC=64'd256;E_valA=64'd250;E_valB=64'd250;E_dstE=4'b0110;E_dstM=4'b0001;E_srcA=4'b0110;E_srcB=4'b0011; //xorq
#10  E_stat=2'b00;E_icode=4'b0010;E_ifun=4'b0100;E_valC=64'dx;E_valA=64'd100;E_valB=64'd200;E_dstE=4'b0011;E_dstM=4'b0010;E_srcA=4'b0000;E_srcB=4'b0000;    //ccmovne
#10  E_stat=2'b00;E_icode=4'b0110;E_ifun=4'b0000;E_valC=64'd256;E_valA=64'd200;E_valB=64'd300;E_dstE=4'b0110;E_dstM=4'b0001;E_srcA=4'b0010;E_srcB=4'b0111;  //addq
#10  E_stat=2'b00;E_icode=4'b0010;E_ifun=4'b0110;E_valC=64'dx;E_valA=64'd25;E_valB=64'd36;E_dstE=4'b0011;E_dstM=4'b0010;E_srcA=4'b0000;E_srcB=4'b0000;      //ccmovg
#10   E_stat=2'b00;E_icode=4'b0110;E_ifun=4'b0000;E_valC=64'd256;E_valA=64'd500;E_valB=64'd100;E_dstE=4'b0110;E_dstM=4'b0001;E_srcA=4'b0010;E_srcB=4'b0111; //addq
#10  E_stat=2'b00;E_icode=4'b0010;E_ifun=4'b0001;E_valC=64'dx;E_valA=64'd100;E_valB=64'd200;E_dstE=4'b0011;E_dstM=4'b0010;E_srcA=4'b0000;E_srcB=4'b0000;    //ccmovle


#10 $finish;
end

endmodule
