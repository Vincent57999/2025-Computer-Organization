/*
 *	Template for Project 2 Part 2
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
 * Macro of size declaration of data memory
 * CAUTION: DONT MODIFY THE NAME AND VALUE.
 */
`define DATA_MEM_SIZE	128	// Bytes
//`define DATA_MEM_SIZE	12	// Bytes

/*
 * Declaration of Data Memory for this project.
 * CAUTION: DONT MODIFY THE NAME.
 */
module DM(
	// Outputs
	output [31:0] MemReadData,
	// Inputs
	input [31:0] MemAddr,
	input [31:0] MemWriteData,
	input MemWrite, MemRead, clk
);

	/* 
	 * Declaration of data memory.
	 * CAUTION: DONT MODIFY THE NAME AND SIZE.
	 */
	reg [7:0]DataMem[0:`DATA_MEM_SIZE - 1];

	assign MemReadData = MemRead ? {DataMem[MemAddr], DataMem[MemAddr+32'd1] 
									,DataMem[MemAddr+32'd2] ,DataMem[MemAddr+32'd3]} : 32'bz;

	always @(posedge clk) begin
		if (MemWrite) begin
			DataMem[MemAddr] <= MemWriteData[31:24];
			DataMem[MemAddr+32'd1] <= MemWriteData[23:16];
			DataMem[MemAddr+32'd2] <= MemWriteData[15:8];
			DataMem[MemAddr+32'd3] <= MemWriteData[7:0];
		end
		else;
	end

endmodule
