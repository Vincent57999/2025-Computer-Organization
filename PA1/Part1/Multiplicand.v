module Multiplicand_Register (
	input Reset,
	input W_ctrl,
	input [31:0] Multiplicand_in,
	output reg [31:0] Multiplicand_out
);
	always @(*) begin
		if (Reset) begin
			Multiplicand_out = 32'd0; //reset
		end
		else if (W_ctrl) begin
			Multiplicand_out = Multiplicand_in; //load
		end
		else begin
			Multiplicand_out = Multiplicand_out; // not change
		end 
	end
endmodule
