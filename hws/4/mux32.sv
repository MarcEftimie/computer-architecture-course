	
`timescale 1ns/1ps
`default_nettype none
/*
  Making 32 different inputs is annoying, so I use python:
  print(", ".join([f"in{i:02}" for i in range(32)]))
  The solutions will include comments for where I use python-generated HDL.
*/

module mux32(
  in00, in01, in02, in03, in04, in05, in06, in07, in08, in09, in10, 
  in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, 
  in22, in23, in24, in25, in26, in27, in28, in29, in30, in31,
  select,out
);
//parameter definitions
parameter N = 1;  
//port definitions
// python: print(", ".join([f"in{i:02}" for i in range(32)]))

input wire [(N-1):0] in00, in01, in02, in03, in04, in05, in06, in07, in08, 
  in09, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, 
  in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31;
input  wire [4:0] select;
output logic [(N-1):0] out;

logic [N-1:0] in00_0, in01_0, in02_0, in03_0, in04_0, in05_0, in06_0, in07_0, in08_0, 
  in09_0, in10_0, in11_0, in12_0, in13_0, in14_0, in15_0;
logic [N-1:0] in00_1, in01_1, in02_1, in03_1, in04_1, in05_1, in06_1, in07_1;
logic [N-1:0] in00_2, in01_2, in02_2, in03_2;
logic [N-1:0] in00_3, in01_3;


assign in00_0 = select[0] ? in01 : in00;
assign in01_0 = select[0] ? in03 : in02;
assign in02_0 = select[0] ? in05 : in04;
assign in03_0 = select[0] ? in07 : in06;
assign in04_0 = select[0] ? in09 : in08;
assign in05_0 = select[0] ? in11 : in10;
assign in06_0 = select[0] ? in13 : in12;
assign in07_0 = select[0] ? in15 : in14;
assign in08_0 = select[0] ? in17 : in16;
assign in09_0 = select[0] ? in19 : in18;
assign in10_0 = select[0] ? in21 : in20;
assign in11_0 = select[0] ? in23 : in22;
assign in12_0 = select[0] ? in25 : in24;
assign in13_0 = select[0] ? in27 : in26;
assign in14_0 = select[0] ? in29 : in28;
assign in15_0 = select[0] ? in31 : in30;
assign in00_1 = select[1] ? in01_0 : in00_0;
assign in01_1 = select[1] ? in03_0 : in02_0;
assign in02_1 = select[1] ? in05_0 : in04_0;
assign in03_1 = select[1] ? in07_0 : in06_0;
assign in04_1 = select[1] ? in09_0 : in08_0;
assign in05_1 = select[1] ? in11_0 : in10_0;
assign in06_1 = select[1] ? in13_0 : in12_0;
assign in07_1 = select[1] ? in15_0 : in14_0;
assign in00_2 = select[2] ? in01_1 : in00_1;
assign in01_2 = select[2] ? in03_1 : in02_1;
assign in02_2 = select[2] ? in05_1 : in04_1;
assign in03_2 = select[2] ? in07_1 : in06_1;
assign in00_3 = select[3] ? in01_2 : in00_2;
assign in01_3 = select[3] ? in03_2 : in02_2;
assign out = select[4] ? in01_3 : in00_3;

endmodule
