module alu_and_64 (in1, in2, and_out);
input signed [63:0] in1, in2;
output signed [63:0] and_out;
genvar i;
generate
    for(i=0;i<64;i=i+1)
    begin
        and(and_out[i], in1[i], in2[i]);
    end
endgenerate    
endmodule