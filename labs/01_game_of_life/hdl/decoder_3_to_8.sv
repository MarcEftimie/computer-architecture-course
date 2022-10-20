`timescale 1ns/1ps

module decoder_3_to_8(ena, in, out);

input wire ena;
input wire [2:0] in;
output logic [7:0] out;

logic c_bar;
logic [3:0] decoder_0_out;
logic [3:0] decoder_1_out;

decoder_2_to_4 DECODER_0 (.ena(c_bar), .in(in[1:0]), .out(decoder_0_out));
decoder_2_to_4 DECODER_1 (.ena(in[2]), .in(in[1:0]), .out(decoder_1_out));
//Uses the 4 states decoded from each 2 to 4 decoder of the 3 bit number to find the 8 states
always_comb begin
  c_bar = ~in[2];
  out[7] = decoder_1_out[3] & ena; 
  out[6] = decoder_1_out[2] & ena;
  out[5] = decoder_1_out[1] & ena;
  out[4] = decoder_1_out[0] & ena;
  out[3] = decoder_0_out[3] & ena;
  out[2] = decoder_0_out[2] & ena;
  out[1] = decoder_0_out[1] & ena;
  out[0] = decoder_0_out[0] & ena;
end

endmodule