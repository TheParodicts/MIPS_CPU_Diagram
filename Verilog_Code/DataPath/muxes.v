module Mux_2x1_32b(output reg [31:0]  out, input [31:0] in_0, in_1, input select); 
    always @ (in_0, in_1, select)
        case(select)
            1'b0: out <= in_0;
            1'b1: out <= in_1;
        endcase
    endmodule

module Mux_2x1_5b(output reg [4:0]  out, input [4:0] in_0, in_1, input select); 
    always @ (in_0, in_1, select)
        case(select)
            1'b0: out <= in_0;
            1'b1: out <= in_1;
        endcase
    endmodule

module Mux_2x1_6b(output reg [5:0]  out, input [5:0] in_0, in_1, input select); 
    always @ (in_0, in_1, select)
        case(select)
            1'b0: out <= in_0;
            1'b1: out <= in_1;
        endcase
    endmodule

module Mux_4x1_32b(output reg [31:0] out, input [31:0] in_0, in_1, in_2, in_3, input [1:0] select); 
    always @ (in_0, in_1, in_2, in_3, select)
        case(select)
            2'b00: out <= in_0;
            2'b01: out <= in_1;
            2'b10: out <= in_2;
            2'b11: out <= in_3;
        endcase
    endmodule