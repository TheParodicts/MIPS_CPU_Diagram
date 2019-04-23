`include "ControlUnit.v"
`include "RegisterFile.v"
`include "muxes.v"

module nPC_adder(output reg [31:0] adder_out, input [31:0] nPC);
    always @ (nPC)
        adder_out <= nPC + 32'd4;
    endmodule

module DataPath(output [31:0] IR_o, MAR_o, PC_o, nPC_o, DataIn_o, out_PA_regFile, out_PB_regFile,  
                output RW_o, MOV_o, RFld,
                output[6:0] aState, output [5:0] OpC_o, output [4:0] MA_o,B_o,
                input clk, reset, Cond, MOC, DMOC, 
                input [31:0] DataOut);
                
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
    wire [5:0] MUXF_out;

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
    assign MR_0 = MR;
    assign out_PA_regFile = PA_regFile;
    assign out_PB_regFile = PB_regFile; 
    assign MA_o = MUXPA_out;
    assign B_o = IR[25:21];


wire [31:0] IR, MAR_out, PC_out, nPC_out, nPC_Adder_out, MDR_out;
/// Control Unit Declaration
    ControlUnit CU( IRld, PCld, nPCld, RFld, MA, MB, MC, ME, MF, MPA, 
                    MP, MR, RW, MOV, MDRld, MARld, OpC, Cin, SSE, OP, 
                    activeState, //Outputting active state for testing purposes
                    clk, reset, IR, MOC, Cond, DMOC);

/// Ext. Register Declarations.
    
    wire [31:0] MUXP_out, MUXR_out, MUXE_out;
    
    wire [4:0] MUXC_out, MUXPA_out;

    reg [31:0] ALU_out = 32'd0;// Left as Reg for testing purposes for now.

    Registers PC(PC_out, nPC_out, PCld, clk);
    Registers nPC(nPC_out, MUXP_out, nPCld, clk);
    Registers InstructionRegister(IR, DataOut, IRld, clk);
    Registers MAR(MAR_out, MUXR_out, MARld, clk);
    Registers MDR(MDR_out, MUXE_out, MDRld, clk);

// nPC Adder
    nPC_adder npc_adder(nPC_Adder_out, nPC_out);

/// Muxes Declarations.
    Mux_2x1_32b MUXP(MUXP_out, ALU_out, nPC_Adder_out, MP);
    Mux_2x1_32b MUXE(MUXE_out, DataOut, ALU_out, ME);
    Mux_2x1_32b MUXR(MUXR_out, ALU_out, PC_out, MR);

    Mux_2x1_6b MUXF(MUXF_out, OpC, IR[31:26], MF);

    Mux_2x1_5b MUXC(MUXC_out, IR[15:11], IR[20:16], MC);
    Mux_2x1_5b MUXPA(MUXPA_out, IR[20:16], IR[25:21], MPA);

//Register File Declarations.
    
    wire [31:0] PA_regFile, PB_regFile;

    //change RegData for Aluout and wtoReg to MUXC_out after testing
    RegisterFile registerFile(PA_regFile, PB_regFile, ALU_out, 
                            MUXPA_out, IR[25:21], MUXC_out, RFld, clk);

    // always @(*)begin
    //     $monitor(" %b  %b  %b  %b", MAR_out, MUXR_out, MARld, clk);
    //     end
endmodule