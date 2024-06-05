`timescale 1ns / 1ps


module ID_pipe_stage(
    input  clk, reset,
    input  [9:0] pc_plus4,
    input  [31:0] instr,
    input  mem_wb_reg_write,
    input  [4:0] mem_wb_write_reg_addr,
    input  [31:0] mem_wb_write_back_data,
    input  Data_Hazard,
    input  Control_Hazard,
    output [31:0] reg1, reg2,
    output [31:0] imm_value,
    output [9:0] branch_address,
    output [9:0] jump_address,
    output branch_taken,
    output [4:0] destination_reg, 
    output mem_to_reg,
    output [1:0] alu_op,
    output mem_read,  
    output mem_write,
    output alu_src,
    output reg_write,
    output jump
    );

wire [31:0] sign_extend_out;
wire [31:0] reg_read_data_out_1;
wire [31:0] reg_read_data_out_2;

wire mem_to_reg_temp;
wire [1:0] alu_op_temp;
wire mem_read_temp;
wire mem_write_temp;
wire alu_src_temp;
wire reg_write_temp;
wire branch;
wire [4:0] reg_dst; // reg_dst
wire pipeline_hazard_detection_signal;
wire eq_test;
 
 assign pipeline_hazard_detection_signal = ((~Data_Hazard) | Control_Hazard);

 // intermediate path connections
 assign eq_test = ((reg1^reg2)==32'd0) ? 1'b1 : 1'b0;
 assign branch_taken = eq_test & branch;
 assign branch_address = (imm_value<<2) + pc_plus4;
 assign jump_address = (instr[25:0]<<2);
 

register_file id_reg_file_inst
 (  .clk(clk), 
    .reset(reset),  
    .reg_write_en(mem_wb_reg_write),  
    .reg_write_dest(mem_wb_write_reg_addr),  
    .reg_write_data(mem_wb_write_back_data),
    .reg_read_addr_1(instr[25:21]),
    .reg_read_addr_2(instr[20:16]),  
    .reg_read_data_1(reg1),  
    .reg_read_data_2(reg2)
    );
    
 sign_extend id_sign_extend
 (  .sign_ex_in(instr[15:0]),
    .sign_ex_out(imm_value));
    
 mux2 #(.mux_width(5)) reg_dest_cal
    (   .a(instr[20:16]),
        .b(instr[15:11]),
        .sel(reg_dst),
        .y(destination_reg));
 
 mux2 #(.mux_width(1)) mem_to_reg_mux
    (   .a(mem_to_reg_temp),
        .b(1'b0),
        .sel(pipeline_hazard_detection_signal),
        .y(mem_to_reg));
 
  mux2 #(.mux_width(2)) alu_op_mux
    (   .a(alu_op_temp),
        .b(2'b0),
        .sel(pipeline_hazard_detection_signal),
        .y(alu_op)); // actual bit length 2 differs from formal bit length 1
  
  mux2 #(.mux_width(1)) mem_read_mux
    (   .a(mem_read_temp),
        .b(1'b0),
        .sel(pipeline_hazard_detection_signal),
        .y(mem_read));
  
  mux2 #(.mux_width(1)) mem_write_mux
    (   .a(mem_write_temp),
        .b(1'b0),
        .sel(pipeline_hazard_detection_signal),
        .y(mem_write));
  
  mux2 #(.mux_width(1)) alu_src_mux
    (   .a(alu_src_temp),
        .b(1'b0),
        .sel(pipeline_hazard_detection_signal),
        .y(alu_src));
  
  mux2 #(.mux_width(1)) reg_write_mux
    (   .a(reg_write_temp),
        .b(1'b0),
        .sel(pipeline_hazard_detection_signal),
        .y(reg_write));
  
 
 control id_control(
 .reset(reset),
 .opcode(instr[31:26]),
 .reg_dst(reg_dst), // will naming conventions mess things up?
 .mem_to_reg(mem_to_reg_temp),
 .alu_op(alu_op),
 .mem_read(mem_read_temp),
 .mem_write(mem_write_temp),
 .alu_src(alu_src_temp),
 .reg_write(reg_write_temp),
 .branch(branch),
 .jump(jump));
 
 

endmodule
