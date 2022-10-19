`timescale 1ns/1ps
`default_nettype none
/*
  a half adder
  takes in 2 bits and outputs a sum and a carry
*/

module half_adder_1(a, b, sum, c_out);

input wire a, b;
output logic sum, c_out;

always_comb begin
  //xor of a and b to determine the sum, such that when both are 1 sum is 0
  sum = a ^ b; 
  //and of a and b, such that if a and b are both 1 the carry out is 1
  c_out = a & b;
end

endmodule
