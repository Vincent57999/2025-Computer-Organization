module control (
    input [5:0] Opcode,
    output reg Reg_w, Reg_dst,
    output reg ALU_src, Mem_w, Mem_r,
    output reg [1:0] ALU_op
);
    always @(*) begin
        case (Opcode)
            6'b000000: begin//R type
                Reg_w <= 1;
                Reg_dst <= 1;
                ALU_src <= 0;
                Mem_w <= 0;
                Mem_r <= 0;
                ALU_op <= 2'b10;
            end
            6'b001001:begin//I type addiu
                Reg_w <= 1;
                Reg_dst <= 0;
                ALU_src <= 1;
                Mem_w <= 0;
                Mem_r <= 0;
                ALU_op <= 2'b01;
            end
            6'b101011:begin//I type sw
                Reg_w <= 0;
                //Reg_dst <= 0;//可以不管
                ALU_src <= 1;
                Mem_w <= 1;
                Mem_r <= 0;
                ALU_op <= 2'b01;
            end
            6'b100011:begin//I type lw
                Reg_w <= 1;
                Reg_dst <= 0;
                ALU_src <= 1;
                Mem_w <= 0;
                Mem_r <= 1;
                ALU_op <= 2'b01;
            end
            6'b001101:begin//I type ori
                Reg_w <= 1;
                Reg_dst <= 0;
                ALU_src <= 1;
                Mem_w <= 0;
                Mem_r <= 0;
                ALU_op <= 2'b11;
            end
            default: begin//反正不要write就好
                Mem_w <= 0;
                Mem_r <= 0;
                Reg_w <= 0;
            end
        endcase
    end
endmodule
