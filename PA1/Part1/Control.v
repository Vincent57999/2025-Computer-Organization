module Control (
	input Run, Reset, clk,
	input LSB, //LSB is Product[0] from Product_Register
	output reg W_ctrl, SRL_ctrl, Ready,
	output reg Addu_ctrl //this exp use 1bit to reduce area 
);
	reg [5:0] counter;

	always @(posedge clk or posedge Reset) begin
		if (Reset) begin
			counter <= 0;
			W_ctrl <= 1; // when reset high Multiplicand and Multiplier already in, so it can pre_load
			SRL_ctrl <= 0;
			Ready <= 0;
		end
		else if (Run) begin
			W_ctrl <= 0;
			if (counter <= 6'd31) begin
				SRL_ctrl <= 1;
				counter <= counter + 1;
			end
			else begin
				Ready <= 1;
				SRL_ctrl <= 0;
			end
		end
		else;
	end

	
	always @(*) begin
		if (~W_ctrl && LSB) begin//Avoid add once more
			Addu_ctrl = 1;
		end
		else begin
			Addu_ctrl = 0;
		end
	end
endmodule
