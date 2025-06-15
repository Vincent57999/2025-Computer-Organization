/*
 *	Template for Project 3 Part 3
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
module FinalCPU(
	// Outputs
	output        PC_Write,
	output [31:0] Output_Addr,
	// Inputs
	input  [31:0] Input_Addr,
	input         clk
);

	//stage 1 to 2
	wire [31:0] Instruction_a;
	wire [31:0] Instruction_b;
	//stage 2 to 3
	wire [6:0] contral_out_a1;//[6]=ALU_src, [5]=Reg_dst, [4]=Reg_w, [3]=Mem_w, [2]=Mem_r, [1:0]=ALU_op
	wire [6:0] contral_out_b1;
	wire [31:0] RsData_a, RtData_a1;
	wire [31:0] RsData_b, RtData_b1;
	wire [15:0] ALU_something;
	wire [4:0] RdAddr_b1;
	wire [4:0] RtAddr_b;
	wire [4:0] RsAddr_b;
	//stage 3 to 4
	wire [2:0] contral_out_b2;//[2]=Reg_w, [1]=Mem_w, [0]=Mem_r
	wire [4:0] RdAddr_b2;
	wire [31:0] ALU_out_a1;
	wire [31:0] ALU_out_b;
	wire [31:0] RtData_b2;
	//stage 4 to 5
	wire [2:0] contral_out_b3;//[2]=Reg_w, [1]=Mem_w, [0]=Mem_r
	wire [4:0] RdAddr_b3;
	wire [31:0] ALU_out_b2;
	wire [31:0] mem_read_data_a;
	wire [31:0] mem_read_data_b;
	//mux and temp
	wire [1:0] Funct;
	wire [31:0] ALU_src_out;
	wire [4:0] Reg_dst_out;
	wire [31:0] RdData_final;
	wire contral_all_0;
	wire [6:0] contral_out;
	wire [1:0] forward_s, forward_t;
	reg [31:0] RsData_forword, RtData_forword;

	reg_IF_ID r0(
		//Inputs
    	.clk(clk),
    	.Instruction_a(Instruction_a),
		//Outputs
		.Instruction_b(Instruction_b)
	);
	reg_ID_EX r1(
		//Inputs
    	.clk(clk),
    	.contral_out_a1(contral_out_a1),//[6]=ALU_src, [5]=Reg_dst, [4]=Reg_w, [3]=Mem_w, [2]=Mem_r, [1:0]=ALU_op
		.RsData_a(RsData_a), 
		.RtData_a1(RtData_a1),
    	.Instruction_b(Instruction_b[25:0]),
		//Outputs
    	.contral_out_b1(contral_out_b1),
		.RsData_b(RsData_b), 
		.RtData_b1(RtData_b1),
		.ALU_something(ALU_something),
		.RdAddr_b1(RdAddr_b1),
		.RtAddr_b(RtAddr_b),
		.RsAddr_b(RsAddr_b)
	);
	reg_EX_MEM r2(
		//Inputs
    	.clk(clk),
    	.contral_out_b1(contral_out_b1[4:2]),
    	.Reg_dst_out(Reg_dst_out),
    	.ALU_out_a1(ALU_out_a1),
    	.RtData_forword(RtData_forword),
		//Outputs
		.contral_out_b2(contral_out_b2),//[2]=Reg_w, [1]=Mem_w, [0]=Mem_r
    	.RdAddr_b2(RdAddr_b2),
		.ALU_out_b(ALU_out_b),
		.RtData_b2(RtData_b2)
	);
	reg_MEM_WB r3(
		//Inputs
    	.clk(clk),
    	.contral_out_b2(contral_out_b2),
    	.RdAddr_b2(RdAddr_b2),
    	.ALU_out_b(ALU_out_b),
    	.mem_read_data_a(mem_read_data_a),
		//Outputs
    	.contral_out_b3(contral_out_b3),//[2]=Reg_w, [1]=Mem_w, [0]=Mem_r
		.RdAddr_b3(RdAddr_b3),
		.ALU_out_b2(ALU_out_b2),
		.mem_read_data_b(mem_read_data_b)
	);

	assign ALU_src_out = contral_out_b1[6] ? {16'd0 , ALU_something} : RtData_forword;
	assign Reg_dst_out = contral_out_b1[5] ? RdAddr_b1 : RtAddr_b;
	assign RdData_final = contral_out_b3[0] ? mem_read_data_b : ALU_out_b2;
	assign contral_out_a1 = contral_all_0 ? 7'd0 : contral_out;
	always @(*) begin
		case (forward_s)
			2'd0:RsData_forword = RsData_b;
			2'd1:RsData_forword = ALU_out_b;
			2'd2:RsData_forword = RdData_final;
			default:;
		endcase
	end
	always @(*) begin
		case (forward_t)
			2'd0:RtData_forword = RtData_b1;
			2'd1:RtData_forword = ALU_out_b;
			2'd2:RtData_forword = RdData_final;
			default:;
		endcase
	end

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
    	.RegWrite(contral_out_b3[2]), 
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
    	.Rs_data(RsData_forword),
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
    	.Reg_w(contral_out[4]),
		.Reg_dst(contral_out[5]),
    	.ALU_src(contral_out[6]),
		.Mem_w(contral_out[3]),
		.Mem_r(contral_out[2]),
    	.ALU_op(contral_out[1:0])
	);

	forwarding_unit f0(
		// Inputs
    	.RdAddr_3_to_4(RdAddr_b2), 
		.RdAddr_4_to_5(RdAddr_b3),
    	.Reg_w_3_to_4(contral_out_b2[2]), 
		.Reg_w_4_to_5(contral_out_b3[2]),
    	.RsAddr_2_to_3(RsAddr_b), 
		.RtAddr_2_to_3(RtAddr_b),
		// Outputs
    	.forward_s(forward_s),
		.forward_t(forward_t) 
    	//0 = normal, 1 = RdAddr_3_to_4, 2 = RdAddr_4_to_5
	);

	hazard_detection_unit hd0(
		// Inputs
    	.Mem_r_2_to_3(contral_out_b1[2]),
    	.RtAddr_2_to_3(RtAddr_b),
    	.RtAddr_1_to_2(Instruction_b[20:16]), 
		.RsAddr_1_to_2(Instruction_b[25:21]),
		// Outputs
    	.contral_all_0(contral_all_0), 
		.PC_Write(PC_Write)
	);
endmodule