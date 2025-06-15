module ALU (
	input [31:0] Src_1, //product out from Product_Register
	input [31:0] Src_2, //Multiplicand
	input Addu_ctrl, //this exp use 1bit to reduce area 
	output reg ALU_carry,
	output reg [31:0] ALU_result
);
	always @(*) begin
		if (Addu_ctrl) begin
			{ALU_carry , ALU_result} = Src_1 + Src_2;  // add
		end
		else begin
			ALU_carry = 0;
			ALU_result = Src_1;
		end
	end
endmodule
