`timescale 1ns/1ps
`default_nettype none

module adder_8_1_bits(a, sum, c_out);

input wire [7:0] a;
output logic [2:0] sum;
output logic c_out;

logic full_adder_1_0_sum, full_adder_1_0_c_out, full_adder_1_1_sum, full_adder_1_1_c_out, full_adder_2_0_c_out;
logic [1:0] full_adder_2_0_sum;

full_adder_1 FULL_ADDER_1_0(.a(a[0]), .b(a[1]), .c_in(a[2]), .sum(full_adder_1_0_sum), .c_out(full_adder_1_0_c_out));
full_adder_1 FULL_ADDER_1_1(.a(a[3]), .b(a[4]), .c_in(a[5]), .sum(full_adder_1_1_sum), .c_out(full_adder_1_1_c_out));

full_adder_2 FULL_ADDER_2_0(.a({full_adder_1_0_c_out, full_adder_1_0_sum}), .b({full_adder_1_1_c_out, full_adder_1_1_sum}), .sum(full_adder_2_0_sum), .c_out(full_adder_2_0_c_out));

full_adder_3 FULL_ADDER_3_0(.a({full_adder_2_0_c_out, full_adder_2_0_sum}), .b(a[6]), .c_in(a[7]), .sum(sum), .c_out(c_out));

endmodule
