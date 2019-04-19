module 2x1_32b_Mux(output reg [31:0]  out, input [31:0] 0_in, 1_in, input select); 
    always @ (0_in, 1_in, select)
        case(select)
            1'b0: out <= 0_in;
            1'b1: out <= 1_in;
        endcase
    endmodule

module 2x1_5b_Mux(output reg [4:0]  out, input [4:0] 0_in, 1_in, input select); 
    always @ (0_in, 1_in, select)
        case(select)
            1'b0: out <= 0_in;
            1'b1: out <= 1_in;
        endcase
    endmodule

module 2x1_6b_Mux(output reg [5:0]  out, input [5:0] 0_in, 1_in, input select); 
    always @ (0_in, 1_in, select)
        case(select)
            1'b0: out <= 0_in;
            1'b1: out <= 1_in;
        endcase
    endmodule