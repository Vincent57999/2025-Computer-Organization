module ALU_control (
    input [5:0] Funct_ctrl,
    input [1:0] ALU_op,
    output reg [1:0] Funct //0:+ , 1:- , 2:<< , 3:| 
);

    always @(*) begin
        case (ALU_op)
            2'b10: begin//R type
                case (Funct_ctrl)
                    6'b100001: Funct <= 2'd0;//+
                    6'b100011: Funct <= 2'd1;//-
                    6'b000000: Funct <= 2'd2;//<<
                    6'b100101: Funct <= 2'd3;//|
                    default: Funct <= 2'bz;
                endcase
            end
            2'b01:begin// +
                Funct <= 2'd0;
            end 
            2'b11: begin// |
                Funct <= 2'd3;
            end
            2'b00: begin// -
                Funct <= 2'd1;
            end
            default: Funct <= 2'bz;
        endcase

    end
endmodule
