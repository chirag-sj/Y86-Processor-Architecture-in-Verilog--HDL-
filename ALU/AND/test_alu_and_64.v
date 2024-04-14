module test_alu_and_64;
reg [63:0] in1, in2;
wire [63:0] and_out;

alu_and_64 uut(
    .in1(in1),
    .in2(in2),
    .and_out(and_out)
);

initial
begin
    in1=0; in2=0;
    $monitor($time,"in1 = %b, in2 = %b, AND_Output = %b",in1,in2,and_out);
       in1 = 64'b101010101110101010110101010010110101010; in2 = 64'b111111111111;
    #5 in1 = 64'b101010101110101010110101010010110101010; in2 = 64'b0;
    #5 in1 = 64'b101010101000000000000101010010110101010; in2 = 64'b111111111111;
    #5 in1 = 64'b101010101110101010110101010010110101010; in2 = 64'b111111111111;
    $finish;
end
endmodule