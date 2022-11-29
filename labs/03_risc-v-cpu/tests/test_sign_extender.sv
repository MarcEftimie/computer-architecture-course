`timescale 1ns / 1ps

`include "../hdl/alu_types.sv"

module test_sign_extender;

logic [24:0] imm;
logic imm_src;
wire [31:0] imm_ext;

sign_extender UUT (
    .imm(imm), .imm_src(imm_src), .imm_ext(imm_ext)
);

initial begin
  $dumpfile("pulse_generator.fst");
  $dumpvars(0, UUT);

  imm = {12'b000000000010, 13'b0000000000000};
  imm_src = 1'b1;
  
  $display("imm    imm_src    imm_ext");
  #5
  $display("%b    %b    %b", imm, imm_src, imm_ext);
  
end

endmodule