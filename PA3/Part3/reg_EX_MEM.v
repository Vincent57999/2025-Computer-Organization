module reg_EX_MEM (
    input clk,
    input [2:0] contral_out_b1,//contral_out_b1[4:2]
    input [4:0] Reg_dst_out,
    input [31:0] ALU_out_a1,
    input [31:0] RtData_forword,
	output reg [2:0] contral_out_b2,//[2]=Reg_w, [1]=Mem_w, [0]=Mem_r
    output reg [4:0] RdAddr_b2,
	output reg [31:0] ALU_out_b,
	output reg [31:0] RtData_b2
);
    always @(posedge clk) begin
		//stage 3 to 4
		contral_out_b2 <= contral_out_b1;
		RdAddr_b2 <= Reg_dst_out;
		ALU_out_b <= ALU_out_a1;
		RtData_b2 <= RtData_forword;
	end
endmodule
