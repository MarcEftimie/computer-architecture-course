`timescale 1ns/1ps
`default_nettype none
/*
  a 2 bit addder 
*/

module full_adder_2(a, b, sum, c_out);

input wire [1:0] a, b; //Takes in 2 2 bit numbers
output logic [1:0] sum; //2 bit sum output
output logic c_out;

logic half_adder_1_0_c_out;
//Chains a half adder and a full adder
//Half adder takes in the first bit of a and first bit of b and outputs a sum that is the first bit of the output and a carry out
half_adder_1 HALF_ADDER_1_0 (.a(a[0]), .b(b[0]), .sum(sum[0]), .c_out(half_adder_1_0_c_out));
//full adder that takes in the second bit of a, second bit of b and the carry out of the half adder to output a carry and the second bit of the sum
full_adder_1 FULL_ADDER_1_0 (.a(a[1]), .b(b[1]), .c_in(half_adder_1_0_c_out), .sum(sum[1]), .c_out(c_out));


endmodule
