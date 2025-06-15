module CompDivider(
	// Outputs
	output [31:0] Quotient,
	output [31:0] Remainder,
	output Ready,
	// Inputs
	input [31:0] Dividend,
	input [31:0] Divisor,
	input Run,
	input Reset,
	input clk
);
	wire [31:0] ALU_result, Divisor_out;
	wire ALU_carry, W_ctrl, SLL_ctrl, SRL_ctrl, subu_ctrl;
	Divisor_Register d1(
		.Reset(Reset),
		.W_ctrl(W_ctrl),
		.Divisor_in(Divisor),
		.Divisor_out(Divisor_out)
	);
	ALU a1 (
		.Src_1(Remainder), //remainder out from Remainder_Register
		.Src_2(Divisor_out), //divisor
		.subu_ctrl(subu_ctrl), //this exp use 1bit to reduce area 
		.ALU_carry(ALU_carry),
		.ALU_result(ALU_result)
	);
	Control c1(
		.Run(Run), 
		.Reset(Reset), 
		.clk(clk),
		.W_ctrl(W_ctrl), 
		.SLL_ctrl(SLL_ctrl), 
		.SRL_ctrl(SRL_ctrl),
		.Ready(Ready),
		.subu_ctrl(subu_ctrl) //this exp use 1bit to reduce area 
	);
	Remainder_Register r1(
		.SLL_ctrl(SLL_ctrl), 
		.SRL_ctrl(SRL_ctrl),
		.W_ctrl(W_ctrl), 
		.Reset(Reset), 
		.clk(clk), 
		.ALU_carry(ALU_carry),
		.ALU_result(ALU_result), 
		.Dividend_in(Dividend),
		.Remainder({Remainder , Quotient})
	);
endmodule

/*
module Divisor_Register (
	input Reset,
	input W_ctrl,
	input [31:0] Divisor_in,
	output reg [31:0] Divisor_out
);
	always @(*) begin
		if (Reset) begin
			Divisor_out <= 32'd0; //reset
		end
		else if (W_ctrl) begin
			Divisor_out <= Divisor_in; //load
		end
		else begin
			Divisor_out <= Divisor_out; // not change
		end 
	end

endmodule

module ALU (
	input [31:0] Src_1, //remainder out from Remainder_Register
	input [31:0] Src_2, //divisor
	input subu_ctrl, //this exp use 1bit to reduce area 
	output reg ALU_carry,
	output reg [31:0] ALU_result
);
	always @(*) begin
		if (subu_ctrl) begin
			if (Src_2 > Src_1) begin
				ALU_result <= Src_1; //if is negtive, not change
				ALU_carry <= 0; //shift in 0
			end
			else begin
				ALU_result <= Src_1 - Src_2;//if is postive, sub
				ALU_carry <= 1; //shift in 1
			end
		end
		else begin
			ALU_result <= Src_1;
			ALU_carry <= 0;
		end
	end
endmodule

module Control (
	input Run, Reset, clk,
	output reg W_ctrl, SLL_ctrl, SRL_ctrl, Ready,
	output reg subu_ctrl //this exp use 1bit to reduce area 
);
	reg [5:0] counter;

	always @(posedge clk or posedge Reset) begin
		if (Reset) begin
			counter <= 0;
			W_ctrl <= 1;
			SLL_ctrl <= 1;
			SRL_ctrl <= 0;
			Ready <= 0;
			subu_ctrl <= 0;
		end
		else if (Run) begin
			W_ctrl <= 0;
			if (counter <= 6'd32) begin
				subu_ctrl <= 1;
				SLL_ctrl <= 1;
				counter <= counter + 1;
			end
			else if (counter == 6'd33) begin
				subu_ctrl <= 0;
				SLL_ctrl <= 0;
				SRL_ctrl <= 1;
				counter <= counter + 1;
			end
			else begin
				Ready <= 1;
				subu_ctrl <= 0;
				SLL_ctrl <= 0;
				SRL_ctrl <= 0;
			end
		end
	end
endmodule

module Remainder_Register (
	input SLL_ctrl, SRL_ctrl, W_ctrl, Reset, clk, ALU_carry,
	input [31:0] ALU_result, Dividend_in,
	output reg [63:0] Remainder
);
	always @(posedge clk or posedge Reset) begin
		if (Reset) begin
			Remainder <= 0;
		end
		else if (W_ctrl) begin
			Remainder[63:32] <= ALU_result;
			Remainder[31:0] <= Dividend_in;
		end
		else if (SLL_ctrl) begin
			Remainder[63:32] <= {ALU_result , Remainder[31]};
			Remainder[31:0] <= {Remainder[30:0] , ALU_carry};
		end
		else if (SRL_ctrl) begin
			Remainder[63:32] <= Remainder[63:32] >> 1;
		end
		else begin
			Remainder <= Remainder;
		end
	end	
endmodule
*/
