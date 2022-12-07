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
  .clk(clk), .rst(rst), .ena(ir_write), .d(PC), .q(PC_old)
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

logic [1:0] alu_op;
always_comb begin : ALU_DECODER

  case (alu_op)
    2'b00 : alu_control = ALU_ADD;
    2'b01 : alu_control = ALU_SUB;
    2'b10 : begin
      case (instruction[14:12])
        3'b000 : begin
          // case ({instruction[5], instruction[29]})
          //   2'b11 : alu_control = ALU_SUB;
          //   default : alu_control = ALU_ADD;
          // endcase
          case (instruction[31:25])
            7'b0000000 : alu_control = ALU_ADD;
            7'b0100000 : alu_control = ALU_SUB;
          endcase
        end
        3'b001 : alu_control = ALU_SLL;
        3'b010 : alu_control = ALU_SLT;
        3'b011 : alu_control = ALU_SLTU;
        3'b100 : alu_control = ALU_XOR;
        3'b101 : begin
          case (instruction[31:25])
          7'b0000000 : alu_control = ALU_SRL;
          7'b0100000 : alu_control = ALU_SRA;
          endcase
        end
        3'b110 : alu_control = ALU_OR;
        3'b111 : alu_control = ALU_AND;
      endcase
    end
      
  endcase
end

logic branch;
logic pc_write1;
logic pc_write2;
logic zero_result;
logic invert_zero;
logic jump;
always_comb begin 
  zero_result = invert_zero ? ~zero : zero;
  pc_write2 = zero_result && branch;
  PC_ena = pc_write1 || pc_write2 || jump;
end

enum logic [4:0] {FETCH, DECODE, MEM_ADR, MEM_READ, MEM_WRITE, MEM_WB,
            EXECUTE_R, EXECUTE_I, JAL, ALU_WB, BEQ, BNE, DECODE_WAIT,
            MEM_ADR_WAIT, MEM_READ_WAIT, ALU_WB_WAIT, MEM_WB_WAIT} cycle;

always_ff @(posedge clk) begin

  case (cycle)
    FETCH : begin
      invert_zero <= 0;
      branch <= 0;
      pc_write1 <= 1;
      adr_src <= 0;
      mem_wr_ena <= 0;
      ir_write <= 1;
      reg_write <= 0;
      alu_src_a <= 2'b00;
      alu_src_b <= 2'b10;
      alu_op <= 2'b00;
      result_src <= 2'b10;
      cycle <= DECODE;
    end
    DECODE : begin
      mem_wr_ena <= 0;
      // imm_src <= 2'b00;
      alu_src_a <= 2'b01;
      alu_src_b <= 2'b01;
      pc_write1 <= 0;
      ir_write <= 0;
      alu_op <= 2'b00;
      cycle <= DECODE_WAIT;
    end
    DECODE_WAIT : begin
      // mem_wr_ena <= 0;
      // imm_src <= 2'b00;
      // PC_ena <= 0;
      // ir_write <= 0;
      // alu_op <= 2'b00;
      case (instruction[6:0])
        7'b0000011 : imm_src <= 2'b00;
        7'b0100011 : imm_src <= 2'b01;
        default : imm_src <= 2'b00;
      endcase
      case (instruction[6:0])
        7'b0000011 : cycle <= MEM_ADR;
        7'b0100011 : cycle <= MEM_ADR;
        7'b0110011 : cycle <= EXECUTE_R;
        7'b0010011 : cycle <= EXECUTE_I;
        7'b1101111 : cycle <= JAL;
        7'b1100011 : begin
          case (instruction[14:12])
            3'b000 : cycle <= BEQ;
            3'b001 : cycle <= BNE;
          endcase
        end
        
      endcase
    end
    MEM_ADR : begin
      alu_src_a <= 2'b10;
      alu_src_b <= 2'b01;
      alu_op <= 2'b00;
      cycle <= MEM_ADR_WAIT;
    end
    MEM_ADR_WAIT : begin
      case (instruction[6:0])
        7'b0000011 : cycle <= MEM_READ;
        7'b0100011 : cycle <= MEM_WRITE;
      endcase
    end
    EXECUTE_R : begin
      alu_src_a <= 2'b10;
      alu_src_b <= 2'b00;
      alu_op <= 2'b10;
      cycle <= ALU_WB;
    end
    EXECUTE_I : begin
      alu_src_a <= 2'b10;
      alu_src_b <= 2'b01;
      alu_op <= 2'b10;
      cycle <= ALU_WB;
    end
    JAL : begin
      alu_src_a <= 2'b01;
      alu_src_b <= 2'b10;
      alu_op <= 2'b00;
      result_src <= 2'b00;
      // PC_ena <= 1;
      jump <= 1;
      cycle <= ALU_WB;
    end
    BEQ : begin
      alu_src_a <= 2'b10;
      alu_src_b <= 2'b00;
      alu_op <= 2'b01;
      result_src <= 2'b00;
      branch <= 1;
      cycle <= FETCH;
    end
    BNE : begin
      alu_src_a <= 2'b10;
      alu_src_b <= 2'b00;
      alu_op <= 2'b01;
      result_src <= 2'b00;
      branch <= 1;
      invert_zero <= 1;
      cycle <= FETCH;
    end
    MEM_READ : begin
      adr_src <= 1;
      result_src <= 2'b00;
      cycle <= MEM_READ_WAIT;
    end
    MEM_READ_WAIT : begin
      cycle <= MEM_WB;
    end
    MEM_WRITE : begin
      result_src <= 2'b00;
      adr_src <= 1;
      mem_wr_ena <= 1;
      cycle <= FETCH;
    end
    ALU_WB : begin
      jump <= 0;
      result_src <= 2'b00;
      reg_write <= 1;
      cycle <= FETCH;
      // cycle <= ALU_WB_WAIT;
    end
    // ALU_WB_WAIT : begin
    //   cycle <= FETCH;
    // end
    MEM_WB : begin
      result_src <= 2'b01;
      reg_write <= 1;
      cycle <= MEM_WB_WAIT;
    end
    MEM_WB_WAIT : begin
      reg_write <= 0;
      cycle <= FETCH;
    end
    
    default : cycle <= FETCH;
  endcase
  
end

// wire ir_write;
logic ir_write;
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
logic [1:0] imm_src;
logic [31:0] imm_ext;
sign_extender SIGN_EXTENDER(
  .imm(instruction[31:7]), .imm_src(imm_src), .imm_ext(imm_ext)
);

logic [31:0] a;
register #(.N(32)) A_REG(
  .clk(clk), .ena(1'b1), .rst(rst), .d(reg_data1), .q(a)
);

register #(.N(32)) B_REG(
  .clk(clk), .ena(1'b1), .rst(rst), .d(reg_data2), .q(mem_wr_data)
);

logic [31:0] alu_out;
register #(.N(32)) ALU_RESULT_REG(
  .clk(clk), .ena(1'b1), .rst(rst), .d(alu_result), .q(alu_out)
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
    2'b10 : result = alu_result;
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


  // // if (counter == 4'bxxxx) begin
  // //   counter <= 0;
  // // end
  // case (instruction[6:0])
  //   7'b0000011 : alu_op <= 2'b00;
  //   7'b0100011 : alu_op <= 2'b01;
  //   7'b0110011 : alu_op <= 2'bxx;
  //   7'b1100011 : alu_op <= 2'b10;
  //   7'b0010011 : alu_op <= 2'b10;
  // endcase
  // case (counter)
  //   4 : begin
  //     case (instruction[6:0])
  //       // MemWB
  //       7'b0000011 : begin
  //         result_src <= 2'b01;
  //         reg_write <= 1;
  //         counter <= counter + 1;
  //       end
  //     endcase
  //   end
  //   3: begin
  //     case (instruction[6:0])
  //       // MemRead
  //       7'b0000011 : begin
  //         adr_src <= 1;
  //         result_src <= 2'b00;
  //         counter <= counter + 1;
  //       end
  //       // MemWrite
  //       7'b0100011 : begin
  //         result_src <= 2'b00;
  //         adr_src <= 1;
  //         mem_wr_ena <= 1;
  //         counter <= counter + 2;
  //       end
  //       // ALUWB
  //       7'b0110011 : begin
  //         result_src <= 2'b00;
  //         reg_write <= 1;
  //         counter <= counter + 2;
  //       end
  //       // Also ALUWB
  //       7'b0010011 : begin
  //         result_src <= 2'b00;
  //         reg_write <= 1;
  //         counter <= counter + 2;
  //       end
          
  //     endcase
  //   end
  //   2: begin
  //     case (instruction[6:0])
  //       // ExecuteR
  //       7'b0110011 : begin
  //         alu_src_a <= 2'b10;
  //         alu_src_b <= 2'b00;
  //         counter <= counter + 1;
  //       end
  //       // ExecuteI
  //       7'b0010011 : begin
  //         alu_src_a <= 2'b10;
  //         alu_src_b <= 2'b01;
  //         counter <= counter + 1;
  //       end
  //       // MemAdr
  //       default : begin
  //         alu_src_a <= 2'b10;
  //         alu_src_b <= 2'b01;
  //         counter <= counter + 1;
  //       end
  //     endcase
  //   end
  //   // Decode
  //   1: begin
  //     mem_wr_ena <= 0;
  //     imm_src <= 2'b00;
  //     PC_ena <= 0;
  //     ir_write <= 0;
  //     counter <= counter + 1;
  //   end
  //   // Fetch
  //   0 : begin
  //     adr_src <= 0;
  //     mem_wr_ena <= 0;
  //     ir_write <= 1;
  //     reg_write <= 0;
  //     PC_ena <= 1;
  //     alu_src_a <= 2'b00;
  //     alu_src_b <= 2'b10;
  //     result_src <= 2'b10;
  //     alu_op <= 2'b00;
  //     counter <= counter + 1;
  //   end
  //   default : begin
  //     // if (counter % 2 == 1) begin
  //     //   counter <= counter + 1;
  //     // end else begin
  //     //   counter <= 0;
  //     // end
  //     counter <= 0;
  //   end
  // endcase
endmodule
