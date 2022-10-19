`default_nettype none
`timescale 1ns/1ps

module conway_cell(clk, rst, ena, state_0, state_d, state_q, neighbors);
input wire clk;
input wire rst;
input wire ena;

input wire state_0;
output logic state_d; // NOTE - this is only an output of the module for debugging purposes. 
output logic state_q;

input wire [7:0] neighbors;

logic [2:0] sum;
logic c_out;
adder_8_1_bits ADDER_8_1(
    .a(neighbors),
    .sum(sum),
    .c_out(c_out)
    );
comparator COMPARATOR(
    .live(state_q),
    .neighbors(sum),
    .out(state_d)
    );
always_ff @(posedge clk ) begin
    if (rst == 1) begin
        state_q <= state_0;
    end
    else if (ena == 1) begin
        state_q <= state_d;
    end
end

endmodule