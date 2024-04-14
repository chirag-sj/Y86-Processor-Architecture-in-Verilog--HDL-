module testbench;
reg [2:0] M_stat;
reg [3:0] M_icode,M_dstE,M_dstM;
reg M_cnd;
reg [63:0] M_valE,M_valA;

wire [63:0] m_valM;
wire [2:0] m_stat;
wire [3:0] MM_icode;
wire [63:0] MM_valE;
wire [3:0] MM_dstE,MM_dstM;

memory uut (M_stat,M_icode,M_cnd,M_valE,M_valA,M_dstE,M_dstM,m_valM,m_stat,MM_icode,MM_valE,MM_dstE,MM_dstM);


initial
   begin
   $monitor("M_stat=%b,M_icode=%b,M_cnd=%b,M_valE=%d,M_valA=%d,M_dstE=%b,M_dstM=%b,m_valM=%d,m_stat=%d,MM_icode=%b,MM_valE=%d,MM_dstE=%b,MM_dstM=%b",M_stat,M_icode,M_cnd,M_valE,M_valA,M_dstE,M_dstM,m_valM,m_stat,MM_icode,MM_valE,MM_dstE,MM_dstM);
   
   #2 M_stat=2'b00;M_icode=4'b0100;M_cnd=1'bx;M_valE=64'd255;M_valA=64'd60;M_dstE=4'b0110;M_dstM=4'b0111;        //rmmovq
   #2 M_stat=2'b00;M_icode=4'b0101;M_cnd=1'bx;M_valE=64'd255;M_valA=64'd60;M_dstE=4'b0110;M_dstM=4'b0111;        //mrmovq
   #2 M_stat=2'b00;M_icode=4'b1010;M_cnd=1'bx;M_valE=64'd99;M_valA=64'd200;M_dstE=4'b0110;M_dstM=4'b0111;        //pushq
   #2 M_stat=2'b00;M_icode=4'b1011;M_cnd=1'bx;M_valE=64'd255;M_valA=64'd99;M_dstE=4'b0110;M_dstM=4'b0111;        //popq
   #2 M_stat=2'b00;M_icode=4'b1000;M_cnd=1'bx;M_valE=64'd2222;M_valA=64'd1111;M_dstE=4'b0110;M_dstM=4'b0111;     //call
   #2 M_stat=2'b00;M_icode=4'b1001;M_cnd=1'bx;M_valE=64'd159;M_valA=64'd2222;M_dstE=4'b0110;M_dstM=4'b0111;      //ret
   #2 $finish;
   end
endmodule