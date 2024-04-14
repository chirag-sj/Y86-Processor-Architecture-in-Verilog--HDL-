`include "ALU_64.v"
module test_ALU_64;

reg signed [63:0] a,b;
reg [1:0] control_signal;

wire signed [63:0] op_out;
wire overflow;

ALU_64 uut (
    .control_signal(control_signal),
    .a(a),
    .b(b),
    .op_out(op_out),
    .overflow(overflow)
);

initial begin
    $monitor($time,"Control = %b,a = %b,b =%b,result = %b,overflow = %b",control_signal,a,b,op_out,overflow);  

        
		// Wait 100 ns for global reset to finish
		#100;
        //#5 control_signal=2'b00; a=-64'd456;b=-64'd154;
        #5 control_signal=2'b01; a=64'd256;b=64'd52;
        //#5 control_signal=2'b00; a=64'd58974;b=-64'd254781;
        //#5 control_signal=2'b01; a=64'd45871;b=64'd154;
        //#5 control_signal=2'b00; a=64'hABCDABCDABCDABCD;b=64'hABCDABCDABCDABCD;
        //#5 control_signal=2'b10; a=64'b10110101010; b = 64'b111111111111;
        //#5 control_signal=2'b10; a=64'b10101011010; b = 64'b0;
        //#5 control_signal=2'b11; a=64'b10000101010; b = 64'b111111111111;
        //#5 control_signal=2'b11; a=64'b01100101010; b = 64'b111111111111;   
end
endmodule