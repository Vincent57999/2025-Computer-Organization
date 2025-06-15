module ALU_tb_my;
    // Inputs
	reg [31:0] Src_1;
	reg [31:0] Src_2;
	reg [4:0] Shamt;
	reg [5:0] Funct;
	// Outputs
	wire [31:0] ALU_result;
	wire Zero;
	wire Carry;

    ALU UUT(
		// Inputs
		.Src_1(Src_1),
		.Src_2(Src_2),
		.Shamt(Shamt),
		.Funct(Funct),
		// Outputs
		.ALU_result(ALU_result),
		.Zero(Zero),
		.Carry(Carry)
	);
    initial begin
        Src_1 = 32'h22222222;
        Src_2 = 32'h13131313;
        Funct = 6'b100100;

        #10 Src_1 = 32'hffffffff;
        Funct = 6'b100011;

        #10 Src_2 = 32'h00000000;
        Funct = 6'b100101;

        #10 Funct = 6'b000010;
        Shamt = 5'd1;

        #10 Funct = 6'b000000;

        #10 Src_1 = 32'hffffffff;
        Src_2 = 32'hffffffff;
        Funct = 6'b100011;
        
        #10 Src_1 = 32'h13131313;
        Src_2 = 32'hffffffff;
        Funct = 6'b100011;

        #10 $finish;
    end
endmodule
