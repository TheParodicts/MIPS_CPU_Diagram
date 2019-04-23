module ALU_tb();
//Inputs
  reg[31:0] A,B;
  reg[3:0] ALU_Sel;
  reg CarryIn;
  reg Sign;

//Outputs
  wire [31:0] ALU_Out;
  wire CarryOut, Zero, Overflow;
  
  
 // Verilog code for ALU
 integer i;
 integer j;
  
 ALU test_unit(
            A,B,  // ALU 8-bit Inputs                 
   			ALU_Sel,// ALU Selection
            CarryIn, 
   			Sign,
            ALU_Out, // ALU 8-bit Output
   			Zero, 
   			Overflow
   			
     );
    initial begin
    // hold reset state for 100 ns.
      // ALU_Out = 32'd0;
      A = 32'b11111111111111111111111111111110;
      B = 32'b11111111111111111111111111111111;
      ALU_Sel = 4'b1111;
      CarryIn = 0;
      Sign = 0;
      $dumpfile("dump.vcd");
      $dumpvars;
      
     
      for (j=0; j<=1; j=j+1)
        begin          
          for (i=0;i<=15;i=i+1)
            begin

              ALU_Sel = ALU_Sel + 1; 
              #10;
              $display("ALU_Sel: %b \tALU_Out: %b\t%d\tOverflow: %b", ALU_Sel, ALU_Out, ALU_Out, Overflow);
              
            end;
          Sign = 1;
        end;
      
      A = 32'hF6;
      B = 32'h0A;
      
      
    end
endmodule
