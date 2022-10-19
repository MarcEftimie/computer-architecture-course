`timescale 1ns/1ps
`default_nettype none

module DFlipFlop(D, rst, clk, Q, Q_bar);

input D, clk, rst;

output reg Q;
output Q_bar;

assign Q_bar = ~Q;

always_ff @(posedge clk) begin
    if (rst == 1'b1)
        Q <= 1'b0;
    else
        Q <= D;
end

endmodule
