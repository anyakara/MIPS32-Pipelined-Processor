`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/17/2020 11:41:22 AM
// Design Name:
// Module Name: tb_mips_32
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module tb_mips_32_grading;
//    for test  cur_time
      integer cur_time ;

      reg clk;
      reg reset;
      // Outputs

      wire [31:0] result;
      // Instantiate the Unit Under Test (UUT)
      mips_32 uut (
           .clk(clk),
           .reset(reset),
           .result(result)
      );

      real points = 0;


      initial begin
           clk = 0;
           forever #10 clk = ~clk;
      end
      initial begin
           // Initialize Inputs

           reset = 1;
           // Wait 100 ns for global reset to finish
           #100;
           reset = 0;
           // store some data in data memory
           uut.data_mem.ram[0]= 32'b00000000000000000000000000000001;// 00000001
           uut.data_mem.ram[1]= 32'b00001111110101110110111000010000;// 0fd76e10
           uut.data_mem.ram[2]= 32'b01011010000000000100001010011011;// 5a00429b
           uut.data_mem.ram[3]= 32'b00010100001100110011111111111100;// 14333ffc
           uut.data_mem.ram[4]= 32'b00110010000111111110110111001011;// 321fedcb
           uut.data_mem.ram[5]= 32'b10000000000000000000000000000000;// 80000000
           uut.data_mem.ram[6]= 32'b10010000000100101111110101100101;// 9012fd65
           uut.data_mem.ram[7]= 32'b10101011110000000000001000110111;// abc00237
           uut.data_mem.ram[8]= 32'b10110101010010111100000000110001;// b54bc031
           uut.data_mem.ram[9]= 32'b11000001100001111010011000000110;// c187a606

          #1500;


          if(uut.data_mem.ram[11]==32'h0fd76e00) $display("*NO_DEPENDENCY_ANDI* =  	{1}"); else $display("*NO_DEPENDENCY_ANDI* =  	{0}");
          if(uut.data_mem.ram[12]==32'hf02891ee) $display("*NO_DEPENDENCY_NOR* =   	{1}"); else $display("*NO_DEPENDENCY_NOR* =   	{0}");
          if(uut.data_mem.ram[13]==32'h00000001) $display("*NO_DEPENDENCY_SLT* =   	{1}"); else $display("*NO_DEPENDENCY_SLT* =   	{0}");
          if(uut.data_mem.ram[14]==32'h7ebb7080) $display("*NO_DEPENDENCY_SLL* =   	{1}"); else $display("*NO_DEPENDENCY_SLL* =   	{0}");
          if(uut.data_mem.ram[15]==32'h00000000) $display("*NO_DEPENDENCY_SRL* =   	{1}"); else $display("*NO_DEPENDENCY_SRL* =   	{0}");
          if(uut.data_mem.ram[16]==32'hfe000000) $display("*NO_DEPENDENCY_SRA* =   	{1}"); else $display("*NO_DEPENDENCY_SRA* =   	{0}");
          if(uut.data_mem.ram[17]==32'h00000000) $display("*NO_DEPENDENCY_XOR* =   	{1}"); else $display("*NO_DEPENDENCY_XOR* =   	{0}");
          if(uut.data_mem.ram[18]==32'h0fd76e10) $display("*NO_DEPENDENCY_MULT* =  	{1}"); else $display("*NO_DEPENDENCY_MULT* =  	{0}");
          if(uut.data_mem.ram[19]==32'h0fd76e10) $display("*NO_DEPENDENCY_DIV* =   	{1}"); else $display("*NO_DEPENDENCY_DIV* =   	{0}");
                 
          if(uut.data_mem.ram[20]==32'h00000d61) $display("*ANDI_No_Forwarding* =        {1}"); else $display("*ANDI_No_Forwarding* =      {0}");
          if(uut.data_mem.ram[21]==32'hf028908e) $display("*Forward_EX_MEM_to_EX_B* =    {1}"); else $display("*Forward_EX_MEM_to_EX_B* =  {0}");
          if(uut.data_mem.ram[22]==32'h00000001) $display("*Forward_MEM_WB_to_EX_A1* = 	{1}"); else $display("*Forward_MEM_WB_to_EX_A1* = 	{0}");
          if(uut.data_mem.ram[23]==32'h5faca000) $display("*SLL_No_Forwarding* = 		{1}"); else $display("*SLL_No_Forwarding* = 		{0}");
          if(uut.data_mem.ram[24]==32'h00bf5940) $display("*Forward_EX_MEM_to_EX_A* = 	{1}"); else $display("*Forward_EX_MEM_to_EX_A* = 	{0}");
          if(uut.data_mem.ram[25]==32'h17eb2800) $display("*Forward_MEM_WB_to_EX_A2* = 	{1}"); else $display("*Forward_MEM_WB_to_EX_A2* = 	{0}");
          if(uut.data_mem.ram[26]==32'h9fc59375) $display("*XOR_No_Forwarding* = 		{1}"); else $display("*XOR_No_Forwarding* = 		{0}");
          if(uut.data_mem.ram[27]==32'he4e43c50) $display("*MULT_No_Forwarding* = 		{1}"); else $display("*MULT_No_Forwarding* = 		{0}");
          if(uut.data_mem.ram[28]==32'h00000000) $display("*Forward_MEM_WB_to_EX_B* = 	{1}"); else $display("*Forward_MEM_WB_to_EX_B* = 	{0}");

          // Data Hazard is the result of dependency between LW instruction's destination register and one of the next instruction's source register
          // we need to insert a NOP. This means that pc shouldnt change for one clk cycle. check your waveform to make sure your pc doesnt change
          if(uut.data_mem.ram[29]==32'hd15f1416) $display("*DATA_HAZARD_RS_DEPENDENCY* =     {1}"); else $display("*DATA_HAZARD_RS_DEPENDENCY* =   {0}");
          if(uut.data_mem.ram[30]==32'hb54bc032) $display("*DATA_HAZARD_RT_DEPENDENCY* = 	{1}"); else $display("*DATA_HAZARD_RT_DEPENDENCY* = 	{0}");

          // Control Hazard
          if(uut.data_mem.ram[31]==32'hc187a606) $display("*CONTROL_HAZARD_BRANCH* = 	{1}"); else $display("*CONTROL_HAZARD_BRANCH* = 	{0}");
          if(uut.data_mem.ram[32]==32'hb54bc031) $display("*CONTROL_HAZARD_JUMP* = 	{1}"); else $display("*CONTROL_HAZARD_JUMP* = 	{0}");
      end

      always @ (negedge clk)
      begin

             cur_time = $time ;
             if (cur_time == 1060 || cur_time == 1080 || cur_time == 1120 || cur_time == 1140 || // 2 data hazards
              cur_time == 1220 || cur_time == 1240 ||cur_time == 1280 ||cur_time == 1300 )
             begin
                 $display("*PC_time_%0d* = {%d}",cur_time,(uut.IF_unit.pc_plus4 - 3'h100)>>2);
             end
      end
endmodule
