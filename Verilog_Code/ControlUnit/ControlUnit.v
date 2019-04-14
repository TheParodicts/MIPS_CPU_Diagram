`include "ControlRegister.v"
`include "Microstore.v"

module MicroRegister_Testbench;
    reg clk, reset;
    reg [6:0] state;
    wire[43:0] StateSignals;
    Microstore Mstore(state, reset, StateSignals);

    wire IRld, PCld, nPCld, RFld, MA, MC, ME, MF, MPA, MP, MR, RW, MOV, MDRld, MARld, Cin, Inv, IncRld;
    wire [1:0] MB;
    wire [5:0] OpC;
    wire [1:0] SSE;
    wire [3:0] OP;
    wire [6:0] CR;
    wire [1:0] S;
    wire [2:0] N;
    ControlRegister CReg(StateSignals, clk, IRld, PCld, nPCld,
                            RFld, MA, MB, MC, ME, MF, 
                            MPA, MP, MR, RW, MOV, MDRld, 
                            MARld, OpC, Cin, SSE, OP, CR, 
                            Inv, IncRld, S, N);

    initial begin
        clk = 1'b0;
        reset = 1'b0;
        // 12 up-down clock cycles of #2.
        repeat (26)
            #1 clk = !clk;
    end

    initial begin
        state = 7'd0;
            repeat(12)
                #2 state = state +1;
    end

    initial begin
        $display("State| IRld| PCld| nPCld| RFld| MA| MB|  MC| ME| MF| MPA| MP| MR| RW| MOV| MDRld| MARld|   OpC   |  Cin|  SSE|    OP  |     CR   | Inv| IncRld| S|   N  | clk|         time ");
        $monitor("%d      %b     %b      %b     %b    %b  %b   %b   %b   %b    %b    %b   %b   %b   %b     %b      %b     %b     %b     %b    %b     %b   %b    %b     %b   %b    %b %d",state , IRld, PCld, nPCld, RFld, MA, MB,MC, ME, MF, MPA, MP, MR, RW, MOV, MDRld, MARld, OpC, Cin,SSE, OP, CR, Inv, IncRld, S,  N, clk, $time );
    end
endmodule