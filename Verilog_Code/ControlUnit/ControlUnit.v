`include "ControlRegister.v"
`include "Microstore.v"
`include "State_Selection.v"

module MicroRegister_Testbench;
// Microstore declarations
    reg clk, reset;
   // reg [6:0] state;
    wire[43:0] StateSignals;
    Microstore Mstore(out_Mux_StateSlct, reset, StateSignals);

// Control Register Declarations
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

// State Selection Declarations
    reg moc, cond, dmoc; // can choose on test
    reg [6:0] Encoder, HC1; // can choose on test
    wire [6:0] out_Mux_StateSlct, Incrementer, out_adder;
    wire in_inv, sts;
    wire [1:0] M; 

    Condition_Mux cond_mux(in_inv, S, moc, cond, dmoc);
    Inverter inverter(sts, Inv, in_inv);
    Next_State_Address_Selector nsas(M, sts, N);
    State_Selector_Mux state_select_mux(out_Mux_StateSlct, M, Encoder, HC1, CR, Incrementer);
    IncReg_Adder adder(out_adder, out_Mux_StateSlct);
    Incrementer_Reg incr_reg(Incrementer, out_adder, IncRld, clk);

    initial begin
        clk = 1'b0;
        // 12 up-down clock cycles of #2.
        repeat (26)
            #1 clk = !clk;
    end

    initial begin
        reset = 1'b1;
        #2 reset = 1'b0;

       
    end

    initial begin
        moc = 1'b0; 
        cond = 1'b1;
        dmoc = 1'b0;
        Encoder = 7'd10; 
        HC1= 7'd1;

        #13 moc=1'b1;
    end

    initial begin
        $display("NState| IRld| PCld| nPCld| RFld| MA| MB|  MC| ME| MF| MPA| MP| MR| RW| MOV| MDRld| MARld|   OpC   |  Cin|  SSE|    OP  |     CR   | Inv| IncRld| S|   N  | clk|         time ");
        $monitor("%d      %b     %b      %b     %b    %b  %b   %b   %b   %b    %b    %b   %b   %b   %b     %b      %b     %b     %b     %b    %b     %b   %b    %b     %b   %b    %b     %d",out_Mux_StateSlct , IRld, PCld, nPCld, RFld, MA, MB,MC, ME, MF, MPA, MP, MR, RW, MOV, MDRld, MARld, OpC, Cin,SSE, OP, CR, Inv, IncRld, S,  N, clk, $time);
    end
endmodule