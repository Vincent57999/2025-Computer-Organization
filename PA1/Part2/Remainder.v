module Remainder_Register (
	input SLL_ctrl, SRL_ctrl, W_ctrl, Reset, clk, ALU_carry,
	input [31:0] ALU_result, Dividend_in,
	output reg [63:0] Remainder
);
	reg shift_left_of;

	always @(posedge clk or posedge Reset) begin
		if (Reset) begin
			Remainder <= 0;
		end
		else if (W_ctrl) begin
			Remainder[63:32] <= ALU_result;
			Remainder[31:0] <= Dividend_in;
		end
		else if (SLL_ctrl) begin
			{shift_left_of , Remainder[63:32]} <= {ALU_result , Remainder[31]};
			Remainder[31:0] <= {Remainder[30:0] , ALU_carry};
		end
		else if (SRL_ctrl) begin
			Remainder[63:32] <= {shift_left_of , Remainder[63:33]};
		end
		else begin
			Remainder <= Remainder;
		end
	end	
endmodule
