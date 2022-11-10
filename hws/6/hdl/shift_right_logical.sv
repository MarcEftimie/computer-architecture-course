`timescale 1ns/1ps
`default_nettype none
module shift_right_logical(in,shamt,out);
parameter N = 32; // only used as a constant! Don't feel like you need to a shifter for arbitrary N.

//port definitions
input  wire [N-1:0] in;    // A 32 bit input
input  wire [N-1:0] shamt; // Amount we shift by.
output logic [N-1:0] out;  // Output.

logic [N-1:0] pre_out;
logic all_zeros;

logic sign;
mux32 #(.N(N)) MUX_32 (.in00({{0{sign}}, in[N-1:0]}), .in01({{1{sign}},
 in[N-1:1]}), .in02({{2{sign}}, in[N-1:2]}), .in03({{3{sign}}, in[N-1:3]}),
  .in04({{4{sign}}, in[N-1:4]}), .in05({{5{sign}}, in[N-1:5]}), .in06({{6{sign}},
   in[N-1:6]}), .in07({{7{sign}}, in[N-1:7]}), .in08({{8{sign}}, in[N-1:8]}), .in09({{9{sign}},
    in[N-1:9]}), .in10({{10{sign}}, in[N-1:10]}), .in11({{11{sign}}, in[N-1:11]}), .in12({{12{sign}},
     in[N-1:12]}), .in13({{13{sign}}, in[N-1:13]}), .in14({{14{sign}}, in[N-1:14]}), .in15({{15{sign}},
      in[N-1:15]}), .in16({{16{sign}}, in[N-1:16]}), .in17({{17{sign}}, in[N-1:17]}), .in18({{18{sign}},
       in[N-1:18]}), .in19({{19{sign}}, in[N-1:19]}), .in20({{20{sign}}, in[N-1:20]}), .in21({{21{sign}},
        in[N-1:21]}), .in22({{22{sign}}, in[N-1:22]}), .in23({{23{sign}}, in[N-1:23]}), .in24({{24{sign}},
         in[N-1:24]}), .in25({{25{sign}}, in[N-1:25]}), .in26({{26{sign}}, in[N-1:26]}), .in27({{27{sign}},
          in[N-1:27]}), .in28({{28{sign}}, in[N-1:28]}), .in29({{29{sign}}, in[N-1:29]}), .in30({{30{sign}},
           in[N-1:30]}), .in31({{31{sign}}, in[N-1:31]}), .select(shamt), .out(pre_out));

always_comb begin
    sign = 0;
    all_zeros = |shamt[N-1:5];
    out = all_zeros ? 32'b0 : pre_out;
end

endmodule
