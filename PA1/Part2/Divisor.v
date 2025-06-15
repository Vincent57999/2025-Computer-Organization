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
