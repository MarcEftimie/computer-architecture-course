`timescale 1ns/1ps
`default_nettype none
/*
  a 1 bit addder that we can daisy chain for 
  ripple carry adders
*/

module full_adder_3(a, b, c_in, sum, c_out);

input wire [2:0] a;
input wire b, c_in;
output logic [2:0] sum;
output logic c_out;

logic full_adder_1_0_c_out;
logic full_adder_1_1_c_out;

full_adder_1 FULL_ADDER_1_0 (.a(a[0]), .b(b), .c_in(c_in), .sum(sum[0]), .c_out(full_adder_1_0_c_out));
full_adder_1 FULL_ADDER_1_1 (.a(a[1]), .b(1'b0), .c_in(full_adder_1_0_c_out), .sum(sum[1]), .c_out(full_adder_1_1_c_out));
full_adder_1 FULL_ADDER_1_2 (.a(a[2]), .b(1'b0), .c_in(full_adder_1_1_c_out), .sum(sum[2]), .c_out(c_out));


endmodule