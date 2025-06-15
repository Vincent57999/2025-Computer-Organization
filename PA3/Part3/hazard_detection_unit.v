module hazard_detection_unit (
    input Mem_r_2_to_3,
    input [4:0] RtAddr_2_to_3,
    input [4:0] RtAddr_1_to_2, RsAddr_1_to_2,
    output reg contral_all_0, PC_Write
);
    always @(*) begin
        if (((RtAddr_2_to_3 == RsAddr_1_to_2) || (RtAddr_2_to_3 == RtAddr_1_to_2)) && Mem_r_2_to_3) begin
            contral_all_0 <= 1;
            PC_Write <= 0;
        end
        else begin
            contral_all_0 <= 0;
            PC_Write <= 1;
        end
    end
endmodule
