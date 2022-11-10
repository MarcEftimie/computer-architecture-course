`default_nettype none
`timescale 1ns/1ps

module register_file(
  clk, //Note - intentionally does not have a reset! 
  wr_ena, wr_addr, wr_data,
  rd_addr0, rd_data0,
  rd_addr1, rd_data1
);
// Not parametrizing, these widths are defined by the RISC-V Spec!
input wire clk;

// Write channel
input wire wr_ena;
input wire [4:0] wr_addr;
input wire [31:0] wr_data;

// Two read channels
input wire [4:0] rd_addr0, rd_addr1;
output logic [31:0] rd_data0, rd_data1;

logic [31:0] x00; 
always_comb x00 = 32'd0; // ties x00 to ground. 

logic [31:0] decoder_out;
// DON'T DO THIS:
// logic [31:0] register_file_registers [31:0]
// CAN'T: because that's a RAM. Works in simulation, fails miserably in synthesis.

// Hint - use a scripting language if you get tired of copying and pasting the logic 32 times - e.g. python: print(",".join(["x%02d"%i for i in range(0,32)]))
logic [31:0] x01,x02,x03,x04,x05,x06,x07,x08,x09,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31;

mux32 #(.N(32)) MUX_32_0 (.in00(x00), .in01(x01), .in02(x02),
 .in03(x03), .in04(x04), .in05(x05), .in06(x06), .in07(x07),
  .in08(x08), .in09(x09), .in10(x10), .in11(x11), .in12(x12),
   .in13(x13), .in14(x14), .in15(x15), .in16(x16), .in17(x17),
    .in18(x18), .in19(x19), .in20(x20), .in21(x21), .in22(x22),
     .in23(x23), .in24(x24), .in25(x25), .in26(x26), .in27(x27),
      .in28(x28), .in29(x29), .in30(x30), .in31(x31), .select(rd_addr0), .out(rd_data0));

mux32 #(.N(32)) MUX_32_1 (.in00(x00), .in01(x01), .in02(x02),
 .in03(x03), .in04(x04), .in05(x05), .in06(x06), .in07(x07),
  .in08(x08), .in09(x09), .in10(x10), .in11(x11), .in12(x12),
   .in13(x13), .in14(x14), .in15(x15), .in16(x16), .in17(x17),
    .in18(x18), .in19(x19), .in20(x20), .in21(x21), .in22(x22),
     .in23(x23), .in24(x24), .in25(x25), .in26(x26), .in27(x27),
      .in28(x28), .in29(x29), .in30(x30), .in31(x31), .select(rd_addr1), .out(rd_data1));

always_comb decoder_out = wr_ena ? (32'b1 << wr_addr) : 32'b0;

always_ff @(posedge clk) begin
  x01 <= decoder_out[1] ? wr_data : x01;
  x02 <= decoder_out[2] ? wr_data : x02;
  x03 <= decoder_out[3] ? wr_data : x03;
  x04 <= decoder_out[4] ? wr_data : x04;
  x05 <= decoder_out[5] ? wr_data : x05;
  x06 <= decoder_out[6] ? wr_data : x06;
  x07 <= decoder_out[7] ? wr_data : x07;
  x08 <= decoder_out[8] ? wr_data : x08;
  x09 <= decoder_out[9] ? wr_data : x09;
  x10 <= decoder_out[10] ? wr_data : x10;
  x11 <= decoder_out[11] ? wr_data : x11;
  x12 <= decoder_out[12] ? wr_data : x12;
  x13 <= decoder_out[13] ? wr_data : x13;
  x14 <= decoder_out[14] ? wr_data : x14;
  x15 <= decoder_out[15] ? wr_data : x15;
  x16 <= decoder_out[16] ? wr_data : x16;
  x17 <= decoder_out[17] ? wr_data : x17;
  x18 <= decoder_out[18] ? wr_data : x18;
  x19 <= decoder_out[19] ? wr_data : x19;
  x20 <= decoder_out[20] ? wr_data : x20;
  x21 <= decoder_out[21] ? wr_data : x21;
  x22 <= decoder_out[22] ? wr_data : x22;
  x23 <= decoder_out[23] ? wr_data : x23;
  x24 <= decoder_out[24] ? wr_data : x24;
  x25 <= decoder_out[25] ? wr_data : x25;
  x26 <= decoder_out[26] ? wr_data : x26;
  x27 <= decoder_out[27] ? wr_data : x27;
  x28 <= decoder_out[28] ? wr_data : x28;
  x29 <= decoder_out[29] ? wr_data : x29;
  x30 <= decoder_out[30] ? wr_data : x30;
  x31 <= decoder_out[31] ? wr_data : x31;
end
endmodule