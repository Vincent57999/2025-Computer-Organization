module reg_MEM_WB (
    input clk,
    input [2:0] contral_out_b2,
    input [4:0] RdAddr_b2,
    input [31:0] ALU_out_b,
    input [31:0] mem_read_data_a,
    output reg [2:0] contral_out_b3,//[2]=Reg_w, [1]=Mem_w, [0]=Mem_r
	output reg [4:0] RdAddr_b3,
	output reg [31:0] ALU_out_b2,
	output reg [31:0] mem_read_data_b
);
    always @(posedge clk) begin
		//stage 4 to 5
		contral_out_b3 <= contral_out_b2;
		RdAddr_b3 <= RdAddr_b2;
		ALU_out_b2 <= ALU_out_b;
		mem_read_data_b <= mem_read_data_a;
	end
endmodule
