`timescale 1ns / 1ps
`default_nettype none

`define SIMULATION

module test_full_adder_3;
  logic [2:0] a;
  logic b, c_in;
  wire [2:0] sum;
  wire c_out;

  full_adder_3 UUT(
    .a(a),
    .b(b),
    .c_in(c_in),
    .sum(sum),
    .c_out(c_out)
    );

  initial begin
    // Collect waveforms
    $dumpfile("full_adder_3.fst");
    $dumpvars(0, UUT);
  
    $display("a    b  c |  c_out sum");
    for (int i = 0; i < 6; i = i + 1) begin
      a = i[2:0];
      for (int j = 0; j < 2; j = j + 1) begin
        b = j;
        for (int k = 0; k < 2; k = k + 1) begin
          c_in = k;
          #1 $display("%1b %2b %2b | %4b %4b", a, b, c_in, c_out, sum);
        end
      end
    end
        
    $finish;      
	end

endmodule
