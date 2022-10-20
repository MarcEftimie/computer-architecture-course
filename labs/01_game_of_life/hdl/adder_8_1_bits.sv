`timescale 1ns/1ps
`default_nettype none

module adder_8_1_bits(a, sum, c_out);

input wire [7:0] a; //8 bit input
output logic [2:0] sum; // 3 bit output
output logic c_out;

logic full_adder_1_0_sum, full_adder_1_0_c_out, full_adder_1_1_sum, full_adder_1_1_c_out, full_adder_2_0_c_out;
logic [1:0] full_adder_2_0_sum;
//2 full adders each take in 3 bits from a, which 8 bits and outputs a sum and a carry out
full_adder_1 FULL_ADDER_1_0(.a(a[0]), .b(a[1]), .c_in(a[2]), .sum(full_adder_1_0_sum), .c_out(full_adder_1_0_c_out));
full_adder_1 FULL_ADDER_1_1(.a(a[3]), .b(a[4]), .c_in(a[5]), .sum(full_adder_1_1_sum), .c_out(full_adder_1_1_c_out));
//the 2 bit adder that takes in 2 2 bit numbers where the first bit is the sum and the second bit is the carry out of the corresponding adder
full_adder_2 FULL_ADDER_2_0(.a({full_adder_1_0_c_out, full_adder_1_0_sum}), .b({full_adder_1_1_c_out, full_adder_1_1_sum}), .sum(full_adder_2_0_sum), .c_out(full_adder_2_0_c_out));
//an adder that adds a 3 bit number to 2 1 bit numbers and outputs a sum that represents the number of alive neighbors and a c_out
full_adder_3 FULL_ADDER_3_0(.a({full_adder_2_0_c_out, full_adder_2_0_sum}), .b(a[6]), .c_in(a[7]), .sum(sum), .c_out(c_out));

endmodule
