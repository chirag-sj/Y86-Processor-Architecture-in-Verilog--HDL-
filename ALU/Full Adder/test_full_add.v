module test_full_adder;

reg signed a,b,cyin;
wire signed sum, cyout;

full_add uut(
    .a(a),
    .b(b),
    .cyin(cyin),
    .sum(sum),
    .cyout(cyout)
);

initial begin
$monitor($time,"a = %b,b = %b,cin = %b,sum = %b,cout = %b",a,b,cyin,sum,cyout);
   a=1'b0; b=1'b0; cyin=1'b0;
#5 a=1'b0; b=1'b0; cyin=1'b1;
#5 a=1'b0; b=1'b1; cyin=1'b0;
#5 a=1'b0; b=1'b1; cyin=1'b1;
#5 a=1'b1; b=1'b0; cyin=1'b0;
#5 a=1'b1; b=1'b0; cyin=1'b1;
#5 a=1'b1; b=1'b1; cyin=1'b0;
#5 a=1'b1; b=1'b1; cyin=1'b1;

end
endmodule