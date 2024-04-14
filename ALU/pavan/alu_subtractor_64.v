module alu_subtractor_64(a,b,difference,overflow);
	input signed [63:0] a,b;
   output signed [63:0] difference;
   output signed overflow;
   wire  c_out,cyin;
   assign cyin=1'b1;
   wire signed [63:0] c_prop;
   wire signed [63:0] b_not;
   genvar i;
   generate
   for(i=0;i<64;i=i+1) 
      begin
           not(b_not[i], b[i]);
   end
endgenerate
   full_add f(a[0],b_not[0],cyin,difference[0],c_prop[0]);
   generate 
   for(i=1;i<64;i=i+1)
		begin
			full_add f(a[i],b_not[i],c_prop[i-1],difference[i],c_prop[i]);
      end
   endgenerate
   assign c_out = c_prop[63];
   xor g6 (overflow,c_prop[63],c_prop[62]);
endmodule