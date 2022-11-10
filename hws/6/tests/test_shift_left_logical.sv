`timescale 1ns / 1ps
`default_nettype none

`define SIMULATION

module test_shift_left_logical;
    parameter N = 32;
    logic [N-1:0] in;
    logic [N-1:0] shamt;
    wire [N-1:0] out;

    shift_left_logical UUT(
    .in(in),
    .shamt(shamt),
    .out(out)
    );

    initial begin
        // Collect waveforms
        $dumpfile("shift_left_logical.fst");
        $dumpvars(0, UUT);

        // in = 32'b10011111111111111111111111111111;
        in = 'h6cb0b7d9;
        shamt = 5'b00000;
        // shamt = 'hb6a4266d;
        $display("in shamt | out");
        #1 $display("%1b %2b | %4b %4b", in, shamt, out, p_out);
        $display(~(shamt^5'b00001));
    end
endmodule
