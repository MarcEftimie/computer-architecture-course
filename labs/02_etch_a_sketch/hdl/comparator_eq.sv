module comparator_eq(a, b, out);

parameter N = 32;

input wire signed [N-1:0] a, b;
output logic out;

int i;

always_comb begin
    out = 1'b1;
    for (i=0; i < N; i++) begin
        out = out & ~(a[i] ^ b[i]);
    end
end

endmodule