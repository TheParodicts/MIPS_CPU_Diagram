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

module 4x1_32b_Mux(output reg [31:0] out, input [31:0] 0_in, 1_in, 2_in, 3_in, input [1:0] select); 
    always @ (0_in, 1_in, 2_in, 3_in, select)
        case(select)
            2'b00: out <= 0_in;
            2'b01: out <= 1_in;
            2'b10: out <= 2_in;
            2'b11: out <= 3_in;
        endcase
    endmodule