module Encoder (
  input[31:0] Instruction,
  output [6:0] State_Sel
);
  reg[6:0] state_tmp;
  
  assign State_Sel = state_tmp; 
  
  always @(*)
    begin
      casez(Instruction)
        // 32'b000000xxxxxxxxxxxxxxxxxxxx100000: //ADD
        
        32'b000000????????????????????100001: //ADDU
          state_tmp = 7'd6;

        32'b000000????????????????????100011: //SUBU
          state_tmp = 7'd17;
        
        // Store 
        32'b101000??????????????????????????: //SB
          state_tmp = 7'd7;
        32'b101001??????????????????????????: //SH
          state_tmp = 7'd7;
        32'b101011??????????????????????????: //SW
          state_tmp = 7'd7;
        
        32'b000100??????????????????????????: //BEQ
          state_tmp = 7'd11;

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
        
        default: state_tmp = 7'd0;
      
      endcase      
    end
endmodule
