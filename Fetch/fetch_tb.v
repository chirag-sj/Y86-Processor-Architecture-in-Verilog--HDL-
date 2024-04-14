module testbench;
  reg [63:0] newpc,W_valM,M_valA;
  reg clk;
  reg [3:0] W_icode,M_icode;
  reg M_Cnd;
  wire [3:0] icode,ifun,ra,rb;
  wire [63:0] valc,valp;
  wire inst_valid,imem_error;
  wire [2:0] status;
  wire [63:0] nextpredpc;

  
  fetch uut ( predpc,W_icode,M_icode,M_Cnd,W_valM,M_valA,E_valA,e_cnd,e_icode,
              icode,
              ifun,
              ra,
              rb,
              valc,
              valp,
              status,
              nextpredpc);
  

  initial
     clk=1'b0;

  always 
  #5 clk=~clk;
  
  initial
  begin

  
  $monitor("newpc=%d,W_icode=%b,W_valM=%d,M_icode=%b,M_Cnd=%b,M_valA=%d,icode=%b,ifun=%b,ra=%b,rb=%b,valc=%d,valp=%d,status=%b,nextpredpc=%d",newpc,W_icode,W_valM,M_icode,M_Cnd,M_valA,icode,ifun,ra,rb,valc,valp,status,nextpredpc);
  #5 newpc=64'd10;
  #10 newpc=64'd20;
  #10 newpc=64'd30;
  #10 newpc=64'd32;
  #10 newpc=64'd34;
  #10 newpc=64'd64;
  #10 newpc=64'd66;
  #10 newpc=64'd76;
  #10 newpc=64'd78;


  
  #100 $finish;
  end

endmodule