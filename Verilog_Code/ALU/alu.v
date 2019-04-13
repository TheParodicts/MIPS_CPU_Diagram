module ALU(
  input [31:0] A,B, // ALU 32-bit inputs
  input [3:0] ALU_Sel, //ALU 4-bit selection
  input CarryIn, 
  input Sign,
  output [31:0] ALU_Out,
  output Zero, 
  output Overflow, 
  output Carryout
);
  
  reg [31:0] Lo;
  reg [31:0] Hi;
  reg [63:0] ALU_Result;
  
  wire tmp;
  
  assign ALU_Out = (Sign == 1) ?  $signed(ALU_Result[31:0]) : ALU_Result[31:0];
  assign tmp = ALU_Result[32];
  assign Carryout = (Sign == 0) ? tmp : 1'b0;
  assign Overflow = 1'b0; // PLaceholder cuz i cant figure out the correct expression
  
  assign Lo = ALU_Result[31:0];
  assign Hi = ALU_Result[63:32];
  assign Zero = ~(|ALU_Result);

  always @(*)
    begin
      
      case(ALU_Sel)
        4'h0:
          ALU_Result = (Sign) ? $signed(A) + $signed(B) : A + B;
        
        4'h1:
          ALU_Result = (Sign) ? $signed(A) - $signed(B) : A - B;
        
        4'h2:
          ALU_Result = A * B;
        
        4'h4:
          ALU_Result = A << 1;
        
        4'h5:
          ALU_Result = A >> 1;
        
        4'h6: // Arith Shift left
          ALU_Result = (Sign) ? $signed(A) <<< 1 : A <<< 1; // doesnt seem to work with both signed and unsigned
            
        4'h7: // Arith shift right
          ALU_Result = (Sign) ? $signed(A) >>> 1 : A >>> 1; // doesnt seem to work with both signed and unsigned
          
        4'h8:
          ALU_Result = A & B;
        
        4'h9:
          ALU_Result = A | B;
        
        4'hA:
          ALU_Result = A ^ B;
        
        4'hB:
          ALU_Result = ~(A | B);
        
        4'hC:
          ALU_Result = ~(A & B);
        
        4'hD:
          ALU_Result = ~(A ^ B);
        
        4'hE:
          ALU_Result = (A > B) ? 32'd1 : 32'd0;
        
        4'hF:
          ALU_Result = (A == B) ? 32'd1 : 32'd0;
        
        default: ALU_Result = 64'd0;
        
      endcase
    end
  
endmodule
          
