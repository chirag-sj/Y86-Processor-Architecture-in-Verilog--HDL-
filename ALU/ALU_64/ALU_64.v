`include "full_add.v"
`include "alu_adder_64.v"
`include "alu_subtractor_64.v"
`include "alu_and_64.v"
`include "alu_xor_64.v"

module ALU_64(control_signal, a,b, op_out, overflow);
input signed [63:0] a, b;
input [1:0] control_signal;
output signed [63:0] op_out;
output overflow;

wire signed [63:0] op_out_00;
wire signed [63:0] op_out_01;
wire signed [63:0] op_out_10;
wire signed [63:0] op_out_11;
wire overflow_00;
wire overflow_01;

alu_adder_64      ad64  (a,b,op_out_00,overflow_00);
alu_subtractor_64 st64  (a,b,op_out_01,overflow_01);
alu_and_64        ag64 (a, b, op_out_10);
alu_xor_64        xg64 (a, b, op_out_11);

assign op_out = control_signal[1] ? (control_signal[0] ? op_out_11 : op_out_10) : (control_signal[0] ? op_out_01 : op_out_00);  
assign overflow = control_signal[1] ? 1'b0 : (control_signal[0] ? overflow_01 : overflow_00);

endmodule