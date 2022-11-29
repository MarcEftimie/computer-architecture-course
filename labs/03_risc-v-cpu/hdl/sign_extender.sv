`timescale 1ns/1ps
`default_nettype none

`include "sign_extender_types.sv"
module sign_extender(
    imm, imm_src, imm_ext
);



input wire [24:0] imm;
input wire imm_src;
output logic [31:0] imm_ext;

always_comb begin
  case(imm_src)
    1 : begin
      if (imm[24] == 1) begin
        imm_ext = {{20{1'b1}}, imm[24:13]};
      end 
      else begin
        imm_ext = {{20{1'b0}}, imm[24:13]};
      end
    end
    default : imm_ext = 32'b0;
  endcase
end

endmodule
