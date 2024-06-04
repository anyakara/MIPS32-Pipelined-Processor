# MIPS PROCESSOR
High-level block designs for MIPS 32 bit processor with pipelining & forwarding controls, hazard detection, and timing. Tested and verified in EECS 112L course on Organization of Computers. Designed to simulate current architecture for sequential processing with parallelized features introduced to increase efficiency.

Pipelined implementation features a datapath that is divided into separate stages, steps that allow for techniques like forwarding and hazard detection to make the processor more efficient in executing more instructions in relative clock cycle. The primary goal of an implementation like this is to ensure that all stages of the pocessor are kept busy at all times with some instruction.

## Project Overview
Classically, these are split into five stages:
- Instruction Fetch (IF): process the instruction from memory.
- Instruction Decoding (D): read the registers while decoding the instruction).
- Execution (EXE): perform the necessary operation or calculation of address.
- Memory (MEM): access an operand in data memory (a clear incentive for forwarding techniques to be implemented to save clock cycles in implementation)
- Write Back (WB): save the result into a register.

**Processor Design**: to handle the situations where instructions cannot execute in subsequent clock cycle due to data not being loaded for instance, the process utilizes hazard control systems. There are three main types of hazards that architectures like MIPS pipelined handle, these include:
* Structural hazard
* Data hazard
* Control hazard

To avoid delay in pipeline, forwarding is used to ensure that particular data dependencies are detected before hand to prevent lockout and to add the required paths to enable forwarding. 

While these mechnanisms ensure that instructions that are executing keep all stages busy, there are cases where **stalling** may be required, where the processor simply halts for a clock cycle or two to ensure that hazards are detected properly. This is done in the Hazard Detection unit of the processor pipeline.

## Instruction Fetch
Brief: In this stage, instructions are read from memory utilizing the address in the PC and placed in IF/ID piepline registers. If the instruction is not of type branch or jump, the program_counter (PC) is incremented +4 and updated for next clock cycle. Otherwise, for branch and jump, branch address and jump address, calculated within a particular subunit are used to calculate the next address for program_counter. Select signals are used to trigger the combination for particular branch and jump addresses. The processor will not know which type of instruction is fetched, and thus must pass necessary information down pipeline for future use.

## Instruction Decode


## Hazard Detection


## Execution


## Memory


## Write Back


Some material may be adapted from EECS 112L professor and course material for in-depth context of this project.
