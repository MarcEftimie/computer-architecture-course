`timescale 1ns / 1ps
`default_nettype none

`define SIMULATION

module test_comparator;
  logic live;
  logic [2:0] neighbors;
  wire out;

  comparator UUT(
    .live(live),
    .neighbors(neighbors),
    .out(out)
    );

  initial begin
    // Collect waveforms
    $dumpfile("full_adder_3.fst");
    $dumpvars(0, UUT);

    $display("a    b  c |  c_out sum");
    for (int j = 0; j < 2; j = j + 1) begin
        live = j;
      for (int i = 0; i < 8; i = i + 1) begin
        neighbors = i[2:0];
            #1 $display("%1b %2b| %4b", live, neighbors, out);
        end
    end
        
    $finish;      
	end

endmodule
