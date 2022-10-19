`timescale 1ns / 1ps
`default_nettype none

`define SIMULATION

module test_full_adder_1;
  logic a, b, c_in;
  wire sum, c_out;

  full_adder_1 UUT(
    .a(a),
    .b(b),
    .c_in(c_in),
    .sum(sum),
    .c_out(c_out)
    );

  initial begin
    // Collect waveforms
    $dumpfile("full_adder_1.fst");
    $dumpvars(0, UUT);
    
    a = 0;
    b = 0;
    $display("a  b  c_in |   c_out sum ");
    for (int i = 0; i < 2; i = i + 1) begin
      c_in = i[1:0];
      #1 $display("%1b %2b %2b | %4b %4b", a, b, c_in, c_out, sum);
    end

    a = 0;
    b = 1;
    for (int i = 0; i < 2; i = i + 1) begin
      c_in = i[1:0];
      #1 $display("%1b %2b %2b | %4b %4b", a, b, c_in, c_out, sum);
    end

    a = 1;
    b = 0;
    for (int i = 0; i < 2; i = i + 1) begin
      c_in = i[1:0];
      #1 $display("%1b %2b %2b | %4b %4b", a, b, c_in, c_out, sum);
    end

    a = 1;
    b = 1;
    for (int i = 0; i < 2; i = i + 1) begin
      c_in = i[1:0];
      #1 $display("%1b %2b %2b | %4b %4b", a, b, c_in, c_out, sum);
    end
        
    $finish;      
	end

endmodule
