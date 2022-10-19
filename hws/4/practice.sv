`timescale 1ns/1ps
`default_nettype none

module practice(rst, clk, ena, seed, out);

input wire rst, clk, ena, seed;
output logic out;

logic xor_out_0;
logic mux_2_to_1_0;
logic DFlipFlop_out_0;
logic DFlipFlop_out_1;
logic DFlipFlop_out_0_bar;
logic DFlipFlop_out_1_bar;
logic DFlipFlop_out_2_bar;

assign xor_out_0 = DFlipFlop_out_0 ^ DFlipFlop_out_1;
assign mux_2_to_1_0 = ena ? xor_out_0 : seed;

DFlipFlop DFLIPFLOP_0 (.D(mux_2_to_1_0), .rst(rst), .clk(clk), .Q(DFlipFlop_out_0), .Q_bar(DFlipFlop_out_0_bar));
DFlipFlop DFLIPFLOP_1 (.D(DFlipFlop_out_0), .rst(rst), .clk(clk), .Q(DFlipFlop_out_1), .Q_bar(DFlipFlop_out_1_bar));
DFlipFlop DFLIPFLOP_2 (.D(DFlipFlop_out_1), .rst(rst), .clk(clk), .Q(out), .Q_bar(DFlipFlop_out_2_bar));


endmodule
