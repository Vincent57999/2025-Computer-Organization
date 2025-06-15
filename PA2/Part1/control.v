module control (
    input [5:0] Opcode,
    output reg Reg_w,
    output reg ALU_op
);
    always @(*) begin
        if (Opcode == 6'd0) begin
            ALU_op <= 1;
            Reg_w <= 1;
        end
        else begin
            ALU_op <= 0;
            Reg_w <= 0;
        end
    end
endmodule
