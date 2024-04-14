module memory (M_stat,M_icode,M_cnd,M_valE,M_valA,M_dstE,M_dstM,m_valM,m_stat,MM_icode,MM_valE,MM_dstE,MM_dstM);
input [2:0] M_stat;
input [3:0] M_icode,M_dstE,M_dstM;
input M_cnd;
input [63:0] M_valE,M_valA;

output reg [63:0] m_valM;
output reg [2:0] m_stat;
output reg [3:0] MM_icode;
output reg [63:0] MM_valE;
output reg [3:0] MM_dstE,MM_dstM;


reg [63:0] mem_ad;
reg [63:0] mem_dt;
reg m_read;
reg m_write;
reg [7:0] mem[65535:0];
reg dmem_error;




always @(M_icode,M_valE,M_valA) 
    begin
        mem_dt=M_valA;
        MM_icode=M_icode;
        MM_valE=M_valE;
        MM_dstE=M_dstE;
        MM_dstM=M_dstM;
        if((M_icode==4'b0100)||(M_icode==4'b1010)||(M_icode==4'b1000)||(M_icode==4'b0101)) 
            mem_ad=M_valE;
        else if((M_icode==4'b1011)||(M_icode==4'b1001)) 
            mem_ad=M_valA;
    end

always @(M_icode,M_valE,M_valA) 
    begin    

        if((M_icode==4'b0101)||(M_icode==4'b1011)||(M_icode==4'b1001))
            m_read=1;
        else 
            m_read=0;
            
        if((M_icode==4'b0100)||(M_icode==4'b1010)||(M_icode==4'b1000))
            m_write=1;
        else
            m_write=0;
   
        if ((mem_ad+7>65536)||(m_read & m_write))
            dmem_error=1'b1;
        else 
            dmem_error=1'b0;

        
    end
        
always @(dmem_error) 
    begin
        if(dmem_error==1'b1)
            m_stat=2'b10;              //ADR  2'b10
        else
            m_stat=M_stat;
    end
 
    
always @(m_read,m_write,mem_ad,mem_dt) 
    begin
       if(m_write&(~(dmem_error)))
        begin
          mem[mem_ad]   <= mem_dt[7:0];
          mem[mem_ad+1] <= mem_dt[15:8];
          mem[mem_ad+2] <= mem_dt[23:16];
          mem[mem_ad+3] <= mem_dt[31:24];
          mem[mem_ad+4] <= mem_dt[39:32];
          mem[mem_ad+5] <= mem_dt[47:40];
          mem[mem_ad+6] <= mem_dt[55:48];
          mem[mem_ad+7] <= mem_dt[63:56];
        end
        if(m_read&(~(dmem_error))) 
        begin
          m_valM[7:0]   <=mem[mem_ad];
          m_valM[15:8]  <=mem[mem_ad+1];
          m_valM[23:16] <=mem[mem_ad+2];
          m_valM[31:24] <=mem[mem_ad+3];
          m_valM[39:32] <=mem[mem_ad+4];
          m_valM[47:40] <=mem[mem_ad+5];
          m_valM[55:48] <=mem[mem_ad+6];
          m_valM[63:56] <=mem[mem_ad+7];
        end
      if (m_read&dmem_error)
        begin  
          m_valM[7:0]   <=8'h0;
          m_valM[15:8]  <=8'h0;
          m_valM[23:16] <=8'h0;
          m_valM[31:24] <=8'h0;
          m_valM[39:32] <=8'h0;
          m_valM[47:40] <=8'h0;
          m_valM[55:48] <=8'h0;
          m_valM[63:56] <=8'h0;
        end
    end




endmodule