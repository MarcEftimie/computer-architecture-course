`timescale 1ns/1ps
module decoder_1_to_2(ena, in, out);
//Decodes a 1 bit input into the 2 possible states it can be
input wire ena;
input wire in;
output logic [1:0] out;

logic in_bar;
always_comb begin
  //First state is if in is 1 and the enable is 1
  out[1] = in & ena;
  in_bar = ~ in;
  //Second state is if in is 0 and if enable is 1
  out[0] = in_bar & ena;
end

// Alternate:
// always_comb out[0] = ~in & ena;


endmodule