/*
 *	Testbench for Project 1 Part 2
 *	Copyright (C) 2025  ESSLab.
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
 *	NOTE	: FOR COMPATIBILITY OF YOUR CODE, PLEASE DONT CHANGE ANY THING
 *			  IN THIS FILE!
 *
 */
 
// Setting timescale
`timescale 10 ns / 1 ns

// Declarations
`define DELAY			1	// # * timescale
`define INPUT_FILE		"testbench/tb_CompDivider.in"
`define OUTPUT_FILE		"testbench/tb_CompDivider.out"

// Declaration
`define LOW		1'b0
`define HIGH	1'b1

module tb_CompDivider;

	// Inputs
	reg Reset;
	reg Run;
	reg [31:0] Dividend;
	reg [31:0] Divisor;
	
	// Outputs
	wire [31:0] Quotient;
	wire [31:0] Remainder;
	wire Ready;
	
	// Clock
	reg clk = `LOW;
	
	// Testbench variables
	reg [63:0] read_data;
	integer input_file;
	integer output_file;
	integer i;
	
	// Instantiate the Unit Under Test (UUT)
	CompDivider UUT(
		// Outputs
		.Quotient(Quotient),
		.Remainder(Remainder),
		.Ready(Ready),
		// Inputs
		.Dividend(Dividend),
		.Divisor(Divisor),
		.Run(Run),
		.Reset(Reset),
		.clk(clk)
	);
	
	initial
	begin : Preprocess
		// Initialize inputs
		Reset 		= `LOW;
		Run 		= `LOW;
		Dividend	= 32'd0;
		Divisor	= 32'd0;

		// Initialize testbench files
		input_file	= $fopen(`INPUT_FILE, "r");
		output_file	= $fopen(`OUTPUT_FILE);

		#`DELAY;	// Wait for global reset to finish
	end
	
	always
	begin : ClockGenerator
		#`DELAY;
		clk <= ~clk;
	end
	
	always
	begin : StimuliProcess
		// Start testing
		while (!$feof(input_file))
		begin
			$fscanf(input_file, "%x\n", read_data);
			@(posedge clk);	// Wait clock
			{Dividend, Divisor} = read_data;
			Reset = `HIGH;
			@(posedge clk);	// Wait clock
			Reset = `LOW;
			@(posedge clk);	// Wait clock
			Run = `HIGH;
			@(posedge Ready);	// Wait ready
			Run = `LOW;
		end
		
		#`DELAY;	// Wait for result stable

		// Close output file for safety
		$fclose(output_file);

		// Stop the simulation
		$stop();
	end
	
	always @(posedge Ready)
	begin : Monitoring
		$display("Dividend:%d, Divisor:%d", Dividend, Divisor);
		$display("Quotient:%d, Remainder:%d", Quotient, Remainder);
		$fdisplay(output_file, "%x_%x", Quotient, Remainder);
	end
	
endmodule
