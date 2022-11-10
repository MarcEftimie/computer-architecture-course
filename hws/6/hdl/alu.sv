`timescale 1ns/1ps
`default_nettype none

`include "alu_types.sv"

module alu(a, b, control, result, overflow, zero, equal);
parameter N = 32; // Don't need to support other numbers, just using this as a constant.

input wire [N-1:0] a, b; // Inputs to the ALU.
input alu_control_t control; // Sets the current operation.
output logic [N-1:0] result; // Result of the selected operation.

output logic overflow; // Is high if the result of an ADD or SUB wraps around the 32 bit boundary.
output logic zero;  // Is high if the result is ever all zeros.
output logic equal; // is high if a == b.

logic [N-1:0] sll, srl, sra, add, sub, slt_out, sltu_out;
logic add_overflow, sub_overflow;

mux16 #(.N(N)) MUX_16_result (.in00({N{1'b0}}), .in01(a & b), .in02(a | b),
.in03(a ^ b), .in04({N{1'b0}}), .in05(sll), .in06(srl), .in07(sra), .in08(add),
.in09({N{1'b0}}), .in10({N{1'b0}}), .in11({N{1'b0}}), .in12(sub), .in13(slt_out), .in14({N{1'b0}}),
.in15(~sub_overflow), .select(control), .out(result));

mux16 #(.N(N)) MUX_16_overflow (.in00({N{1'b0}}), .in01({N{1'b0}}), .in02({N{1'b0}}),
.in03({N{1'b0}}), .in04({N{1'b0}}), .in05({N{1'b0}}), .in06({N{1'b0}}), .in07({N{1'b0}}), .in08(add_overflow),
.in09({N{1'b0}}), .in10({N{1'b0}}), .in11({N{1'b0}}), .in12(sub_overflow), .in13({N{1'b0}}), .in14({N{1'b0}}),
.in15({N{1'b0}}), .select(control), .out(overflow));

shift_left_logical #(.N(N)) shift_left_logical_0 (.in(a), .shamt(b), .out(sll));
shift_right_logical #(.N(N)) shift_right_logical_0 (.in(a), .shamt(b), .out(srl));
shift_right_arithmetic #(.N(N)) shift_right_arithmetic_0 (.in(a), .shamt(b), .out(sra));
adder_n #(.N(N)) adder_n_0 (.a(a), .b(b), .c_in(1'b0), .sum(add), .c_out(add_overflow));
subtractor_n #(.N(N)) subtractor_n_0 (.a(a), .b(b), .c_in(1'b0), .sum(sub), .c_out(sub_overflow));
slt #(.N(N)) slt_0 (.a(a), .b(b), .out(slt_out));


always_comb begin
    zero = ~(|result);
    equal = &(a & b);
end

// Use *only* structural logic and previously defined modules to implement an 
// ALU that can do all of operations defined in alu_types.sv's alu_op_code_t.


endmodule