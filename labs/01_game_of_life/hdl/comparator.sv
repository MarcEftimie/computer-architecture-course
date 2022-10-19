`timescale 1ns/1ps
`default_nettype none
/*
  a 1 bit addder that we can daisy chain for 
  ripple carry adders
*/

module comparator(live, neighbors, out);

input wire live;
input wire [2:0] neighbors; //3 bit number that represents total number of cells alive next to the current cell
output logic out;           //New state of the cell

always_comb begin
  //Conditions of Conway's game of life
  //First, if the cell is alive and has exactly 2 alive neighbors it stays alive
  //Second if 3 alive cells neighbor the cell the cell is alive
  out = (live & ~neighbors[2] & neighbors[1] & ~neighbors[0]) | (~neighbors[2] & neighbors[1] & neighbors[0]);
end

endmodule