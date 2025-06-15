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
				SRL_ctrl <= 0;
			end
		end
	end
endmodule
