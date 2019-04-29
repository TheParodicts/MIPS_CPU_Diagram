`include "DataPath.v"
`include "RAM.v"

module DataPath_tb;
    wire [31:0] IR, MAR, PC, nPC, DataIn, DataOut, regFileA_o, regFileB_o, ALU_out;

    wire [6:0] aState;
    wire [5:0] OpC;
    wire [4:0] MA_o, B_o;
    wire RW, MOV, MOC, DMOC, RF;
    reg clk, reset;

    DataPath DP(IR, MAR, PC, nPC, DataIn, regFileA_o, regFileB_o, RW, MOV, RF,
                aState, OpC, MA_o, B_o, clk, reset, MOC, DMOC, DataOut, ALU_out);

    /// RAM Declarations.
    ram512x8 ram1 (DataOut, MOC, DMOC, RW, MOV,
                        MAR[8:0], DataIn, OpC);   


    //Load RAM instantaneously by byte.
     integer fi, fo, code, i; 
     reg [31:0] data; 
     reg [8:0] Address;
      reg [5:0] OpCode;
    initial begin 
        fi = $fopen("RAMdata.txt","r"); 
        Address = 7'b0000000;
        OpCode = 6'b101000; 
        while (!$feof(fi)) 
            begin code = $fscanf(fi, "%b", data); 
            ram1.Mem[Address] = data; 
            Address = Address + 1; 
        end 
        $fclose(fi);
     end


    /// Simulation Parameters.
 // 12 up-down clock cycles of #2.
    initial begin
        clk = 1'b0;
        repeat (150)
        #1 clk = !clk;
    end

    // Start the system with a hard Reset for #2 (while the clock ticks, loading CR).
    initial begin      
        $display("               IR                             MAR                          PC        nPC cState RW  MOV  MOC clk   RegFileA_out     MUXB_out    ALU_out ");
        reset = 1'b1;
        #2 reset = 1'b0;
    end

    always @(clk) begin
        $display("%b %b %d %d   %d    %b    %b   %b   %b %d    %d    %d", IR, MAR, PC, nPC, aState, RW, MOV, MOC, clk, regFileA_o, regFileB_o, ALU_out);
    end

endmodule