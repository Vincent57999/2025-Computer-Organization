/*
 *	Template for Project 3 Part 1
 *	Copyright (C) 2025 Xi Zhu Wang or any person belong ESSLab.
 *	All Right Reserved.
 *
 *	This program is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *
 *	This program is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 *	along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 *	This file is for people who have taken the cource (1132 Computer
 *	Organizarion) to use.
 *	We (ESSLab) are not responsible for any illegal use.
 *
 */

/*
 * Declaration of top entry for this project.
 * CAUTION: DONT MODIFY THE NAME AND I/O DECLARATION.
 */
module R_PipelineCPU(
	// Outputs
	output [31:0] Output_Addr,
	// Inputs
	input  [31:0] Input_Addr,
	input         clk
);
	//stage 1 to 2
	wire [31:0] Instruction_a;
	//stage 2 to 3
	reg [31:0] Instruction_b;
	wire [4:0] contral_out_a1;//[4]=Reg_w, [3]=Mem_w, [2]=Mem_r, [1:0]=ALU_op
	reg [4:0] contral_out_b1;
	wire [31:0] RsData_a, RtData_a;
	reg [31:0] RsData_b, RtData_b;
	reg [10:0] ALU_something;
	reg [4:0] RdAddr_b1;
	//stage 3 to 4
	reg [2:0] contral_out_b2;//[2]=Reg_w, [1]=Mem_w, [0]=Mem_r
	wire [1:0] Funct;
	reg [4:0] RdAddr_b2;
	wire [31:0] ALU_out_a1;
	reg [31:0] ALU_out_b1;
	//stage 4 to 5
	reg contral_out_b3;
	reg [4:0] RdAddr_b3;
	reg [31:0] ALU_out_b2;

	always @(posedge clk) begin
		//stage 1 to 2
		Instruction_b <= Instruction_a;
		//stage 2 to 3
		contral_out_b1 <= contral_out_a1;
		RsData_b <= RsData_a;
		RtData_b <= RtData_a;
		ALU_something <= Instruction_b[10:0];
		RdAddr_b1 <= Instruction_b[15:11];
		//stage 3 to 4
		contral_out_b2 <= contral_out_b1[4:2];
		RdAddr_b2 <= RdAddr_b1;
		ALU_out_b1 <= ALU_out_a1;
		//stage 4 to 5
		contral_out_b3 <= contral_out_b2[2];
		RdAddr_b3 <= RdAddr_b2;
		ALU_out_b2 <= ALU_out_b1;
	end

	/* 
	 * Declaration of Instruction Memory.
	 * CAUTION: DONT MODIFY THE NAME.
	 */
	IM Instr_Memory(
		// Outputs
		.Instr(Instruction_a),
		// Inputs
		.InstrAddr(Input_Addr)
	);

	/* 
	 * Declaration of Register File.
	 * CAUTION: DONT MODIFY THE NAME.
	 */
	RF Register_File(
		// Outputs
    	.RsData(RsData_a), 
    	.RtData(RtData_a), 
	 	// Inputs
    	.RsAddr(Instruction_b[25:21]), 
    	.RtAddr(Instruction_b[20:16]), 
    	.RdAddr(RdAddr_b3), 
    	.RdData(ALU_out_b2), 
    	.RegWrite(contral_out_b3), 
    	.clk(clk)
	);

	Adder ad0(
		// Inputs
    	.Input_1_adder(Input_Addr),
		.Input_2_adder(32'd4),
		// Outputs
    	.Output_adder(Output_Addr) 
	);

	ALU_control ac0(
		// Inputs
    	.Funct_ctrl(ALU_something[5:0]),
    	.ALU_op(contral_out_b1[1:0]),
		// Outputs
    	.Funct(Funct) //0:+ , 1:- , 2:<< , 3:| 
	);

	ALU a0(
		// Inputs
    	.Rs_data(RsData_b),
		.Rt_data(RtData_b),
    	.sharmt(ALU_something[10:6]),
    	.Funct(Funct), //0:+ , 1:- , 2:<< , 3:| 
		// Outputs
    	.Rd_data(ALU_out_a1),
    	.Zero()
	);

	control c0(
		// Inputs
    	.Opcode(Instruction_b[31:26]),
		// Outputs
    	.Reg_w(contral_out_a1[4]),
		.Reg_dst(),
    	.ALU_src(),
		.Mem_w(contral_out_a1[3]),
		.Mem_r(contral_out_a1[2]),
    	.ALU_op(contral_out_a1[1:0])
	);

endmodule
