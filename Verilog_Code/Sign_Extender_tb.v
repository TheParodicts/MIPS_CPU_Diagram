module Sign_Extender_tb();
  
  reg	[15:0] 	unex;
  wire 	[31:0]	ext;
  
  Sign_Extender sign_ext(
    .unextended(unex),
    .extended(ext)
  );
  
  initial begin
    unex = 16'd0;
  end
  
  initial begin
    $display("unextended\t\textended");
    
    
    unex = 16'b0000000001010101;
    #10
    $display("%b\t%b", unex, ext);
    
    unex = 16'b1000000011111111;
    #10
    $display("%b\t%b", unex, ext);
    
  end
endmodule
