/*
 *	Template for Project 2 Part 1
 *	Copyright (C) 2025  Xi-Zhu Wang or any person belong ESSLab.
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
module R_FormatCPU(
	// Outputs
	output	wire	[31:0]	Output_Addr,
	// Inputs
	input	wire	[31:0]	Input_Addr,
	input	wire			clk
);
	
	wire [31:0] Instruction;
	wire Reg_w, ALU_op;
	wire [1:0] Funct;
	wire [31:0] Rs_data, Rt_data, Rd_data;

	/* 
	 * Declaration of Instruction Memory.
	 * CAUTION: DONT MODIFY THE NAME.
	 */
	IM Instr_Memory(
		// Outputs
		.Instr(Instruction),
		// Inputs
		.InstrAddr(Input_Addr)
	);

	/* 
	 * Declaration of Register File.
	 * CAUTION: DONT MODIFY THE NAME.
	 */
	RF Register_File(
		// Outputs
		.RsData(Rs_data), 
		.RtData(Rt_data),
		// Inputs
		.RdData(Rd_data),
		.RsAddr(Instruction[25:21]), 
		.RtAddr(Instruction[20:16]), 
		.RdAddr(Instruction[15:11]),
		.RegWrite(Reg_w),
		.clk(clk)
	);

	Adder ad0(
		// Inputs
		.Input_addr(Input_Addr),
		// Outputs
    	.Output_addr(Output_Addr)
	);

	control c0(
		// Inputs
		.Opcode(Instruction[31:26]),
		// Outputs
    	.Reg_w(Reg_w),
    	.ALU_op(ALU_op)
	);

	ALU_control alu_c0(
		// Inputs
		.Funct_ctrl(Instruction[5:0]),
    	.ALU_op(ALU_op),
		// Outputs
    	.Funct(Funct) //0:+ , 1:- , 2:<< , 3:| 
	);

	ALU alu0(
		// Inputs
		.Rs_data(Rs_data),
		.Rt_data(Rt_data),
    	.sharmt(Instruction[10:6]),
    	.Funct(Funct), //0:+ , 1:- , 2:<< , 3:| 
		// Outputs
    	.Rd_data(Rd_data)
	);

endmodule
