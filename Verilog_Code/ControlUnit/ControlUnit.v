`include "ControlRegister.v"
`include "Microstore.v"
`include "State_Selection.v"
`include "State_Encoder.v"

module MicroRegister_Testbench;
// Microstore declarations
    reg clk, reset;
   // reg [6:0] state;
    wire[43:0] StateSignals;
    wire[6:0] curState; // For testing purposes.
    Microstore Mstore(StateSignals, curState, reset, out_Mux_StateSlct);

// Control Register Declarations
    wire IRld, PCld, nPCld, RFld, MA, MC, ME, MF, MPA, MP, MR, RW, MOV, 
            MDRld, MARld, Cin, Inv, IncRld;
    wire [1:0] MB;
    wire [5:0] OpC;
    wire [1:0] SSE;
    wire [3:0] OP;
    wire [6:0] CR;
    wire [1:0] S;
    wire [2:0] N;
    wire [6:0] activeState; // For testing purposes.
    ControlRegister CReg( IRld, PCld, nPCld,
                            RFld, MA, MB, MC, ME, MF, 
                            MPA, MP, MR, RW, MOV, MDRld, 
                            MARld, OpC, Cin, SSE, OP, CR, 
                            Inv, IncRld, S, N, 
                            activeState,
                            StateSignals, clk,
                            curState);

// State Selection Declarations
    reg moc, cond, dmoc; // can choose on test
    reg [6:0]  HC1; // can choose on test
    wire [6:0] out_Mux_StateSlct, Incrementer, out_adder, encodedOut;
    wire in_inv, sts;
    wire [1:0] M; 

    Condition_Mux cond_mux(in_inv, S, moc, cond, dmoc);
    Inverter inverter(sts, Inv, in_inv);
    Next_State_Address_Selector nsas(M, sts, N);
    State_Selector_Mux state_select_mux(out_Mux_StateSlct, M, encodedOut, HC1, CR, Incrementer);
    IncReg_Adder adder(out_adder, out_Mux_StateSlct);
    Incrementer_Reg incr_reg(Incrementer, out_adder, IncRld, clk);

// State Encoder Declarations
    reg [31:0] instruction;
    Encoder IRencodedOut(instruction, encodedOut);

 // 12 up-down clock cycles of #2.
    initial begin
        clk = 1'b0;
        repeat (26)
            #1 clk = !clk;
    end

// Start the system with a hard Reset for #2 (while the clock ticks, loading CR).
    initial begin
        reset = 1'b1;
        #2 reset = 1'b0;
    end

// Set initial Variables for the system.
    initial begin
        moc = 1'b0; 
        cond = 1'b0;
        dmoc = 1'b0;
        HC1= 7'd1;
        // instruction = 32'b00000000001000100001100000100001; //ADDU
        // instruction = 32'b10100000011000100000000000010011; //SB
       instruction = 32'b00010000010000100000000000101011; //BEQ
    end

   // Simulate 2 cycles (#4 time delays) for every RAM access.
    always @(posedge MOV) begin
        moc= 1'b0;
        #4 moc= 1'b1;
    end

// Set whether the ALU's Compare result is 0 (false) or 1 (true)
    always @(OP) begin
        if(OP == 4'b1111)
            cond = 1'b1;
    end
  


    initial begin
        $display("CState|IRld|PCld|nPCld|RFld|MA|MB|MC|ME|MF|MPA|MP|MR|RW|MOV|MDRld|MARld|  OpC |Cin|SSE| OP |   CR  |Inv|IncRld| S|  N |clk|               time");
        $monitor("%d     %b    %b     %b    %b   %b  %b %b  %b  %b   %b  %b  %b  %b   %b    %b     %b   %b  %b  %b  %b %b  %b     %b   %b  %b  %b %d",
                    activeState , IRld, PCld, nPCld, RFld, MA, MB,MC, ME, MF, MPA, MP, MR, RW, MOV, MDRld, MARld, OpC, Cin,SSE, OP, CR, Inv, IncRld, S,  N, clk, $time);
    end
endmodule