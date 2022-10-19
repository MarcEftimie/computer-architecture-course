`timescale 1ns/1ps
module decoder_2_to_4(ena, in, out);

input wire ena;
input wire [1:0] in;
output logic [3:0] out;

logic b_bar;
logic [1:0] decoder_0_out;
logic [1:0] decoder_1_out;


decoder_1_to_2 DECODER_0 (.ena(b_bar), .in(in[0]), .out(decoder_0_out[1:0]));
decoder_1_to_2 DECODER_1 (.ena(in[1]), .in(in[0]), .out(decoder_1_out[1:0]));

always_comb begin
    b_bar = ~ in[1];
    out[3] = decoder_1_out[1] & ena;
    out[2] = decoder_1_out[0] & ena;
    out[1] = decoder_0_out[1] & ena;
    out[0] = decoder_0_out[0] & ena;
end
endmodule