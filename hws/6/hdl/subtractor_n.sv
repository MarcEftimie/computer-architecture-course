`timescale 1ns/1ps
`default_nettype none
module subtractor_n(a, b, c_in, sum, c_out);

parameter N = 32;

input  wire [N-1:0] a, b;
input wire c_in;
output logic [N-1:0] sum;
output wire c_out;

logic [N-1:0] b_bar;
logic [N-1:0] twos_complement_b;

logic c_out_z;

adder_n #(.N(N)) adder_n_0 (.a(b_bar), .b(1'b1), .c_in(1'b0), .sum(twos_complement_b), .c_out(c_out_z));
adder_n #(.N(N)) adder_n_1 (.a(a), .b(twos_complement_b), .c_in(1'b0), .sum(sum), .c_out(c_out));


always_comb begin
    b_bar = ~b;
end

endmodule
// to instantiate
// adder_n #(.N(32)) adder_32bit_a ( port list );
