module Product_Register (
	input SRL_ctrl, W_ctrl, Reset, clk, ALU_carry,
	input [31:0] ALU_result, Multiplier_in,
	output reg [63:0] Product
);
	always @(posedge clk or posedge Reset) begin
		if (Reset) begin
			Product <= 0;
		end
		else if (W_ctrl) begin
			Product[63:32] <= ALU_result;
			Product[31:0] <= Multiplier_in;
		end
		else if (SRL_ctrl) begin
			Product[63:32] <= {ALU_carry , ALU_result[31:1]};//use nonblocking shift
			Product[31:0] <= {ALU_result[0] , Product[31:1]};
		end
		else begin
			Product <= Product;
		end
	end
endmodule
