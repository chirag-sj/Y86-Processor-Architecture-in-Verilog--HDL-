`include "execute_one.v"

module testbench;
reg [3:0] icode,ifun;
reg [63:0] valA,valB,valC;
reg clk;
wire [63:0] valE;

execute uut (valE,
            icode,
            ifun,
            valA,
            valB,
            valC,
            clk);

//initial 
//    clk=1'b0;
//  always 
//   #10  clk=~clk;

initial  begin

  $monitor("icode=%b,ifun=%b,valA=%d,valB=%d,valC=%d,valE=%d",icode,ifun,valA,valB,valC,valE);
  clk=1'b0;
  icode = 4'b0110;ifun=4'b0001;valA=64'd256;valB=64'd52;valC=64'd54;
  #5 icode = 4'b0110;ifun=4'b0001;valA=64'd256;valB=64'd52;valC=64'd54;
  #20 clk=~clk;
  $finish;
  end

endmodule
