/*
  Outputs a pulse generator with a period of "ticks".
  out should go high for one cycle ever "ticks" clocks.
*/
module pulse_generator(clk, rst, ena, ticks, out);

parameter N = 8;
input wire clk, rst, ena;
input wire [N-1:0] ticks;
output logic out;

logic [N-1:0] counter;
logic counter_comparator;
 
comparator_eq #(.N(N)) comparator_eq_0(.a(counter), .b(ticks), .out(out));

always_ff @(posedge clk) begin
  if(rst | out) begin
    counter <= 0;
  end else if(ena) begin
    counter <= counter + 1;
  end
end
endmodule
