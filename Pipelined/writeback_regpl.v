module write_reg (
    clk,
    W_stall,
    m_stat, m_icode, m_valE, m_valM, m_dstE, m_dstM,
    W_stat, W_icode, W_valE, W_valM, W_dstE, W_dstM
);

input clk;

input W_stall;
input [2:0] m_stat;
input [3:0] m_icode;
input [63:0] m_valE, m_valM;
input [3:0] m_dstE, m_dstM;

output reg [2:0]  W_stat;
output reg [3:0]  W_icode;
output reg [63:0] W_valE, W_valM;
output reg [3:0]  W_dstE, W_dstM;


    
always @(posedge clk) begin
    if (W_stall==1'b0)
        begin
            W_stat  = m_stat; 
            W_icode = m_icode;
            W_valE  = m_valE; 
            W_valM  = m_valM; 
            W_dstE  = m_dstE; 
            W_dstM  = m_dstM; 
        end
end

endmodule