`include "DataPath.v"
`include "RAM.v"

module DataPath_tb;
    wire [31:0] IR, MAR, PC, nPC, DataIn, DataOut, MUXA_o, MUXB_o, ALU_out, Hi, Lo;

    wire [6:0] aState;
    wire [5:0] OpC;
    wire [4:0] MA_o, B_o;
    wire RW, MOV, MOC, DMOC, RF;
    reg clk, reset;

    DataPath DP(IR, MAR, PC, nPC, DataIn, MUXA_o, MUXB_o, RW, MOV, RF,
                aState, OpC, MA_o, B_o, clk, reset, MOC, DMOC, DataOut, ALU_out, Hi, Lo);

    /// RAM Declarations.
    ram512x8 ram1 (DataOut, MOC, DMOC, RW, MOV,
                        MAR[8:0], DataIn, OpC);   


    //Load RAM instantaneously by byte.
     integer fi, fo, code, i; 
     reg [31:0] data; 
     reg [8:0] Address;
    initial begin 
        fi = $fopen("RAMdata.txt","r"); 
        Address = 9'd0;
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
        repeat (150) begin
            #1 clk = !clk;
        end
        
        fo = $fopen("RAMcontents.txt", "w");
        Address = 9'd0;
        $fdisplay(fo,"Address | Contents");
        repeat(512) begin
            $fdisplay(fo,"%h = %b", Address, ram1.Mem[Address]); 
            Address = Address +9'd1;
        end
         $fclose(fo);
      

    end

    // Start the system with a hard Reset for #2 (while the clock ticks, loading CR).
    initial begin      
        $display("               IR                        MAR        PC         nPC");
        $monitor("%b %d %d %d", IR, MAR, PC, nPC);
        reset = 1'b1;
        #2 reset = 1'b0;
    end

    always @(posedge clk) begin
       // $display("%b %d %d %d", IR, MAR, PC, nPC);
    end

endmodule

// aState, RW, MOV, MOC, clk, MUXA_o, MUXB_o, ALU_out  ->old displays for testing. 
// cState RW  MOV  MOC clk     MUXA_out     MUXB_out     ALU_out  -> Old headers for testing. 