module Encoder_tb();
  
  reg [31:0] Instruction;
  
  wire [6:0] State_Sel;
  
  Encoder DUT(
    Instruction,
    State_Sel
  );
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    
    Instruction = 32'd0;
    #10;
    
    Instruction = 32'b00000000000000000000000000100001;
	#10;    
    $display("Instruction: ADDU\t State_Sel = %d", State_Sel);
    
    Instruction = 32'b10100000000000000000000000000000;
    #10;
    $display("Instruction: SB  \t State_Sel = %d", State_Sel);
    
    Instruction = 32'b00010000000000000000000000000000;
    #10;
    $display("Instruction: BEQ\t State_Sel = %d", State_Sel);

    
  end
endmodule  
