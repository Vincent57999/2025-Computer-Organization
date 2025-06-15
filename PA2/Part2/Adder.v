module Adder (
    input [31:0] Input_addr,
    output [31:0] Output_addr 
);
    assign Output_addr = Input_addr + 32'd4;
endmodule
