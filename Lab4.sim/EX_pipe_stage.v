`timescale 1ns / 1ps

module EX_pipe_stage(
    input [31:0] id_ex_instr,
    input [31:0] reg1, reg2,
    input [31:0] id_ex_imm_value,
    input [31:0] ex_mem_alu_result,
    input [31:0] mem_wb_write_back_result,
    input id_ex_alu_src,
    input [1:0] id_ex_alu_op,
    input [1:0] Forward_A, Forward_B,
    output [31:0] alu_in2_out,
    output [31:0] alu_result
    );
    
 // Write your code here  
 wire [3:0] alu_control_out;
 wire [31:0] forward_a_mux4_out;
 // wire [31:0] forward_b_mux4_out;
 wire [31:0] alu_src_mux2_out;
 
 // reg zero_signal;
 // wire [31:0] w_alu_result;
 
 ALUControl ex_alu_control_inst
 (.ALUOp(id_ex_alu_op),
  .Function(id_ex_instr[5:0]),
  .ALU_Control(alu_control_out));

 mux4 #(.mux_width(32)) forward_a_mux4_inst
 (.a(reg1),
 .b(mem_wb_write_back_result),
 .c(ex_mem_alu_result),
 .sel(Forward_A),
 .y(forward_a_mux4_out));
 
  mux4 #(.mux_width(32)) forward_b_mux4_inst
 (.a(reg2),
 .b(mem_wb_write_back_result),
 .c(ex_mem_alu_result),
 .sel(Forward_B),
 .y(alu_in2_out));
 
 mux2 #(.mux_width(32)) alu_src_mux2_inst
    (   .a(alu_in2_out),
        .b(id_ex_imm_value),
        .sel(id_ex_alu_src),
        .y(alu_src_mux2_out));
 
 ALU ex_pipe_alu_inst
 (.a(forward_a_mux4_out),
 .b(alu_src_mux2_out),
 .alu_control(alu_control_out),
 // .zero(zero_signal),
 .alu_result(alu_result));
 
 // output assignments
 // assign alu_result = w_alu_result;
 // assign alu_in2_out = forward_b_mux4_out;

endmodule
