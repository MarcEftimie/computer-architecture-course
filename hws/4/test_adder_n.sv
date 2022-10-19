`timescale 1ns / 1ps
`default_nettype none

`define SIMULATION

module test_adder_n;
  parameter N = 32;
  logic [N-1:0] a, b;
  logic c_in;
  wire [N-1:0] sum;
  wire c_out;

  adder_n UUT(
    .a(a),
    .b(b),
    .c_in(c_in),
    .sum(sum),
    .c_out(c_out)
    );

  initial begin
    // Collect waveforms
    $dumpfile("adder_n.fst");
    $dumpvars(0, UUT);

    a = 32'b10100000000001000000000000000010;
    b = 32'b11010000000001000000000000000100;
    c_in = 1'b1;
    #1 $display("%1b %2b | %4b %4b", a, b, c_out, sum);

    $finish;      
	end

endmodule
