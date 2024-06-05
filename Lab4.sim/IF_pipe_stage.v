`timescale 1ns / 1ps


module IF_pipe_stage(
    input clk, reset,
    input en,
    input [9:0] branch_address,
    input [9:0] jump_address,
    input branch_taken,
    input jump,
    output [9:0] pc_plus4,
    output [31:0] instr
    );
    

reg [9:0] pc;
// wire [9:0] jump_branch_pc;

wire [9:0] branch_mux_out;
wire [9:0] jump_mux_out;

// assign pc_plus4 = pc + 10'b0000000100;
assign pc_plus4 = pc + 10'b0000000100;


always @(posedge clk or posedge reset) 
begin
    if(reset)
        pc <= 10'b0000000000;
    else if (en)
        pc <= jump_mux_out;
end


    
 instruction_mem ins_read
    (.read_addr(pc),
     .data(instr));
        
 mux2 #(.mux_width(10)) branch_mux
    (   .a(pc_plus4  ),
        .b(branch_address),
        .sel(branch_taken),
        .y(branch_mux_out));    
        
 mux2 #(.mux_width(10)) jump_mux
    (   .a(branch_mux_out),
        .b(jump_address),
        .sel(jump),
        .y(jump_mux_out));


endmodule
