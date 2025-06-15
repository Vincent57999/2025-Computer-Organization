module Adder (
    input [31:0] Input_1_adder, Input_2_adder,
    output [31:0] Output_adder 
);
    assign Output_adder = Input_1_adder + Input_2_adder;
endmodule
