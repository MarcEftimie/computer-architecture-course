`timescale 1ns / 1ps
`default_nettype none

`define SIMULATION

module test_half_adder_1;
  logic a, b;
  wire sum, c_out;

  half_adder_1 UUT(
    .a(a),
    .b(b),
    .sum(sum),
    .c_out(c_out)
    );

  initial begin
    // Collect waveforms
    $dumpfile("half_adder_1.fst");
    $dumpvars(0, UUT);
    
    a = 0;
    $display("a  b |   sum c_out");
    for (int i = 0; i < 2; i = i + 1) begin
      b = i;
      #1 $display("%1b %2b | %4b %4b", a, b, sum, c_out);
    end

    a = 1;
    for (int i = 0; i < 2; i = i + 1) begin
      b = i;
      #1 $display("%1b %2b | %4b %4b", a, b, sum, c_out);
    end
        
    $finish;      
	end

endmodule
