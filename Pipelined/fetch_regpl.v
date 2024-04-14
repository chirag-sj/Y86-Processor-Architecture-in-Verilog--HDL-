module fetch_reg (clk,F_stall,ipredpc,opredpc);
input clk;
input [63:0] ipredpc;
input  F_stall;
output reg [63:0] opredpc;



always@(posedge clk)
   begin
    if(F_stall==1'b0)
       opredpc=ipredpc;
    end
endmodule

