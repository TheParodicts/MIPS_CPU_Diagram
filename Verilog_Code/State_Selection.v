module Condition_Mux(output reg out, input [1:0] S, input moc, cond, dmoc); 
    always @ (moc,cond,dmoc)
        case(S)
            2'b00: out <= moc;
            2'b01: out <= cond;
            2'b10: out <= dmoc;
        endcase
    endmodule

module Inverter(output reg out, input inv, in);
    always @ (inv, in, out)
        if(inv)
            out <= ~in; 
        else out <= in;
    endmodule

module Next_State_Address_Selector(output reg [1:0]  M,  input sts, input[2:0] N);
    always @ (N, sts)
        case(N)
            3'b000: M <= 2'b00;
            3'b001: M <= 2'b01;
            3'b010: M <= 2'b10;
            3'b011: M <= 2'b11;
            3'b100: 
                if(!sts) M <= 2'b10;
                else M <= 2'b00;
            3'b101:
                if(!sts) M <= 2'b10;
                else M <= 2'b01;
            3'b110:
                if(!sts) M <= 2'b01;
                else M <= 2'b11;
        endcase
    endmodule   

module State_Selector_Mux(output reg [6:0] state, input [1:0] M, input [6:0] Encoder, HC1, CR, Incrementer); 
    always @ (M)
        case(M)
            2'b00: state <= Encoder;
            2'b01: state <= HC1;
            2'b10: state <= CR;
            2'b11: state <= Incrementer;
        endcase
    endmodule  

module IncReg_Adder(output reg [6:0] N_state, input[6:0] C_state);
    always @ (C_state)
        N_state <= C_state + 7'd1;
    endmodule

module Incrementer_Reg(output reg [6:0] state, input[6:0] inc_state, input Ld, clk); 
    always @ (posedge clk)
        if(Ld)
            state <= inc_state; 
    endmodule

module test;
    reg moc, cond, dmoc, inv, Ld, clk; // can choose on test
    reg [2:0] N; // can choose on test
    reg [1:0] S; // can choose on test
    reg [6:0] Encoder, HC1, CR; // can choose on test
    wire [6:0] out_Mux_StateSlct, Incrementer, out_adder;
    wire in_inv, sts;
    wire [1:0] M; 

    Condition_Mux cond_mux(in_inv, S, moc, cond, dmoc);
    Inverter inverter(sts, inv, in_inv);
    Next_State_Address_Selector nsas(M, sts, N);
    State_Selector_Mux state_select_mux(out_Mux_StateSlct, M, Encoder, HC1, CR, Incrementer);
    IncReg_Adder adder(out_adder, out_Mux_StateSlct);
    Incrementer_Reg incr_reg(Incrementer, out_adder, Ld, clk);

    initial #10 $finish;
    initial begin
        moc = 1'b0; 
        cond = 1'b0;
        dmoc = 1'b0;
        inv = 1'b0;
        Ld =  1'b1;
        clk = 1'b0;
        N = 3'b000;
        S = 2'b00; 
        Encoder = 7'd9; 
        HC1= 7'd1;
        CR = 7'd8;
        repeat (10) #1 N = N + 3'b001;
    end
    initial begin 
        forever #1 clk = ~clk;
    end
    initial fork 
        #4 N = 3'b011;
        #6 N = 3'b100;
        #7 N = 3'b100;
        #7 inv = ~inv; 
    join 
    initial begin
        $display (" N    M   inv  state");  
        $monitor (" %b  %b   %b  %d  ", N, M, inv, out_Mux_StateSlct);      
    end
    endmodule