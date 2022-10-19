`timescale 1ns/1ps
`default_nettype none

module test_DFlipFlop;

logic D, clk, rst;
wire Q, Q_bar;

DFlipFlop UUT (

.Q(Q), 
.Q_bar(Q_bar), 
.D(D), 
.clk(clk), 
.rst(rst)
);

initial begin
  $dumpfile("DFlipFlop.fst");
  $dumpvars(0, UUT);

  clk = 0;
  rst = 1;
  D = 0;

  $display("Running simulation...");
  @(negedge clk) rst = 0;
  repeat (2) @(negedge clk) D = 1;
  repeat (8) @(posedge clk);
  repeat (2) @(negedge clk) D = 0;
  repeat (8) @(posedge clk);
  repeat (2) @(negedge clk) D = 1;
  repeat (2) @(negedge clk) rst = 1;
  repeat (8) @(posedge clk);
  repeat (2) @(negedge clk) D = 0;
  $display("... done. Use gtkwave to see what this does!");
  $finish;
end


// Clock generation:
always #5 clk = ~clk;

endmodule
