module ALU (
    // Inputs
	input [31:0] Src_1,
	input [31:0] Src_2,
	input [4:0] Shamt,
	input [5:0] Funct,
	
	// Outputs
	output reg [31:0] ALU_result,
	output reg Zero,
	output reg Carry
);
    always @(*) begin
        case (Funct)
            6'b100100: {Carry,ALU_result} = Src_1 + Src_2;
            6'b100011: begin
                if (Src_1 >= Src_2)begin
                    ALU_result = Src_1 - Src_2;
                    Carry = 1'b0;
                end else begin
                    ALU_result = 33'h1_0000_0000 - Src_2 + Src_1;
                    Carry = 1'b1;
                end       
            end
            6'b100101: begin
                ALU_result = Src_1 | Src_2;
                Carry = 1'b0;
            end
            6'b000010: {Carry,ALU_result} = Src_1 >> Shamt;
            6'b000000: {Carry,ALU_result} = Src_1 << Shamt;
            default: {Carry,ALU_result} = 33'bz;
        endcase

        if (ALU_result == 0) begin
            Zero = 1;
        end else begin
            Zero = 0;
        end
    end
endmodule
