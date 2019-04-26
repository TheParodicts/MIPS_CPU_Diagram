module Sign_Extender (
  output 	[31:0] 	extended,
  input		[15:0] 	unextended,
  input   [1:0]   sse
);
  wire  [31:0] result;
  assign extended = result;

  //{{16{unextended[15]}}, unextended}
  always @(*)
    begin
      case(sse)
        2'b00:

        2'b01:

        2'b10:

        2'b11:

  
  
endmodule
