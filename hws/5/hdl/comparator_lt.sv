module comparator_lt(a, b, out);
parameter N = 32;
input wire signed [N-1:0] a, b;
output logic out;

logic [N-1:0] sum;
logic overflow;
logic [N-1:0] neg_b;
// Using only *structural* combinational logic, make a module that computes if a is less than b!
// Note: this assumes that the two inputs are signed: aka should be interpreted as two's complement.

// Copy any other modules you use into the HDL folder and update the Makefile accordingly.
assign neg_b = ~b + 1;
adder_n #(.N(32)) adder_32bit_a (.a(a), .b(neg_b), .c_in(1'b0), .sum(sum), .c_out(overflow));
always_comb begin
    out = (~overflow & sum[N-1] & ~a[N-1] & ~b[N-1]) | (~overflow & sum[N-1] & a[N-1] & b[N-1]) | (overflow & ~sum[N-1] & a[N-1] & ~b[N-1]);
end
endmodule


