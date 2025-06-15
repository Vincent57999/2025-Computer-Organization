module CampALU_tb_my;
    // Inputs
	reg [31:0] Instruction;
	
	// Outputs
	wire [31:0] CompALU_data;
	wire CompALU_zero;
	wire CompALU_carry;
    
    CompALU UUT(
		// Inputs
		.Instruction(Instruction),
		// Outputs
		.CompALU_out(CompALU_data),
		.CompALU_zero(CompALU_zero),
		.CompALU_carry(CompALU_carry)
	);

    initial begin
        Instruction = 32'b000000_00000_11110_00000_00000_100100;
        UUT.Register_File.R[0] = 32'h0000_0000;
        UUT.Register_File.R[31] = 32'hFFFF_FFFF;
        UUT.Register_File.R[30] = 32'h7F7F_7F7F;
        UUT.Register_File.R[13] = 32'h1234_5678;

        #10 Instruction = 32'b000000_11111_11110_00000_00000_100011;

        #10 Instruction = 32'b000000_00000_01101_00000_00000_100101;

        #10 Instruction = 32'b000000_11111_00000_00000_00001_000010;

        #10 Instruction = 32'b000000_11111_00000_00000_00001_000000;

        #10 Instruction = 32'b000000_11111_11111_00000_00000_100011;

        #10 Instruction = 32'b000000_11110_11111_00000_00000_100011;

        #10 $finish;
    end

endmodule
