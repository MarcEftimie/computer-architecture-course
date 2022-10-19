`timescale 1ns/1ps
`default_nettype none
/*
  a 1 bit addder that we can daisy chain for 
  ripple carry adders
*/

module full_adder_2(a, b, sum, c_out);

input wire [1:0] a, b;
output logic [1:0] sum;
output logic c_out;

logic half_adder_1_0_c_out;

half_adder_1 HALF_ADDER_1_0 (.a(a[0]), .b(b[0]), .sum(sum[0]), .c_out(half_adder_1_0_c_out));
full_adder_1 FULL_ADDER_1_0 (.a(a[1]), .b(b[1]), .c_in(half_adder_1_0_c_out), .sum(sum[1]), .c_out(c_out));


endmodule
