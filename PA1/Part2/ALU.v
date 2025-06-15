module ALU (
	input [31:0] Src_1, //remainder out from Remainder_Register
	input [31:0] Src_2, //divisor
	input subu_ctrl, //this exp use 1bit to reduce area 
	output reg ALU_carry,
	output reg [31:0] ALU_result
);
	always @(*) begin
		if (subu_ctrl && (Src_1 >= Src_2))begin
			ALU_result <= Src_1 - Src_2;//if is postive, sub
			ALU_carry <= 1; //shift in 1
		end
		else begin
			ALU_result <= Src_1;
			ALU_carry <= 0;
		end
	end
endmodule
