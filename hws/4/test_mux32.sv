`timescale 1ns / 1ps
`default_nettype none

`define SIMULATION

module test_mux32;
  parameter N = 1;
  logic [(N-1):0] in00, in01, in02, in03, in04, in05, in06, in07, in08, 
  in09, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, 
  in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31;
  logic [4:0] select;
  wire [(N-1):0] out;

  mux32 UUT(in00, in01, in02, in03, in04, in05, in06, in07, in08, 
  in09, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, 
  in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, select, out);

  initial begin
    // Collect waveforms
    $dumpfile("mux32.fst");
    $dumpvars(0, UUT);
    {in00, in01, in02, in03, in04, in05, in06, in07, in08, 
    in09, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, 
    in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31} = 32'b10100100010001000010000010000001;
    for (int i = 0; i < 32; i = i + 1) begin
      select = i[4:0];
      #1 $display(out);
    end

	end

endmodule
