module CompMultiplier(
	// Outputs
	output [63:0]Product,
	output Ready,
	// Inputs
	input [31:0] Multiplicand,
	input [31:0] Multiplier,
	input Run,
	input Reset,
	input clk
);
	wire [31:0] Multiplicand_out, product_out, ALU_result;
	wire W_ctrl, Addu_ctrl, LSB, SRL_ctrl, ALU_carry;

	assign product_out = Product[63:32];
	assign LSB = Product[0];

	Multiplicand_Register m1(
		.Reset(Reset),
		.W_ctrl(W_ctrl),
		.Multiplicand_in(Multiplicand),
		.Multiplicand_out(Multiplicand_out)
	);
	ALU a1(
		.Src_1(product_out), //product out from Product_Register
		.Src_2(Multiplicand_out), //Multiplicand
		.Addu_ctrl(Addu_ctrl), //this exp use 1bit to reduce area 
		.ALU_carry(ALU_carry),
		.ALU_result(ALU_result)
	);
	Control c1(
		.Run(Run),
		.Reset(Reset), 
		.clk(clk),
		.LSB(LSB), //LSB is Product[0] from Product_Register
		.W_ctrl(W_ctrl), 
		.SRL_ctrl(SRL_ctrl),
		.Ready(Ready),
		.Addu_ctrl(Addu_ctrl) //this exp use 1bit to reduce area 
	);
	Product_Register p1(
		.SRL_ctrl(SRL_ctrl), 
		.W_ctrl(W_ctrl), 
		.Reset(Reset), 
		.clk(clk), 
		.ALU_carry(ALU_carry),
		.ALU_result(ALU_result), 
		.Multiplier_in(Multiplier),
		.Product(Product)
	);
	
endmodule

/*
module Multiplicand_Register (
	input Reset,
	input W_ctrl,
	input [31:0] Multiplicand_in,
	output reg [31:0] Multiplicand_out
);
	always @(*) begin
		if (Reset) begin
			Multiplicand_out = 32'd0; //reset
		end
		else if (W_ctrl) begin
			Multiplicand_out = Multiplicand_in; //load
		end
		else begin
			Multiplicand_out = Multiplicand_out; // not change
		end 
	end

endmodule

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

module Control (
	input Run, Reset, clk,
	input LSB, //LSB is Product[0] from Product_Register
	output reg W_ctrl, SRL_ctrl, Ready,
	output reg Addu_ctrl //this exp use 1bit to reduce area 
);
	reg [5:0] counter;

	always @(posedge clk or posedge Reset) begin
		if (Reset) begin
			counter <= 0;
			W_ctrl <= 1; // when reset high Multiplicand and Multiplier already in, so it can pre_load
			SRL_ctrl <= 0;
			Ready <= 0;
		end
		else if (Run) begin
			W_ctrl <= 0;
			if (counter <= 6'd31) begin
				SRL_ctrl <= 1;
				counter <= counter + 1;
			end
			else begin
				Ready <= 1;
				SRL_ctrl <= 0;
			end
		end
	end

	always @(*) begin
		if (~W_ctrl && LSB) begin//Avoid add once more
			Addu_ctrl = 1;
		end
		else begin
			Addu_ctrl = 0;
		end
	end

endmodule

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
*/