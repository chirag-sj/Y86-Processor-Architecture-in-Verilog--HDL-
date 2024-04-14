`include "fetch_regpl.v"
`include "fetch_pipepl.v"
`include "decode_regpl.v"
`include "decode_writeb.v"
`include "execute_regpl.v"
`include "execute_pipepl.v"
`include "memory_regpl.v"
`include "memory.v"
`include "writeback_regpl.v"
`include "pipe_control.v"

module Pipeline;

reg clk;
reg [63:0] ipredpc;

wire [63:0] opredpc,f_valC,f_valP,f_nextpredpc;   
wire [3:0] f_icode,f_ifun,f_ra,f_rb;
wire [2:0] f_stat;

wire [2:0] D_stat,d_stat;
wire [3:0] D_icode,D_ifun,D_ra,D_rb,d_icode,d_ifun,d_dstE,d_dstM,d_srcA,d_srcB;
wire [63:0] rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14,r15;
wire signed [63:0] D_valC,D_valP,d_valC,d_valA,d_valB;

wire [2:0] E_stat,e_stat;
wire [3:0] E_icode,E_ifun,E_dstE,E_dstM,E_srcA,E_srcB,e_icode,e_dstE,e_dstM;
wire signed [63:0] E_valC,E_valA,E_valB,e_valA,e_valE;
wire e_cnd;


wire [2:0] M_stat,m_stat;
wire [3:0] M_icode,M_dstE,M_dstM,m_icode,m_dstE,m_dstM;
wire M_cnd;
wire signed [63:0] M_valE,M_valA,m_valM,m_valE; 


wire [2:0] W_stat;
wire [3:0] W_icode,W_dstE,W_dstM;
wire signed [63:0] W_valE,W_valM;




wire  F_stall, D_stall, D_bubble, E_bubble, M_bubble, W_stall;


pipe_control uut(D_icode, d_srcA, d_srcB, E_icode, E_dstM, e_cnd, M_icode, m_stat, W_stat,
                 F_stall, D_stall, D_bubble, E_bubble, M_bubble, W_stall);


fetch_reg regf(clk,F_stall,ipredpc,opredpc);

fetch fet(opredpc,W_icode,M_icode,M_Cnd,W_valM,M_valA,e_valA,e_cnd,E_icode,
              f_icode,
              f_ifun,
              f_ra,
              f_rb,
              f_valC,
              f_valP,
              f_stat,
              f_nextpredpc);        /////////////
        
decode_reg regd(clk,D_stall, D_bubble,
                f_stat, f_icode, f_ifun, f_ra, f_rb, f_valC, f_valP,
                D_stat, D_icode, D_ifun, D_ra, D_rb, D_valC, D_valP);

decode_wb d_and_wb(D_stat, D_icode, D_ifun, D_ra, D_rb, D_valC, D_valP, 
                   e_dstE, e_valE, 
                   M_dstE, M_valE, M_dstM, m_valM, 
                   W_dstM, W_valM, W_dstE, W_valE, W_stat, W_icode,
                   d_stat,d_icode, d_ifun, d_valC, d_valA, d_valB, d_dstE, d_dstM, d_srcA, d_srcB,
                   rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14,r15);

execute_reg rege(clk,E_bubble,
                 d_stat,d_icode,d_ifun,d_valC,d_valA,d_valB,d_dstE,d_dstM,d_srcA,d_srcB,
                 E_stat,E_icode,E_ifun,E_valC,E_valA,E_valB,E_dstE,E_dstM,E_srcA,E_srcB);


execute exe(E_stat,E_icode,E_ifun,E_valC,E_valA,E_valB,E_dstE,E_dstM,E_srcA,E_srcB,e_valE,e_cnd,e_valA,e_dstE,e_stat,e_icode,e_dstM);

memory_reg regm(clk,M_bubble,
                e_stat, e_icode, e_cnd, e_valE, e_valA, e_dstE, e_dstM,
                M_stat, M_icode, M_cnd, M_valE, M_valA, M_dstE, M_dstM);

memory mem(M_stat,M_icode,M_cnd,M_valE,M_valA,M_dstE,M_dstM,m_valM,m_stat,m_icode,m_valE,m_dstE,m_dstM);

write_reg regw(clk,W_stall,
                  m_stat, m_icode, m_valE, m_valM, m_dstE, m_dstM,
                  W_stat, W_icode, W_valE, W_valM, W_dstE, W_dstM);


initial
/////ipredpc=64'd10;  // TO TEST LOAD/USE HAZARD
ipredpc=64'd10;
initial
clk=1'b0;
always
#5 clk=~clk;
always@(*)
ipredpc=f_nextpredpc;
initial
begin
$monitor("opredpc=%d,f_icode=%b,f_ifun=%b,f_ra=%b,f_rb=%b,f_valC=%d,f_valP=%d,f_stat=%b,f_nextpredpc=%d,d_stat=%b,d_icode=%b, d_ifun=%b, d_valC=%d, d_valA=%d, d_valB=%d, d_dstE=%b, d_dstM=%b, d_srcA=%b, d_srcB=%b,e_valE=%d,e_cnd=%d,e_valA=%d,e_dstE=%b,e_stat=%b,e_icode=%b,e_dstM=%b,m_valM=%d,m_stat=%b,m_icode=%b,m_valE=%d,m_dstE=%b,m_dstM=%b,W_dstM=%b, W_valM=%d, W_dstE=%b, W_valE=%d, W_stat=%b, W_icode=%b,rax=%d,rcx=%d,rdx=%d,rbx=%d,rsp=%d,rbp=%d,rsi=%d,rdi=%d,r8=%d,r9=%d,r10=%d,r11=%d,r12=%d,r13=%d,r14=%d,r15=%d,F_stall=%b,D_stall=%b,D_bubble=%b, E_bubble=%b, M_bubble=%b, W_stall=%b",opredpc,f_icode,f_ifun,f_ra,f_rb,f_valC,f_valP,f_stat,f_nextpredpc,d_stat,d_icode, d_ifun, d_valC, d_valA, d_valB, d_dstE, d_dstM, d_srcA, d_srcB,e_valE,e_cnd,e_valA,e_dstE,e_stat,e_icode,e_dstM,m_valM,m_stat,m_icode,m_valE,m_dstE,m_dstM,W_dstM, W_valM, W_dstE, W_valE, W_stat, W_icode,rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14,r15,F_stall,D_stall,D_bubble, E_bubble, M_bubble, W_stall);
#90 $finish;
end
endmodule


// Irmovq $8, %rdx
// Irmovq $15, %rcx
// Rmmovq %rcx, 0(%rdx)
// Irmovq $3, %rbx
// Mrmovq 0(%rdx), %rax
// Addq %rbx, %rax
// Subq %rdx, %rcx
