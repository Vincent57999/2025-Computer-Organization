module ALU_control (
    input [5:0] Funct_ctrl,
    input ALU_op,
    output reg [1:0] Funct //0:+ , 1:- , 2:<< , 3:| 
);
    always @(*) begin
        if (ALU_op) begin
            case (Funct_ctrl)
                6'b100001:Funct <= 2'd0;//+
                6'b100011:Funct <= 2'd1;//-
                6'b000000:Funct <= 2'd2;//<<
                6'b100101:Funct <= 2'd3;//|
                default:Funct <= 2'bz;
            endcase
        end
    end
endmodule
