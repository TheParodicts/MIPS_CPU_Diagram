module Sign_Extender_tb();
  
  reg	[15:0] 	unex_16;
  reg 	[25:0]	unex_26;
  reg	[1:0]	sse;
  wire 	[31:0]	ext;
  
  Sign_Extender sign_ext(
    .unextended_16(unex_16),
    .unextended_26(unex_26),
    .extended(ext),
    .sse(sse)
  );
  
  initial begin
    unex_16 = 16'd0;
    unex_26 = 26'd0;
    sse = 2'b0;
  end
  
  initial begin
    $display("unextended\t\t\tsse\t\t\t\textended");
    
    
    unex_16 = 16'b0000000001010101;
    #10
    $display("%b\t\t%b\t%b", unex_16, sse, ext);
    
    sse = 2'b01;
    unex_16 = 16'b1000000001010101;
    #10
    $display("%b\t\t%b\t%b", unex_16, sse, ext);
    
    sse = 2'b10;
    unex_26 = 26'b10000000000000000011111111;
    #10
    $display("%b\t%b\t%b", unex_26, sse, ext);
    
  end
endmodule