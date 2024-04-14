module alu_xor_64 (in1, in2, xor_out);
input signed [63:0] in1, in2;
output signed [63:0] xor_out;
genvar i;
generate
    for(i=0;i<64;i=i+1)
    begin
        xor(xor_out[i], in1[i], in2[i]);
    end
endgenerate    
endmodule
