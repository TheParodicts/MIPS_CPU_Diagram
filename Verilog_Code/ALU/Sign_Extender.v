module Sign_Extender (
  output 	[31:0] 	extended,
  input		[15:0] 	unextended_16,
  input   [25:0]  unextended_26,
  input   [1:0]   sse
);
  reg  [31:0] result;
  assign extended = result;

  //{{16{unextended[15]}}, unextended}
  always @(*)
    begin
      case(sse)
        2'b00: // Sign extend 16 bit
          result = {{16{unextended_16[15]}}, unextended_16};

        2'b01: // Sign extend 16 bit and Shift Left by 2
          result = {{16{unextended_16[15]}}, unextended_16} << 2;

        2'b10: // Shift 26 bit Left by 2
          result = unextended_26 << 2;

        default: result = 32'b0;
      endcase
    end  
endmodule
