`timescale 1ns / 1ps
`default_nettype none

`define SIMULATION

module test_full_adder_2;
  logic [1:0] a, b;
  wire [1:0] sum;
  wire c_out;

  full_adder_2 UUT(
    .a(a),
    .b(b),
    .sum(sum),
    .c_out(c_out)
    );

  initial begin
    // Collect waveforms
    $dumpfile("full_adder_2.fst");
    $dumpvars(0, UUT);
    
    a[0] = 0;
    a[1] = 0;
    $display("a  b |   c_out sum");
    for (int i = 0; i < 4; i = i + 1) begin
      b = i[1:0];
      #1 $display("%1b %2b | %4b %4b", a, b, c_out, sum);
    end

    a[0] = 1;
    a[1] = 0;
    for (int i = 0; i < 4; i = i + 1) begin
      b = i[1:0];
      #1 $display("%1b %2b | %4b %4b", a, b, c_out, sum);
    end

    a[0] = 0;
    a[1] = 1;
    for (int i = 0; i < 4; i = i + 1) begin
      b = i[1:0];
      #1 $display("%1b %2b | %4b %4b", a, b, c_out, sum);
    end

    a[0] = 1;
    a[1] = 1;
    for (int i = 0; i < 4; i = i + 1) begin
      b = i[1:0];
      #1 $display("%1b %2b | %4b %4b", a, b, c_out, sum);
    end
        
    $finish;      
	end

endmodule
