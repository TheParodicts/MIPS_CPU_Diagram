`include "ControlRegister.v"
`include "Microstore.v"
`include "State_Selection.v"
`include "State_Encoder.v"

module ControlUnit( output IRld, PCld, nPCld, RFld, MA,
                        output [1:0] MB,
                        output MC, ME, MF, MPA, MP, MR,
                        output RW, MOV, MDRld, MARld, 
                        output [5:0] OpC,
                        output Cin,
                        output [1:0] SSE,
                        output [3:0] OP,
                        output [6:0] activeState, //Testing purposes
                        input clk, reset,
                        input [31:0] IR,
                        input MOC, Cond, DMOC);
                        
// Microstore declarations
    wire[43:0] StateSignals;
    wire[6:0] curState; // For testing purposes.
    Microstore Mstore(StateSignals, curState, reset, out_Mux_StateSlct);

// Control Register Declarations
    wire Inv, IncRld;
    wire [6:0] CR;
    wire [1:0] S;
    wire [2:0] N;
    ControlRegister CReg( IRld, PCld, nPCld,
                            RFld, MA, MB, MC, ME, MF, 
                            MPA, MP, MR, RW, MOV, MDRld, 
                            MARld, OpC, Cin, SSE, OP, CR, 
                            Inv, IncRld, S, N, 
                            activeState,
                            StateSignals, clk,
                            curState);

// State Selection Declarations
    reg [6:0]  HC1 = 7'd1;
    wire [6:0] out_Mux_StateSlct, Incrementer, out_adder, encodedOut;
    wire in_inv, Sts;
    wire [1:0] M; 

    Condition_Mux cond_mux(in_inv, S, MOC, Cond, DMOC);
    Inverter inverter(Sts, Inv, in_inv);
    Next_State_Address_Selector nsas(M, Sts, N);
    State_Selector_Mux state_select_mux(out_Mux_StateSlct, M, encodedOut, HC1, CR, Incrementer);
    IncReg_Adder adder(out_adder, out_Mux_StateSlct);
    Incrementer_Reg incr_reg(Incrementer, out_adder, IncRld, clk);

// State Encoder Declarations
    Encoder IRencodedOut(IR, encodedOut);

    // For debugging.
    // initial begin
    //     $display("IR,                                 CR,  Inv, IncRld, S,  N, active state, nextState, encodedOut");
    //     $monitor("%b  %b  %b      %b  %b  %b     %d       %d          %d", IR, CR, Inv, IncRld, S, N, curState, out_Mux_StateSlct, encodedOut);
    // end

endmodule