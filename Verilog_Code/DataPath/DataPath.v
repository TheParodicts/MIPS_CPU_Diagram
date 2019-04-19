`include "ControlUnit.v"
`include "RegisterFile.v"
`include "muxes.v"

module DataPath(output [31:0] IR_o, MAR_o, PC_o, nPC_o, DataIn_o, 
                output RW_o, MOV_o, 
                output[6:0] aState, OpC_o, 
                input clk, reset, Cond, MOC, DMOC, DataOut);
                
/// Control Unit Declarations.
/// Required wires
// Output wires
    wire IRld, PCld, nPCld, RFld, MA, MC, ME, MF, MPA, MP, MR,
            RW, MOV, MDRld, MARld,Cin;        
    wire [1:0] MB;
    wire [5:0] OpC;
    wire [1:0] SSE;
    wire [3:0] OP;
    wire [6:0] activeState;

    assign aState=activeState;
    assign IR_o = IR;
    assign MAR_o = MAR_out;
    assign PC_o = PC_out;
    assign nPC_o = nPC_out;
    assign DataIn_o = DataIn;
    reg [31:0] DataIn = 32'd3;
    assign RW_o = RW;
    assign MOV_o = MOV;
    assign OpC_o = OpC;


/// Control Unit Declaration
    ControlUnit CU( IRld, PCld, nPCld, RFld, MA, MB, MC, ME, MF, MPA, 
                    MP, MR, RW, MOV, MDRld, MARld, OpC, Cin, SSE, OP, 
                    activeState, //Outputting active state for testing purposes
                    clk, reset, IR, MOC, Cond, DMOC);


/// Ext. Register Declarations.
    wire [31:0] IR, MAR_out, PC_out, nPC_out, nPC_Adder_out;
    wire [31:0] MUXP_out, MUXR_out, MUXP_out, MUXE_out;
    wire [5:0] MUXF_out

    reg [31:0] ALU_out = 32'd1;// Left as Reg for testing purposes for now.

    Registers PC(PC_out, nPC_out, PCld, clk);
    Registers nPC(nPC_out, MUXP_out, nPCld, clk);
    Registers InstructionRegister(IR, DataOut, IRld, clk);
    Registers MAR(MAR_out, MUXR_out, MARld, clk);

/// Muxes Declarations.
    MUX_2x1_32b MUXP(MUXP_out, ALU_out, nPC_Adder_out, MP);
    MUX_2x1_32b MUXE(MUXE_out, DataOut, ALU_out, ME);
    MUX_2x1_32b MUXR(MUXR_out, ALU_out, PC_out, MR);

    MUX_2x1_6b MUXF(MUXF_out, OpC, IR, MF);

endmodule