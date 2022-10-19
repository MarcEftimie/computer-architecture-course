`timescale 1ns/1ps
`default_nettype none
/*
  a 1 bit addder that we can daisy chain for 
  ripple carry adders
*/

module half_adder_1(a, b, sum, c_out);

input wire a, b;
output logic sum, c_out;

always_comb begin
  sum = a ^ b; 
  c_out = a & b;
end

endmodule
