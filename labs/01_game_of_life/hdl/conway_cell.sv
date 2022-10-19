`default_nettype none
`timescale 1ns/1ps

module conway_cell(clk, rst, ena, state_0, state_d, state_q, neighbors);
input wire clk;
input wire rst;
input wire ena;

input wire state_0;
output logic state_d; // NOTE - this is only an output of the module for debugging purposes. 
output logic state_q;

input wire [7:0] neighbors; //states of each neighboring cell

logic [2:0] sum;
logic c_out;
//Takes in 8 1 bit numbers that each represent the state of neighboring cell
//and outputs a 3 bit sum and carry
adder_8_1_bits ADDER_8_1(
    .a(neighbors),
    .sum(sum),
    .c_out(c_out)
    );
//Takes the current state of the cell and the sum of neigboring cells
//To find the new state of the current cell.
comparator COMPARATOR(
    .live(state_q),
    .neighbors(sum),
    .out(state_d)
    );
always_ff @(posedge clk ) begin //on the rising edge of the clock
    if (rst == 1) begin //if reset on set state of the cell back to default state
        state_q <= state_0;
    end
    else if (ena == 1) begin //if enable is on and rst is off state of the cell is updated
        state_q <= state_d;
    end
end

endmodule