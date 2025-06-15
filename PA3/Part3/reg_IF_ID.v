module reg_IF_ID (
    input clk,
    input [31:0] Instruction_a,
	output reg [31:0] Instruction_b
);
    always @(posedge clk) begin
		//stage 1 to 2
		Instruction_b <= Instruction_a;
	end
endmodule
