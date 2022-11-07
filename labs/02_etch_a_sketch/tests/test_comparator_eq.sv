`timescale 1ns/1ps
`default_nettype none
module test_comparators;

parameter N = 32;

logic [N-1:0] a, b;
wire out;

comparator_eq #(.N(N)) UUT_EQ(.a(a), .b(b), .out(out));

initial begin
  $dumpfile("comparators.fst");
  $dumpvars;
  
  $display("a                                b                                | out equals");
  a = 0;
  b = 0;
  #1
  $display("%b %b | %b   %b", a, b, out, a==b);

  a = 1;
  b = 0;
  #1
  $display("%b %b | %b   %b", a, b, out, a==b);

end


endmodule
