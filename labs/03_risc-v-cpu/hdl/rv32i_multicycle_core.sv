`timescale 1ns/1ps
`default_nettype none

`include "alu_types.sv"
`include "rv32i_defines.sv"
`include "sign_extender_types.sv"

module rv32i_multicycle_core(
  clk, rst, ena,
  mem_addr, mem_rd_data, mem_wr_data, mem_wr_ena,
  PC
);

parameter PC_START_ADDRESS=0;

// Standard control signals.
input  wire clk, rst, ena; // <- worry about implementing the ena signal last.

// Memory interface.
output logic [31:0] mem_addr, mem_wr_data;
input   wire [31:0] mem_rd_data;
output logic mem_wr_ena;

// Program Counter
output wire [31:0] PC;
wire [31:0] PC_old;
logic PC_ena;
logic [31:0] PC_next; 

// Program Counter Registers
register #(.N(32), .RESET(PC_START_ADDRESS)) PC_REGISTER (
  .clk(clk), .rst(rst), .ena(PC_ena), .d(result), .q(PC)
);
register #(.N(32)) PC_OLD_REGISTER(
  .clk(clk), .rst(rst), .ena(PC_ena), .d(PC), .q(PC_old)
);

// Program Counter unmodified
// output wire [31:0] PC;
// wire [31:0] PC_old;
// logic PC_ena;
// logic [31:0] PC_next; 

// // Program Counter Registers
// register #(.N(32), .RESET(PC_START_ADDRESS)) PC_REGISTER (
//   .clk(clk), .rst(rst), .ena(PC_ena), .d(PC_next), .q(PC)
// );
// register #(.N(32)) PC_OLD_REGISTER(
//   .clk(clk), .rst(rst), .ena(PC_ena), .d(PC), .q(PC_old)
// );

//  an example of how to make named inputs for a mux:
/*
    enum logic {MEM_SRC_PC, MEM_SRC_RESULT} mem_src;
    always_comb begin : memory_read_address_mux
      case(mem_src)
        MEM_SRC_RESULT : mem_rd_addr = alu_result;
        MEM_SRC_PC : mem_rd_addr = PC;
        default: mem_rd_addr = 0;
    end
*/

// Register file
logic reg_write;
logic [4:0] rd, rs1, rs2;
wire [31:0] reg_data1, reg_data2;
register_file REGISTER_FILE(
  .clk(clk), 
  .wr_ena(reg_write), .wr_addr(rd), .wr_data(result),
  .rd_addr0(rs1), .rd_addr1(rs2),
  .rd_data0(reg_data1), .rd_data1(reg_data2)
);

// Register file unmodified
// logic reg_write;
// logic [4:0] rd, rs1, rs2;
// logic [31:0] rfile_wr_data;
// wire [31:0] reg_data1, reg_data2;
// register_file REGISTER_FILE(
//   .clk(clk), 
//   .wr_ena(reg_write), .wr_addr(rd), .wr_data(rfile_wr_data),
//   .rd_addr0(rs1), .rd_addr1(rs2),
//   .rd_data0(reg_data1), .rd_data1(reg_data2)
// );

// ALU and related control signals
// Feel free to replace with your ALU from the homework.
logic [31:0] src_a, src_b;
alu_control_t alu_control;
wire [31:0] alu_result;
wire overflow, zero, equal;
alu_behavioural ALU (
  .a(src_a), .b(src_b), .result(alu_result),
  .control(alu_control),
  .overflow(overflow), .zero(zero), .equal(equal)
);

// Implement your multicycle rv32i CPU here!

wire ir_write;
logic [31:0] instruction;
register #(.N(32)) INSTRUCTION_REG(
  .clk(clk), .ena(ir_write), .rst(rst), .d(mem_rd_data), .q(instruction)
);

always_comb begin : register_file_inputs
  rs1 = instruction[19:15];
  rs2 = instruction[24:20];
  rd = instruction[11:7];
end

// sign_extender_control_t sign_extender_control;
logic sign_extender_control;
logic [31:0] imm_ext;
sign_extender SIGN_EXTENDER(
  .imm(instruction[31:7]), .imm_src(sign_extender_control), .imm_ext(imm_ext)
);

logic [31:0] a;
register #(.N(32)) A_REG(
  .clk(clk), .ena(1), .rst(rst), .d(reg_data1), .q(a)
);

register #(.N(32)) B_REG(
  .clk(clk), .ena(1), .rst(rst), .d(reg_data2), .q(mem_wr_data)
);

logic [31:0] alu_out;
register #(.N(32)) ALU_RESULT_REG(
  .clk(clk), .ena(1), .rst(rst), .d(alu_result), .q(alu_out)
);

logic adr_src;
always_comb begin : memory_address_select_mux
  case(adr_src)
    0 : mem_addr = PC;
    1 : mem_addr = result;
  endcase
end

logic [31:0] data;
register #(.N(32)) DATA_REGISTER(
  .clk(clk), .ena(1), .rst(rst), .d(mem_rd_data), .q(data)
);

logic [1:0] result_src;
logic [31:0] result;
always_comb begin : result_mux
  case(result_src)
    2'b00 : result = alu_out;
    2'b01 : result = data;
    default result = alu_result;
  endcase
end

logic [1:0] alu_src_a, alu_src_b;
always_comb begin : ALU_SRC_MUXES
  case(alu_src_a)
    2'b00 : src_a = PC;
    2'b01 : src_a = PC_old;
    2'b10 : src_a = a;
    default : src_a = 32'bx;
  endcase

  case(alu_src_b)
    2'b00 : src_b = mem_wr_data;
    2'b01 : src_b = imm_ext;
    2'b10 : src_b = 4;
    default : src_b = 32'bx;
  endcase
end


// always_comb begin : reg_file_inputs
//   rs1 = mem_rd_data[19:15];
//   rs2 = mem_rd_data[24:20];
//   rd = mem_rd_data[11:7];
// end
// always_comb begin : alu_behavioural_src_inputs
//   src_a = reg_data1;
//   src_b = reg_data2;
// end



endmodule
