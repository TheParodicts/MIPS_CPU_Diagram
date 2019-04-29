module ALU(
  output [31:0] ALU_Out,
  input [31:0] A,B, // ALU 32-bit inputs
  input [3:0] ALU_Sel, //ALU 4-bit selection
  input CarryIn, 
  input Sign,
  output Zero, 
  output Overflow
);
  
  wire [31:0] Lo;
  wire [31:0] Hi;
  reg [63:0] ALU_Result;
  reg [15:0] val16;
  reg [7:0] val8;
  reg [3:0] val4;
  reg[31:0] tmp;

  integer i;
  
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
          ALU_Result =  A-B; // Not sure how this works, since these should be A = RT and B = RS -> Brian.
        
        4'h2:
          begin
            if (B == 32'b0) begin
          	  ALU_Result = 64'b0;
            end else begin
              ALU_Result = A * B;
            end
          end
        4'h3:
          ALU_Result = {32'b0, {B[15:0], 16'b0}}; // LUI imm16 of input B extendended at the right with zeroes
        
        4'h4:   // Logical Shift Left
          begin
            tmp = A;
            if (B < 32) begin
              for (i = 0; i < B[4:0]; i=i+1) begin
                tmp = tmp << 1;
              end
              ALU_Result = tmp;
            end else begin
              ALU_Result = 0;
            end
          end
        4'h5:  // Logical Shift Right
          begin
            tmp = A;
            if (B < 32) begin
              for (i = 0; i < B[4:0]; i=i+1) begin
                tmp = tmp >> 1;
              end
              ALU_Result = tmp;
            end else begin
              ALU_Result = 0;
            end
          end

        4'h6: // Arith Shift left
          begin
            tmp = A;
            if (B < 32) begin
              for (i = 0; i < B[4:0]; i=i+1) begin
                tmp = {tmp[31:0], 1'b0};
              end
              ALU_Result = tmp;
            end else begin
              ALU_Result = 0;
            end
          end
            
        4'h7: // Arith shift right
          begin
            tmp = A;
            if (B < 32) begin
              for (i = 0; i < B[4:0]; i=i+1) begin
                tmp = {tmp[31], tmp[31:1]};
              end
              ALU_Result = tmp;
            end else begin
              ALU_Result = 32'hffff_ffff;
            end
          end       
          
        4'h8:
          ALU_Result = A & B;
        
        4'h9:
          ALU_Result = A | B;
        
        4'hA:
          ALU_Result = A ^ B;
        
        4'hB:
          ALU_Result = ~(A | B);
        
        4'hC: // Count Leading Zero's
          begin
            if(A[31:0] == 32'b0) begin
              ALU_Result = 32;
            end else begin
              ALU_Result[4] = (A[31:16] == 16'b0);
              val16 = ALU_Result[4] ? A[15:0] : A[31:16];

              ALU_Result[3] = (val16[15:8] == 8'b0);
              val8 = ALU_Result[3] ? val16[7:0] : val16[15:8];

              ALU_Result[2] = (val8[7:4] == 4'b0);
              val4 = ALU_Result[2] ? val8[3:0] : val8[7:4];

              ALU_Result[1] = (val4[3:2] == 2'b0);
              ALU_Result[0] = ALU_Result[1] ? ~val4[1] : ~val4[3];

              ALU_Result[63:5] = 0;
            end
          end
        
        4'hD: // Count Leading One's
          begin  
            if(A[31:0] == 32'b11111111111111111111111111111111) begin
              ALU_Result = 32;
            end else begin
              ALU_Result[4] = (A[31:16] == 16'b1111111111111111);
              val16 = ALU_Result[4] ? A[15:0] : A[31:16];

              ALU_Result[3] = (val16[15:8] == 8'b11111111);
              val8 = ALU_Result[3] ? val16[7:0] : val16[15:8];

              ALU_Result[2] = (val8[7:4] == 4'b1111);
              val4 = ALU_Result[2] ? val8[3:0] : val8[7:4];

              ALU_Result[1] = (val4[3:2] == 2'b11);
              ALU_Result[0] = ALU_Result[1] ? val4[1] : val4[3];

              ALU_Result[63:5] = 0;
            end
          end
        
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
          temp_out = {1'b0, A_ext} + {1'b0, B_ext};
          carr_out = temp_out[32];
          
          if(sign) begin
            ovrf_temp = ~(A_ext[31] ^ B_ext[31]) ^ temp_out[31];
          end else begin
            ovrf_temp = carr_out;
          end
        end
      
      4'h1:
        begin
          temp_out = {1'b0, A_ext} - {1'b0, B_ext};
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