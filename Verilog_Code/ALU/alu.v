module ALU(
  input [31:0] A,B, // ALU 32-bit inputs
  input [3:0] ALU_Sel, //ALU 4-bit selection
  input CarryIn, 
  input Sign,
  output [31:0] ALU_Out,
  output Zero, 
  output Overflow
);
  
  wire [31:0] Lo;
  wire [31:0] Hi;
  reg [63:0] ALU_Result;
  
  wire tmp;
  
  Overflow_Detector ovr(
    .A_ext(A), 
    .B_ext(B), 
    .op(ALU_Sel), 
    .sign(Sign),
    .overflow(Overflow)
  );

  assign Lo = ALU_Result[31:0];
  assign Hi = ALU_Result[63:32];
  assign ALU_Out = ALU_Result[31:0];
  
  assign Zero = ~(|ALU_Result);

  always @(*)
    begin
      
      case(ALU_Sel)
        4'h0:
          ALU_Result = A + B + CarryIn;
        
        4'h1:
          ALU_Result = A - B;
        
        4'h2:
          ALU_Result = A * B;
        
        4'h4:
          ALU_Result = A << 1;
        
        4'h5:
          ALU_Result = A >> 1;
        
        4'h6: // Arith Shift left
          ALU_Result = {A[30:0], A[0]};
            
        4'h7: // Arith shift right
          ALU_Result = {A[31], A[31:1]}; 
          
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
          ALU_Result = (A < B) ? 32'd1 : 32'd0;
        
        4'hF:
          ALU_Result = (A == B) ? 32'd1 : 32'd0;
        
        default: ALU_Result = 64'd0;
        
      endcase
    end
  
endmodule

module Overflow_Detector(
  input [31:0] A_ext, B_ext,
  input [3:0] op,
  input sign,
  output overflow
);
  
  reg [32:0] temp_out;
  reg carr_out;
  
  reg ovrf_temp;
  
  assign overflow = ovrf_temp;
 
  always @(*) begin
    case(op)
      4'h0:
        begin
          temp_out = {0'b0, A_ext} + {0'b0, B_ext};
          carr_out = temp_out[32];
          
          if(sign) begin
            ovrf_temp = ~(A_ext[31] ^ B_ext[31]) ^ temp_out[31];
          end else begin
            ovrf_temp = carr_out;
          end
        end
      
      4'h1:
        begin
          temp_out = {0'b0, A_ext} - {0'b0, B_ext};
          carr_out = temp_out[32];
          
          if(sign) begin
            ovrf_temp = ~(A_ext[31] ^ B_ext[31]) ^ temp_out[31];
          end else begin
            ovrf_temp = carr_out;
          end
        end
      
      default: ovrf_temp = 0;
      
    endcase
  end
endmodule
          
