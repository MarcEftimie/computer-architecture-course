module comparator_eq(a, b, out);
parameter N = 32;
input wire signed [N-1:0] a, b;
logic [N-1:0] eql;
output logic out;

int i;
always_comb begin
    out = 1'b1;
    for (i=0; i < N; i++) begin
        out = out & ~(a[i] ^ b[i]);
    end
end

// Using only *structural* combinational logic, make a module that computes if a == b. 

// Copy any other modules you use into the HDL folder and update the Makefile accordingly.


endmodule


