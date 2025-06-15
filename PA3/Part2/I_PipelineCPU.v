/*
 *	Template for Project 3 Part 2
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
module I_PipelineCPU(
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
	wire [6:0] contral_out_a1;//[6]=ALU_src, [5]=Reg_dst, [4]=Reg_w, [3]=Mem_w, [2]=Mem_r, [1:0]=ALU_op
	reg [6:0] contral_out_b1;
	wire [31:0] RsData_a, RtData_a1;
	reg [31:0] RsData_b, RtData_b1;
	reg [15:0] ALU_something;
	reg [4:0] RdAddr_b1;
	reg [4:0] RtAddr_b;
	//stage 3 to 4
	reg [2:0] contral_out_b2;//[2]=Reg_w, [1]=Mem_w, [0]=Mem_r
	wire [1:0] Funct;
	reg [4:0] RdAddr_b2;
	wire [31:0] ALU_out_a1;
	reg [31:0] ALU_out_b;
	reg [31:0] RtData_b2;
	//stage 4 to 5
	reg [1:0] contral_out_b3;//[1]=Reg_w, [0]=Mem_r
	reg [4:0] RdAddr_b3;
	reg [31:0] ALU_out_b2;
	wire [31:0] mem_read_data_a;
	reg [31:0] mem_read_data_b;

	//mux
	wire [31:0] ALU_src_out;
	wire [4:0] Reg_dst_out;
	wire [31:0] RdData_final;


	always @(posedge clk) begin
		//stage 1 to 2
		Instruction_b <= Instruction_a;
		//stage 2 to 3
		contral_out_b1 <= contral_out_a1;
		RsData_b <= RsData_a;
		RtData_b1 <= RtData_a1;
		ALU_something <= Instruction_b[15:0];
		RdAddr_b1 <= Instruction_b[15:11];
		RtAddr_b <= Instruction_b[20:16];
		//stage 3 to 4
		contral_out_b2 <= contral_out_b1[4:2];
		RdAddr_b2 <= Reg_dst_out;
		ALU_out_b <= ALU_out_a1;
		RtData_b2 <= RtData_b1;
		//stage 4 to 5
		contral_out_b3 <= {contral_out_b2[2] , contral_out_b2[0]};
		RdAddr_b3 <= RdAddr_b2;
		ALU_out_b2 <= ALU_out_b;
		mem_read_data_b <= mem_read_data_a;
	end

	assign ALU_src_out = contral_out_b1[6] ? {16'd0 , ALU_something} : RtData_b1;
	assign Reg_dst_out = contral_out_b1[5] ? RdAddr_b1 : RtAddr_b;
	assign RdData_final = contral_out_b3[0] ? mem_read_data_b : ALU_out_b2;

	/* 
	 * Declaration of Instruction Memory.
	 * CAUTION: DONT MODIFY THE NAME.
	 */
	DM Data_Memory(
		//Outputs
    	.MemReadData(mem_read_data_a), 
		//Inputs
    	.MemAddr(ALU_out_b), 
    	.MemWriteData(RtData_b2), 
    	.MemWrite(contral_out_b2[1]), 
    	.clk(clk)
	);

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
    	.RtData(RtData_a1), 
	 	// Inputs
    	.RsAddr(Instruction_b[25:21]), 
    	.RtAddr(Instruction_b[20:16]), 
    	.RdAddr(RdAddr_b3), 
    	.RdData(RdData_final), 
    	.RegWrite(contral_out_b3[1]), 
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
		.Rt_data(ALU_src_out),
    	.sharmt(ALU_something[10:6]),
    	.Funct(Funct), //0:+ , 1:- , 2:<< , 3:| 
		// Outputs
    	.Rd_data(ALU_out_a1)
	);

	control c0(
		// Inputs
    	.Opcode(Instruction_b[31:26]),
		// Outputs
    	.Reg_w(contral_out_a1[4]),
		.Reg_dst(contral_out_a1[5]),
    	.ALU_src(contral_out_a1[6]),
		.Mem_w(contral_out_a1[3]),
		.Mem_r(contral_out_a1[2]),
    	.ALU_op(contral_out_a1[1:0])
	);
endmodule
