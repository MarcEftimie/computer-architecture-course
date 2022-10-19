`timescale 1ns/1ps
`default_nettype none
/*
  a 3 bit addder 
*/

module full_adder_3(a, b, c_in, sum, c_out);

input wire [2:0] a; //3 bit input
input wire b, c_in;
output logic [2:0] sum; //3 bit output
output logic c_out;

logic full_adder_1_0_c_out;
logic full_adder_1_1_c_out;
//Chain of full adders to add a 3 bit number to 2 1 bit numbers to get a 3 bit number and a carry

//First adder takes in the first bit a, a 1 bit number b and 1 bit number that represents the carry
//outputs the first bit of the sum and a carry out that is fed into the next adder
full_adder_1 FULL_ADDER_1_0 (.a(a[0]), .b(b), .c_in(c_in), .sum(sum[0]), .c_out(full_adder_1_0_c_out));
//Second adder takes in the second bit of a, 0 and the carry out of the first adder
//Takes in 0 because we are only trying to add the carry out of the previous adder and the second bit of a
//Outputs the second bit of sum and another carry out
full_adder_1 FULL_ADDER_1_1 (.a(a[1]), .b(1'b0), .c_in(full_adder_1_0_c_out), .sum(sum[1]), .c_out(full_adder_1_1_c_out));
//same as the previous adder except but for second bit of a and carry out of previous adder
full_adder_1 FULL_ADDER_1_2 (.a(a[2]), .b(1'b0), .c_in(full_adder_1_1_c_out), .sum(sum[2]), .c_out(c_out));


endmodule