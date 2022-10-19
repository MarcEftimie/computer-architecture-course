`timescale 1ns / 1ps
`default_nettype none

`define SIMULATION

module test_adder_8_1_bits;
  logic [7:0] a;
  wire [2:0] sum;
  wire c_out;

  adder_8_1_bits UUT(
    .a(a),
    .sum(sum),
    .c_out(c_out)
    );

  initial begin
    // Collect waveforms
    $dumpfile("adder_8_1_bitsfst");
    $dumpvars(0, UUT);
    
    $display("a  b |   c_out sum");
    for (int i = 0; i < 256; i = i + 1) begin
      a = i[7:0];
      #1 $display("%1b| %4b %4b", a, c_out, sum);
    end
        
    $finish;      
	end

endmodule
