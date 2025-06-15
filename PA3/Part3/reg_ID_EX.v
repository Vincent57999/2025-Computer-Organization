module reg_ID_EX (
    input clk,
    input [6:0] contral_out_a1,//[6]=ALU_src, [5]=Reg_dst, [4]=Reg_w, [3]=Mem_w, [2]=Mem_r, [1:0]=ALU_op
	input [31:0] RsData_a, RtData_a1,
    input [25:0] Instruction_b,
    output reg [6:0] contral_out_b1,
	output reg [31:0] RsData_b, RtData_b1,
	output reg [15:0] ALU_something,
	output reg [4:0] RdAddr_b1,
	output reg [4:0] RtAddr_b,
	output reg [4:0] RsAddr_b
);
    always @(posedge clk) begin
		//stage 2 to 3
		contral_out_b1 <= contral_out_a1;
		RsData_b <= RsData_a;
		RtData_b1 <= RtData_a1;
		ALU_something <= Instruction_b[15:0];
		RdAddr_b1 <= Instruction_b[15:11];
		RtAddr_b <= Instruction_b[20:16];
		RsAddr_b <= Instruction_b[25:21];
	end
endmodule
