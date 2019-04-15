`include "ControlUnit.v"

module ControlUnit_tb;
/// Required wires
// Output wires
    wire IRld, PCld, nPCld, RFld, MA, MC, ME, MF, MPA, MP, MR,
            RW, MOV, MDRld, MARld,Cin;        
    wire [1:0] MB;
    wire [5:0] OpC;
    wire [1:0] SSE;
    wire [3:0] OP;
    wire [6:0] activeState;

// Inputs    
    reg [31:0] IR;
    reg clk, reset, MOC, Cond, DMOC;

    reg [1:0] instructionSelect; // Used to dynamically load new instruction to IR in Testbench.

/// Control Unit Declaration
    ControlUnit CU( IRld, PCld, nPCld, RFld, MA, MB, MC, ME, MF, MPA, 
                    MP, MR, RW, MOV, MDRld, MARld, OpC, Cin, SSE, OP, 
                    activeState, //Outputting active state for testing purposes
                    clk, reset, IR, MOC, Cond, DMOC);

/// Simulation Parameters.
 // 12 up-down clock cycles of #2.
    initial begin
        clk = 1'b0;
        repeat (52)
        #1 clk = !clk;
    end

// Start the system with a hard Reset for #2 (while the clock ticks, loading CR).
    initial begin
        reset = 1'b1;
        #2 reset = 1'b0;
    end

// Set initial Variables for the system.
    initial begin
        MOC = 1'b0; 
        Cond = 1'b0;
        DMOC = 1'b0;
        instructionSelect = 2'd0;
    end

   // Simulate 2 cycles (#4 time delays) for every RAM access.
    always @(posedge MOV) begin
        MOC= 1'b0;
        if(activeState == 7'd3) begin
            // Dynamically cycle through existing instructions.
            case(instructionSelect)
                2'd0: IR = 32'b00000000001000100001100000100001; //ADDU
                2'd1: IR = 32'b10100000011000100000000000010011; //SB
                2'd2: IR = 32'b00010000010000100000000000101011; //BEQ
                default: begin
                    IR = 32'b00000000001000100001100000100001; //ADDU
                    instructionSelect = 2'd0;
                end
            endcase
            instructionSelect = instructionSelect + 1;
        end
        #4 MOC= 1'b1;
    end

// Set whether the ALU's Compare result is 0 (false) or 1 (true)
    always @(OP) begin
        if(OP == 4'b1111)
            Cond = 1'b1;
    end

/// Displays
    initial begin
        $display("CState|IRld|PCld|nPCld|RFld|MA|MB|MC|ME|MF|MPA|MP|MR|RW|MOV|MDRld|MARld|  OpC |Cin|SSE| OP |               time");
    end 
    always @(negedge clk) begin
            $display("%d     %b    %b     %b    %b   %b  %b %b  %b  %b   %b  %b  %b  %b   %b    %b     %b   %b  %b  %b  %b %d",
                        activeState , IRld, PCld, nPCld, RFld, MA, MB,MC, ME, MF, MPA, MP, MR, RW, MOV, MDRld, MARld, OpC, Cin,SSE, OP,  $time);
    end
endmodule