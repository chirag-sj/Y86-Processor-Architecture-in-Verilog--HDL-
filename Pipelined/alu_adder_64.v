module alu_adder_64(a,b,sum,overflow);
	input signed [63:0] a,b;
   output signed [63:0] sum;
   output signed overflow;
   wire  c_out,cyin;
   assign cyin=1'b0;  //Input carry to first full adder set to 0
   wire signed [63:0] c_prop;
        full_add f(a[0],b[0],cyin,sum[0],c_prop[0]);

   genvar i;
   generate 
   for(i=1;i<64;i=i+1)
		begin
			full_add f(a[i],b[i],c_prop[i-1],sum[i],c_prop[i]);
      end
   
   endgenerate
   assign c_out = c_prop[63];
   xor g6 (overflow,c_prop[63],c_prop[62]);
endmodule