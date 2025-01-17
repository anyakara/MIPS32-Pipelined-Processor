# MIPS Pipelined Processor
High-level block designs for MIPS 32 bit processor with pipelining & forwarding controls, hazard detection, and timing. Tested and verified in EECS 112L course on Organization of Computers. Designed to simulate current architecture for sequential processing with parallelized features introduced to increase efficiency.

Pipelined implementation features a datapath that is divided into separate stages, steps that allow for techniques like forwarding and hazard detection to make the processor more efficient in executing more instructions in relative clock cycle. The primary goal of an implementation like this is to ensure that all stages of the processor are kept busy at all times with some instruction.

## Project Overview
Classically, these are split into five stages:
- Instruction Fetch (IF): process the instruction from memory.
- Instruction Decoding (ID): read the registers while decoding the instruction).
- Execution (EXE): perform the necessary operation or calculation of address.
- Memory (MEM): access an operand in data memory (a clear incentive for forwarding techniques to be implemented to save clock cycles in implementation)
- Write Back (WB): save the result into a register.

<img width="1071" alt="Screenshot 2024-06-03 at 10 52 52 PM" src="https://github.com/anyakara/mips32-processor/assets/66985689/b44277e3-5732-417d-870e-dfcd737ebb12">


**Processor Design**: to handle the situations where instructions cannot execute in subsequent clock cycle due to data not being loaded for instance, the process utilizes hazard control systems. There are three main types of hazards that architectures like MIPS pipelined handle. These include:
* Structural hazard
* Data hazard
* Control hazard

To avoid delay in pipeline, forwarding is used to ensure that particular data dependencies are detected before hand to prevent lockout and to add the required paths to enable forwarding. 

While these mechnanisms ensure that instructions that are executing keep all stages busy, there are cases where **stalling** may be required, where the processor simply halts for a clock cycle or two to ensure that hazards are detected properly. This is done in the Hazard Detection unit of the processor pipeline.

## Instruction Fetch
In this stage, instructions are read from memory utilizing the address in the PC and placed in IF/ID piepline registers. If the instruction is not of type branch or jump, the program_counter (PC) is incremented +4 and updated for next clock cycle. Otherwise, for branch and jump, branch address and jump address, calculated within a particular subunit are used to calculate the next address for program_counter. Select signals are used to trigger the combination for particular branch and jump addresses. The processor will not know which type of instruction is fetched, and thus must pass necessary information down pipeline for future use.

## Instruction Decode
The instruction segment includes the instruction fetch and decode piepline registers supplying a sixteen bit immediate field, with sign-extension to thirty-two bits and register numbers to read registers. Branch and jump addresses will be calculated here, and there is an equality test unit that helps determine if a branch is taken or not. It is important to pay attention to the read and write tasks with respect to clock. The register file operates in the way to use effectively two half clock cycles, with first half clock cycle reading and the second half clock cycle to trigger writing.

## Hazard Detection
There are instances where we need to stall the pipeline. Specifically, when a branch instruction is in the Decode stage the next instruction after that would be in the Instruction Fetch stage. A NOP is inserted in the pipeline when there is a branch taken and we jump to another address and get rid of the instruction that is present in the IF stage.

## Execution

## Memory

## Write Back

## Timing Diagram for Reference for DUT (Design Under Test)

## Applications & Next Steps
The purpose of this project is to solidify the understanding of important principles and building blocks of computer architecture using existing architectures and specifications to design one particular configuration for purpose of design, testing, and minor enhancements. The future holds bright for in-memory and near-memory architectures that move away from the concept of sequential processing for large-scale data intensive processes. The likelihood of encountering a sequential processor that is continued to be used in the near decade for any sort of large scale computing task will be few. While they do stand as optimal, fast architectures to run a typical user's workload for a day's job, utilizing such for a massive task, such as decoding genomes to detect disease or fold proteins utilizing their chemical make-up, or process high-quality camera footage in real-time mission critical systems like drones, or safety focused self-driving systems require alternative architectures. 

My goal as a student is to understand this material, but more beyond my goal as a researcher, as an engineer and as a scientist is to devise or implement noval architectures that accelerate computing for tasks mentioned. A follow-up repository includes the building blocks for high-level designs of Graphics Processing Units which achieve amazing throughput for data intensive operations and Tensor Processing Units which also employ matrix operations to make the process of vector math (scaling / dot products) efficient for large-scale implementation.

Sample Snippet Code (template example and not original):
```
module matrix_multiplication #(
    parameter DATA_WIDTH = 16,
    parameter MATRIX_SIZE = 4
)(
    input clk,
    input reset,
    input [DATA_WIDTH-1:0] A [MATRIX_SIZE-1:0][MATRIX_SIZE-1:0],
    input [DATA_WIDTH-1:0] B [MATRIX_SIZE-1:0][MATRIX_SIZE-1:0],
    output reg [DATA_WIDTH-1:0] C [MATRIX_SIZE-1:0][MATRIX_SIZE-1:0]
);

integer i, j, k;
reg [DATA_WIDTH-1:0] temp;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        for (i = 0; i < MATRIX_SIZE; i = i + 1) begin
            for (j = 0; j < MATRIX_SIZE; j = j + 1) begin
                C[i][j] <= 0;
            end
        end
    end else begin
        for (i = 0; i < MATRIX_SIZE; i = i + 1) begin
            for (j = 0; j < MATRIX_SIZE; j = j + 1) begin
                temp = 0;
                for (k = 0; k < MATRIX_SIZE; k = k + 1) begin
                    temp = temp + A[i][k] * B[k][j];
                end
                C[i][j] <= temp;
            end
        end
    end
end

endmodule
```
This module is an example matrix multiplication unit written in Verilog as a precurser to architectures at use more space for data processing in memory, and keep all logical components close to data for optimized performance.
