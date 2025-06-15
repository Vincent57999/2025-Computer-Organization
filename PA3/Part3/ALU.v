module ALU (
    input [31:0] Rs_data, Rt_data,
    input [4:0] sharmt,
    input [1:0] Funct, //0:+ , 1:- , 2:<< , 3:| 
    output reg [31:0] Rd_data
);
    always @(*) begin
        case (Funct)
            2'd0: Rd_data <= Rs_data + Rt_data;
            2'd1: Rd_data <= Rs_data - Rt_data;
            2'd2: Rd_data <= Rs_data << sharmt;
            2'd3: Rd_data <= Rs_data | Rt_data;
            default: Rd_data <= 32'bz;
        endcase
    end
endmodule
