module test_alu_xor_64;
reg [63:0] in1, in2;
wire [63:0] xor_out;

alu_xor_64 uut(
    .in1(in1),
    .in2(in2),
    .xor_out(xor_out)
);

initial
begin
    in1=0; in2=0;
    $monitor($time,"in1 = %b, in2 = %b, xor_output = %b",in1,in2,xor_out);
       in1 = 64'b10110101010; in2 = 64'b111111111111;
    #5 in1 = 64'b10101011010; in2 = 64'b0;
    #5 in1 = 64'b10000101010; in2 = 64'b111111111111;
    #5 in1 = 64'b01100101010; in2 = 64'b111111111111;
    $finish;
end
endmodule