// Code your testbench here
// or browse Examples
module Sign_Extender_tb();
  
  reg	[31:0] 	unex;
  reg	[1:0]	sse;
  wire 	[31:0]	ext;
  
  Sign_Extender sign_ext(
    .unextended(unex),
    .extended(ext),
    .sse(sse)
  );
  
  initial begin
    unex = 32'd0;
    sse = 2'b0;
  end
  
  initial begin
    $display("unextended\t\t\t\tsse\t\t\t\textended");
    
    
    unex = 32'b00000000000000000000000001010101;
    #10
    $display("%b\t%b\t%b", unex, sse, ext);
    
    sse = 2'b01;
    unex = 32'b10000000000000001000000001010101;
    #10
    $display("%b\t%b\t%b", unex, sse, ext);
    
    sse = 2'b10;
    unex = 32'b10000000000000000000000011111111;
    #10
    $display("%b\t%b\t%b", unex, sse, ext);
    
  end
endmodule