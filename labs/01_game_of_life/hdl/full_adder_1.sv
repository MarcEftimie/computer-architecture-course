`timescale 1ns/1ps
`default_nettype none
/*
  a 1 bit addder that we can daisy chain for 
  ripple carry adders
*/

module full_adder_1(a, b, c_in, sum, c_out);

input wire a, b, c_in;
output logic sum, c_out;

logic a_bar;
logic b_bar;
logic c_in_bar;

always_comb begin
  //sets the nots of different input variables
  a_bar = ~a;
  b_bar = ~b;
  c_in_bar = ~c_in;
  //Logic of sum to determine when the sum is 1
  sum = (a_bar & b_bar & c_in) | (a_bar & b & c_in_bar) | (a & b_bar & c_in_bar) | (a & b & c_in);
  //Logic of the carry out to determine when the carry out is 1
  c_out = (b & c_in) | (a & b) | (a & c_in);
end

endmodule
