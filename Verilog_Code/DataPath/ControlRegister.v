module ControlRegister( output reg IRld, PCld, nPCld, RFld, HIld, LOld,
                        output reg[1:0] MA, MB, MC,
                        output reg ME, MF, 
                        output reg [1:0] MPA,
                        output reg MPB, MP, MR, MHI,
                        output reg RW, MOV, MDRld, MARld, 
                        output reg [5:0] OpC,
                        output reg Cin,
                        output reg [1:0] SSE,
                        output reg [3:0] OP,
                        output reg [6:0] CR,
                        output reg Inv, IncRld,
                        output reg [1:0] S,
                        output reg [2:0] N,
                        output reg [6:0] activeState,
                        input [50:0] currentStateSignals, input clk,
                        input [6:0] curState); 

always @ (negedge clk)
    // Update the Status Signals with the batch of input bits.
    begin
        IRld = currentStateSignals[50];
        PCld = currentStateSignals[49];
        nPCld = currentStateSignals[48];
        RFld = currentStateSignals[47];
        HIld = currentStateSignals[46];
        LOld = currentStateSignals[45];
        MA = currentStateSignals[44:43];
        MB = currentStateSignals[42:41];
        MC = currentStateSignals[40:39];
        ME = currentStateSignals[38];
        MF = currentStateSignals[37];
        MPA = currentStateSignals[36:35];
        MPB = currentStateSignals[34];
        MP = currentStateSignals[33];
        MR = currentStateSignals[32];
        MHI = currentStateSignals[31];
        RW = currentStateSignals[30];
        MOV = currentStateSignals[29];
        MDRld = currentStateSignals[28];
        MARld = currentStateSignals[27];
        OpC = currentStateSignals[26:21];
        Cin = currentStateSignals[20];
        SSE = currentStateSignals[19:18];
        OP = currentStateSignals[17:14];
        CR = currentStateSignals[13:7];
        Inv = currentStateSignals[6];
        IncRld = currentStateSignals[5];
        S = currentStateSignals[4:3];
        N = currentStateSignals[2:0];
        activeState = curState; // For testing purposes
    end
    //     initial begin
    //     $display("clk, IRld, PCld, nPCld, RFld, MA, MB,  MC, ME, MF, MPA, MP, MR, RW, MOV, MDRld, MARld,   OpC,     Cin,  SSE,    OP,     CR,    Inv, IncRld,   S,   N ");
    //     $monitor("%b     %b      %b     %b     %b     %b  %b   %b   %b   %b    %b    %b   %b   %b   %b      %b    %b      %b     %b    %b     %b   %b   %b    %b        %b  %b", clk, IRld, PCld, nPCld, RFld, MA, MB,MC, ME, MF, MPA, MP, MR, RW, MOV, MDRld, MARld, OpC, Cin,SSE, OP, CR, Inv, IncRld, S,  N );
    // end
endmodule

// module CR_Testbench;
//     reg clk;
//     reg [43:0] stateSig;
//     wire IRld, PCld, nPCld, RFld, MA, MC, ME, MF, MPA, MP, MR, RW, MOV, MDRld, MARld, Cin, Inv, IncRld;
//     wire [1:0] MB;
//     wire [5:0] OpC;
//     wire [1:0] SSE;
//     wire [3:0] OP;
//     wire [6:0] CR;
//     wire [1:0] S;
//     wire [2:0] N;

//Outdated, need to update for future testing.
//     ControlRegister CReg(stateSig, clk, IRld, PCld, nPCld,
//                             RFld, MA, MB, MC, ME, MF, 
//                             MPA, MP, MR, RW, MOV, MDRld, 
//                             MARld, OpC, Cin, SSE, OP, CR, 
//                             Inv, IncRld, S, N);

//     initial begin
//         clk = 1'b0;
//         repeat (4)
//             #1 clk = !clk;
//     end

//     initial begin
//     stateSig = 44'b00100110000000000000000000001000000000000001; //Reset
//     #3 stateSig = 44'b00000000010000100000000000000000000000100011; //State 8
//     end



// endmodule