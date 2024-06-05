`timescale 1ns / 1ps


module mips_32(
    input clk, reset,  
    output[31:0] result
    );

wire en; // inputs
wire [9:0] branch_address;
wire [9:0] jump_address;
wire branch_taken;
wire jump;
wire [9:0] pc_plus4; // outputs
wire [31:0] instr;

wire [9:0] if_id_pc_plus4;
wire [31:0] if_id_instr;

wire mem_wb_reg_write;
wire [4:0] mem_wb_write_reg_addr;
wire [31:0] mem_wb_write_back_data;
wire Data_Hazard;
// wire Control_Hazard;
wire [31:0] reg1;
wire [31:0] reg2;
wire [31:0] imm_value;
wire [4:0] destination_reg;
wire mem_to_reg;
wire [1:0] alu_op;
wire mem_read;
wire mem_write;
wire alu_src;
wire reg_write;
wire IF_Flush;

wire [4:0] mem_wb_destination_reg;
wire [31:0] write_back_data;

wire [31:0] id_ex_instr;
wire [31:0] id_ex_reg1;
wire [31:0] id_ex_reg2;
wire [31:0] id_ex_imm_value;

wire [4:0] id_ex_destination_reg;
wire id_ex_mem_to_reg;
wire [1:0] id_ex_alu_op;
wire id_ex_mem_read;
wire id_ex_mem_write;
wire id_ex_alu_src;
wire id_ex_reg_write;

wire [31:0] ex_mem_instr;
wire [31:0] ex_mem_alu_result;

wire [1:0] Forward_A;
wire [1:0] Forward_B;

 wire [31:0] alu_in2_out;
 wire [31:0] alu_result;
 
wire ex_mem_reg_write;
wire [4:0] ex_mem_write_reg_addr;
wire [4:0] id_ex_instr_rs;
wire [4:0] id_ex_instr_rt;

// wire [31:0] id_ex_instr;
wire [4:0] ex_mem_destination_reg;
// wire [31:0] ex_mem_alu_result;
wire [31:0] ex_mem_alu_in2_out;

wire ex_mem_mem_to_reg;
wire ex_mem_mem_read;
wire ex_mem_mem_write;
// wire ex_mem_reg_write;

wire [31:0] mem_read_data;

wire [31:0] mem_wb_alu_result;
wire [31:0] mem_wb_mem_read_data;
wire mem_wb_mem_to_reg;
// wire mem_wb_reg_write;
// wire [4:0] mem_wb_destination_reg;

// Build the pipeline as indicated in the lab manual

IF_pipe_stage IF_unit
(
.clk(clk), // input
.reset(reset), // input
.en(Data_Hazard), // input
.branch_address(branch_address), // input
.jump_address(jump_address), // input
.branch_taken(branch_taken), // input
.jump(jump), // input
.pc_plus4(pc_plus4), // output
.instr(instr) // output
);

pipe_reg_en #(.WIDTH(10)) if_id_pipe_reg_inst_pc_plus4 // double check
(.clk(clk),
.reset(reset),
.en(Data_Hazard),
.flush(IF_Flush),
.d(pc_plus4),
.q(if_id_pc_plus4));

pipe_reg_en #(.WIDTH(32)) if_id_pipe_reg_inst_instr // double check
(.clk(clk),
.reset(reset),
.en(Data_Hazard),
.flush(IF_Flush),
.d(instr),
.q(if_id_instr));

ID_pipe_stage id_pipe_inst
(.clk(clk), 
.reset(reset),
.pc_plus4(if_id_pc_plus4),
.instr(if_id_instr),
.mem_wb_reg_write(mem_wb_reg_write),
.mem_wb_write_reg_addr(mem_wb_destination_reg),
.mem_wb_write_back_data(write_back_data),
.Data_Hazard(Data_Hazard),
.Control_Hazard(IF_Flush),
.reg1(reg1), 
.reg2(reg2),
.imm_value(imm_value),
.branch_address(branch_address),
.jump_address(jump_address),
.branch_taken(branch_taken),
.destination_reg(destination_reg), 
.mem_to_reg(mem_to_reg),
.alu_op(alu_op),
.mem_read(mem_read),  
.mem_write(mem_write),
.alu_src(alu_src),
.reg_write(reg_write),
.jump(jump));
	
pipe_reg #(.WIDTH(32)) if_id_instr_reg (.clk(clk), .reset(reset), .d(if_id_instr), .q(id_ex_instr));
pipe_reg #(.WIDTH(32)) reg1_reg (.clk(clk), .reset(reset), .d(reg1), .q(id_ex_reg1));
pipe_reg #(.WIDTH(32)) reg2_reg (.clk(clk), .reset(reset), .d(reg2), .q(id_ex_reg2));
pipe_reg #(.WIDTH(32)) imm_value_reg (.clk(clk), .reset(reset), .d(imm_value), .q(id_ex_imm_value));
pipe_reg #(.WIDTH(5)) destination_reg_reg (.clk(clk), .reset(reset), .d(destination_reg), .q(id_ex_destination_reg));
pipe_reg #(.WIDTH(1)) mem_to_reg_reg (.clk(clk), .reset(reset), .d(mem_to_reg), .q(id_ex_mem_to_reg));
pipe_reg #(.WIDTH(2)) alu_op_reg_reg (.clk(clk), .reset(reset), .d(alu_op), .q(id_ex_alu_op));
pipe_reg #(.WIDTH(1)) mem_read_reg (.clk(clk), .reset(reset), .d(mem_read), .q(id_ex_mem_read));
pipe_reg #(.WIDTH(1)) mem_write_reg (.clk(clk), .reset(reset), .d(mem_write), .q(id_ex_mem_write));
pipe_reg #(.WIDTH(1)) alu_src_reg (.clk(clk), .reset(reset), .d(alu_src), .q(id_ex_alu_src));
pipe_reg #(.WIDTH(1)) reg_write_reg (.clk(clk), .reset(reset), .d(reg_write), .q(id_ex_reg_write));

Hazard_detection HA_unit_inst
(.id_ex_mem_read(id_ex_mem_read),
.id_ex_destination_reg(id_ex_destination_reg),
.if_id_rs(if_id_instr[25:21]),
.if_id_rt(if_id_instr[20:16]),
.branch_taken(branch_taken),
.jump(jump),
.Data_Hazard(Data_Hazard),
.IF_Flush(IF_Flush)
);
            
EX_pipe_stage ex_pipe_stage_inst
(.id_ex_instr(id_ex_instr),
.reg1(id_ex_reg1),
.reg2(id_ex_reg2),
.id_ex_imm_value(id_ex_imm_value),
.ex_mem_alu_result(ex_mem_alu_result),
.mem_wb_write_back_result(write_back_data),
.id_ex_alu_src(id_ex_alu_src),
.id_ex_alu_op(id_ex_alu_op),
.Forward_A(Forward_A),
.Forward_B(Forward_B),
.alu_in2_out(alu_in2_out),
.alu_result(alu_result)
);

EX_Forwarding_unit ex_forward_inst
(
.ex_mem_reg_write(ex_mem_reg_write),
.ex_mem_write_reg_addr(ex_mem_destination_reg),
.id_ex_instr_rs(id_ex_instr[25:21]),
.id_ex_instr_rt(id_ex_instr[20:16]),
.mem_wb_reg_write(mem_wb_reg_write),
.mem_wb_write_reg_addr(mem_wb_destination_reg),
.Forward_A(Forward_A),
.Forward_B(Forward_B)
);

pipe_reg #(.WIDTH(32)) id_ex_instr_reg (.clk(clk), .reset(reset), .d(id_ex_instr), .q(ex_mem_instr));
pipe_reg #(.WIDTH(5)) id_ex_destination_reg_reg (.clk(clk), .reset(reset), .d(id_ex_destination_reg), .q(ex_mem_destination_reg));
pipe_reg #(.WIDTH(32)) alu_result_reg (.clk(clk), .reset(reset), .d(alu_result), .q(ex_mem_alu_result));
pipe_reg #(.WIDTH(32)) alu_in2_out_reg (.clk(clk), .reset(reset), .d(alu_in2_out), .q(ex_mem_alu_in2_out));

pipe_reg #(.WIDTH(1)) id_ex_mem_to_reg_reg (.clk(clk), .reset(reset), .d(id_ex_mem_to_reg), .q(ex_mem_mem_to_reg));
pipe_reg #(.WIDTH(1)) id_ex_mem_read_reg (.clk(clk), .reset(reset), .d(id_ex_mem_read), .q(ex_mem_mem_read));
pipe_reg #(.WIDTH(1)) id_ex_mem_write_reg (.clk(clk), .reset(reset), .d(id_ex_mem_write), .q(ex_mem_mem_write));
pipe_reg #(.WIDTH(1)) id_ex_reg_write_reg (.clk(clk), .reset(reset), .d(id_ex_reg_write), .q(ex_mem_reg_write));

data_memory data_mem
(.clk(clk), // ex_mem_instr
.mem_access_addr(ex_mem_alu_result),
.mem_write_data(ex_mem_alu_in2_out), // are 1 and 2 in correct order or need to be swapped?
.mem_write_en(ex_mem_mem_write),
.mem_read_en(ex_mem_mem_read),
.mem_read_data(mem_read_data)
);
	
pipe_reg #(.WIDTH(32)) ex_mem_alu_result_reg (.clk(clk), .reset(reset), .d(ex_mem_alu_result), .q(mem_wb_alu_result));
pipe_reg #(.WIDTH(32)) mem_read_data_reg (.clk(clk), .reset(reset), .d(mem_read_data), .q(mem_wb_mem_read_data));
pipe_reg #(.WIDTH(1)) ex_mem_mem_to_reg_reg (.clk(clk), .reset(reset), .d(ex_mem_mem_to_reg), .q(mem_wb_mem_to_reg));
pipe_reg #(.WIDTH(1)) ex_mem_reg_write_reg (.clk(clk), .reset(reset), .d(ex_mem_reg_write), .q(mem_wb_reg_write));
pipe_reg #(.WIDTH(5)) ex_mem_destination_reg_reg (.clk(clk), .reset(reset), .d(ex_mem_destination_reg), .q(mem_wb_destination_reg));

mux2 #(.mux_width(32)) write_back_mux_inst
(
.a(mem_wb_alu_result),
.b(mem_wb_mem_read_data),
.sel(mem_wb_mem_to_reg),
.y(write_back_data)
);

assign result = write_back_data;
    
endmodule
