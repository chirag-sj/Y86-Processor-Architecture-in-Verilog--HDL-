module test_alu_subtractor_64;

	// Inputs
	reg signed [63:0] a;
	reg signed [63:0] b;

	// Outputs
	wire signed [63:0] sum;
   wire signed overflow;

	// Instantiate the Unit Under Test (UUT)
	alu_subtractor_64 uut (
		.a(a), 
		.b(b), 
		.difference(sum),.overflow(overflow)
	);

	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;
      
      $monitor($time,"a = %d,b =%d,difference = %d,overflow = %b",a,b,sum,overflow);  

        
		// Wait 100 ns for global reset to finish
		#100;
        #5 a=-64'd456;b=-64'd154;
        #5 a=64'd25620;b=-64'd5264;
        #5 a=64'd58974;b=-64'd254781;
        #5 a=64'd45871;b=64'd154;
        #5 a=64'hABCDABCDABCDABCD;b=64'hABCDABCDABCDABCD;

	end  
endmodule