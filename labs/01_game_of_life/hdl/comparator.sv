`timescale 1ns/1ps
`default_nettype none
/*
  a 1 bit addder that we can daisy chain for 
  ripple carry adders
*/

module comparator(live, neighbors, out);

input wire live;
input wire [2:0] neighbors;
output logic out;

always_comb begin
  out = (live & ~neighbors[2] & neighbors[1] & ~neighbors[0]) | (~neighbors[2] & neighbors[1] & neighbors[0]);
end

endmodule