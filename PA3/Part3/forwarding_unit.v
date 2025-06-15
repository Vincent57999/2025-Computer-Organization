module forwarding_unit (
    input [4:0] RdAddr_3_to_4, RdAddr_4_to_5,
    input Reg_w_3_to_4, Reg_w_4_to_5,
    input [4:0] RsAddr_2_to_3, RtAddr_2_to_3,
    output reg [1:0] forward_s, forward_t 
    //0 = normal, 1 = RdAddr_3_to_4, 2 = RdAddr_4_to_5
);
    
    //forward_s
    always @(*) begin
        if ((RdAddr_3_to_4 == RsAddr_2_to_3) && Reg_w_3_to_4)
            forward_s = 2'd1;
        else if ((RdAddr_4_to_5 == RsAddr_2_to_3) && Reg_w_4_to_5)
            forward_s = 2'd2;
        else 
            forward_s = 2'd0;
    end

    //forward_t
    always @(*) begin
        if ((RdAddr_3_to_4 == RtAddr_2_to_3) && Reg_w_3_to_4)
            forward_t = 2'd1;
        else if ((RdAddr_4_to_5 == RtAddr_2_to_3) && Reg_w_4_to_5)
            forward_t = 2'd2;
        else 
            forward_t = 2'd0;
    end

endmodule
