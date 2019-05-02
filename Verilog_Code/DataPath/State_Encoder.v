module Encoder (
  input[31:0] Instruction,
  output [6:0] State_Sel
);
  reg[6:0] state_tmp;
  
  assign State_Sel = state_tmp; 
  
  always @(*)
    begin
      casez(Instruction)

        // Arithmetic/Logic  
        32'b000000????????????????????100001: //ADDU
          state_tmp = 7'd6;

        32'b000000????????????????????100011: //SUBU
          state_tmp = 7'd17;

        32'b001001??????????????????????????: //ADDIU
          state_tmp = 7'd18;

        32'b000000????????????????????101011: //SLTU
          state_tmp = 7'd19;

        32'b001011??????????????????????????: //SLTIU
          state_tmp = 7'd20;
          
        32'b011100????????????????????100001: //CLO
          state_tmp = 7'd21;

        32'b011100????????????????????100000: //CLZ
          state_tmp = 7'd22;

        32'b000000????????????????????100100: //AND
          state_tmp = 7'd23;

        32'b001100??????????????????????????: //ANDI
          state_tmp = 7'd24;

        32'b000000????????????????????100101: //OR
          state_tmp = 7'd25;

        32'b001101??????????????????????????: //ORI
          state_tmp = 7'd26;

        32'b000000????????????????????100110: //XOR
          state_tmp = 7'd27;

        32'b001110??????????????????????????: //XORI
          state_tmp = 7'd28;

        32'b000000????????????????????100111: //NOR
          state_tmp = 7'd29;

        32'b001111??????????????????????????: //LUI
          state_tmp = 7'd30;

        32'b000000????????????????????000000: //SLL
          state_tmp = 7'd31;

        32'b000000????????????????????000011: //SRA
          state_tmp = 7'd32;

        32'b000000????????????????????000010: //SRL
          state_tmp = 7'd33;

        32'b000000????????????????????001011: //MOVN
          state_tmp = 7'd34;

        32'b000000????????????????????001010: //MOVZ
          state_tmp = 7'd35;

        // Store 
        32'b101000??????????????????????????: //SB
          state_tmp = 7'd7;

        32'b101001??????????????????????????: //SH
          state_tmp = 7'd7;

        32'b101011??????????????????????????: //SW
          state_tmp = 7'd7;
        
        // Branch
        32'b000100??????????????????????????: //BEQ,B
          state_tmp = 7'd11;

        32'b000001?????00001????????????????: //BGEZ
          state_tmp = 7'd37;

        32'b000111?????00000????????????????: //BGTZ
          state_tmp = 7'd39;

        32'b000110?????00000????????????????: //BLEZ
          state_tmp = 7'd42;

        32'b000101??????????????????????????: //BNE
          state_tmp = 7'd41;

        32'b000000?????0000000000?????001000: //JR
          state_tmp = 7'd44;

        // Load States.
        32'b100011??????????????????????????: //LW
          state_tmp = 7'd13;

        32'b100001??????????????????????????: //LH
          state_tmp = 7'd13;

        32'b100101??????????????????????????: //LHU
          state_tmp = 7'd13;

        32'b100000??????????????????????????: //LB
          state_tmp = 7'd13;
          
        32'b100100??????????????????????????: //LBU
          state_tmp = 7'd13;
        
        default: state_tmp = 7'd1;
      
      endcase      
    end
endmodule
