module control (
    input [5:0] Opcode,
    output reg Reg_w, Reg_dst,
    output reg ALU_src, Mem_w, Mem_r, Mem_to_reg, Branch, Jump,
    output reg [1:0] ALU_op
);
    always @(*) begin
        Mem_r <= 1'b1;//反正是Mem_to_reg在控制

        if (Opcode[4]) begin //illgel
            Mem_w <= 1'b0;
            Reg_w <= 1'b0;
            Jump <= 1'b0;
            Branch <= 1'b0;
        end
        else if (Opcode[0]) begin //I type
            Reg_dst <= 1'b0;
            ALU_src <= 1'b1;
            Branch <= 1'b0;
            Jump <= 1'b0;
            if (Opcode[3]) begin
                Mem_to_reg <= 1'b0;
                if (Opcode[2]) begin //ori
                    Reg_w <= 1'b1;
                    Mem_w <= 1'b0;
                    ALU_op <= 2'b11;
                end
                else begin
                    ALU_op <= 2'b01;
                    if (Opcode[1]) begin //sw
                        Reg_w <= 1'b0;
                        Mem_w <= 1'b1;
                    end
                    else begin //addi
                        Reg_w <= 1'b1;
                    end
                end
            end
            else begin //lw
                Reg_w <= 1'b1;
                Mem_w <= 1'b0;
                Mem_to_reg <= 1'b1;
                ALU_op <= 2'b01;
            end
        end
        else begin //R type, beq, jump
            Reg_dst <= 1'b1;
            ALU_src <= 1'b0;
            Mem_w <= 1'b0;
            Mem_to_reg <= 1'b0;
            if (Opcode[2]) begin //beq
                Reg_w <= 1'b0;
                ALU_op <= 2'b00;
                Branch <= 1'b1;
                Jump <= 1'b0;
            end
            else begin
                ALU_op <= 2'b10;
                Branch <= 1'b0;
                if (Opcode[1]) begin //jump
                    Reg_w <= 1'b0;
                    Jump <= 1'b1;
                end
                else begin //R type
                    Reg_w <= 1'b1;
                    Mem_to_reg <= 1'b0;
                    ALU_op <= 2'b10;
                    Jump <= 1'b0;
                end
            end
        end

        /*//original
        case (Opcode)
            6'b000000: begin//R type
                Reg_w <= 1;
                Reg_dst <= 1;
                ALU_src <= 0;
                Mem_w <= 0;
                Mem_to_reg <= 0;
                ALU_op <= 2'b10;
                Branch <= 0;
                Jump <= 0;
            end
            6'b001001:begin//I type addiu
                Reg_w <= 1;
                Reg_dst <= 0;
                ALU_src <= 1;
                Mem_w <= 0;
                Mem_to_reg <= 0;
                ALU_op <= 2'b01;
                Branch <= 0;
                Jump <= 0;
            end
            6'b101011:begin//I type sw
                Reg_w <= 0;
                //Reg_dst <= 0;//可以不管
                ALU_src <= 1;
                Mem_w <= 1;
                //Mem_to_reg <= 0;//可以不管
                ALU_op <= 2'b01;
                Branch <= 0;
                Jump <= 0;
            end
            6'b100011:begin//I type lw
                Reg_w <= 1;
                Reg_dst <= 0;
                ALU_src <= 1;
                Mem_w <= 0;
                Mem_to_reg <= 1;
                ALU_op <= 2'b01;
                Branch <= 0;
                Jump <= 0;
            end
            6'b001101:begin//I type ori
                Reg_w <= 1;
                Reg_dst <= 0;
                ALU_src <= 1;
                Mem_w <= 0;
                Mem_to_reg <= 0;
                ALU_op <= 2'b11;
                Branch <= 0;
                Jump <= 0;
            end
            6'b000100:begin//beq
                Reg_w <= 0;
                //Reg_dst <= 0;//可以不管
                ALU_src <= 0;
                Mem_w <= 0;
                //Mem_to_reg <= 0;//可以不管
                ALU_op <= 2'b00;
                Branch <= 1;
                Jump <= 0;
            end
            6'b000010:begin//jump
                Reg_w <= 0;
                //Reg_dst <= 0;//可以不管
                //ALU_src <= 0;//可以不管
                Mem_w <= 0;
                //Mem_to_reg <= 0;//可以不管
                //ALU_op <= 2'b11;//可以不管
                Branch <= 0;
                Jump <= 1;
            end
            default: begin//反正不要write就好
                Mem_w <= 0;
                Reg_w <= 0;
                Jump <= 0;
            end
        endcase*/

    end
endmodule
