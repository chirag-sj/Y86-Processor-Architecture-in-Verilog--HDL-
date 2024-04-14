module decowb_tb;

//decode reg
//D reg
reg [2:0] D_stat;
reg [3:0] D_icode, D_ifun;
reg [3:0] D_rA, D_rB;
reg [63:0] D_valC, D_valP;
//bypass path
reg [3:0] e_dstE, M_dstE, M_dstM;
reg [3:0] W_dstM, W_dstE; //w_reg
reg [63:0] e_valE, M_valE, m_valM;
reg [63:0] W_valM, W_valE; //w_reg
//decode wires
reg [63:0] d_rvalA, d_rvalB;
//decode wire
//E reg
wire [2:0] d_stat;
wire [3:0] d_icode, d_ifun;
wire [63:0] d_valC, d_valA, d_valB;
wire [3:0] d_dstE, d_dstM, d_srcA, d_srcB;
//writeback inputs
reg [2:0] W_stat;
reg [3:0] W_icode;

wire [63:0] rax;
wire [63:0] rcx;
wire [63:0] rdx;
wire [63:0] rbx;
wire [63:0] rsp;
wire [63:0] rbp;
wire [63:0] rsi;
wire [63:0] rdi;
wire [63:0] r8 ;
wire [63:0] r9 ;
wire [63:0] r10;
wire [63:0] r11;
wire [63:0] r12;
wire [63:0] r13;
wire [63:0] r14;
wire [63:0] r15;

decode_wb uut (
D_stat, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, 
e_dstE, e_valE, 
M_dstE, M_valE, M_dstM, m_valM, 
W_dstM, W_valM, W_dstE, W_valE, W_stat, W_icode,
d_stat,d_icode, d_ifun, d_valC, d_valA, d_valB, d_dstE, d_dstM, d_srcA, d_srcB,
rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14,r15
);

initial
  begin
  //$dumpfile("decode_tb.vcd");
  //$dumpvars(0,decode_tb);
  $monitor($time,"rax = %d,rcx = %d,rdx = %d,rbx = %d,rsp = %d,rbp = %d,rsi = %d,rdi = %d,r8 = %d,r9 = %d,r10 = %d,r11 = %d,r12 = %d,r13 = %d,r14 = %d,r15 = %d,d_valA=%d,d_valB=%d, d_stat = %b",rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14,r15, d_valA, d_valB, d_stat);

  //call inst=> rsp = W_valE
  //irmove => rdi = 67
  #5 W_stat = 3'b001; D_icode = 4'b0101; D_ifun = 4'b0000; D_rA = 4'b0000; D_rB = 4'b0001; D_valC = 64'd99; D_valP = 64'd77; 
  e_dstE = 4'b0010; e_valE = 64'd66; 
  M_dstE = 4'b0011; M_valE = 64'd33; M_dstM = 4'b0101; m_valM = 64'd11;
  W_dstM = 4'b0110; W_valM = 64'd43; W_dstE = 4'b0111; W_valE = 64'd67;
  #5
  //rmmove => d_valA = R[D_rA], d_valB = R[D_rB]
  #50 D_icode=4'b0100; D_rA = 4'b0110; D_rB = 4'b0111;
  // check bypass d_srcA = e_dstE using rmmove
  #50 D_icode=4'b0100; D_rA = 4'b0110; D_rB = 4'b0111; e_dstE = 4'b0110; e_valE = 64'd404;    
end

endmodule 