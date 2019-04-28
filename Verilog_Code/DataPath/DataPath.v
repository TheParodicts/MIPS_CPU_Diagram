`include "ControlUnit.v"
`include "RegisterFile.v"
`include "muxes.v"
`include "alu.v"
`include "Sign_Extender.v"

module nPC_adder(output reg [31:0] adder_out, input [31:0] nPC);
    always @ (nPC)
        adder_out <= nPC + 32'd4;
    endmodule

module DataPath(output [31:0] IR_o, MAR_o, PC_o, nPC_o, DataIn_o, out_PA_regFile, out_PB_regFile,  
                output RW_o, MOV_o, RFld,
                output[6:0] aState, output [5:0] MUXF_out, output [4:0] MA_o,B_o,
                input clk, reset, Cond, MOC, DMOC, 
                input [31:0] DataOut);
                
/// Control Unit Declarations.
/// Required wires
// Output wires
    wire IRld, PCld, nPCld, RFld, MA, MC, ME, MF, MP, MR,
            RW, MOV, MDRld, MARld,Cin;        
    wire [1:0]  MPA, MB;
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
    assign DataIn_o = MDR_out;
    assign RW_o = RW;
    assign MOV_o = MOV;
    assign OpC_o = MUXF_out;
    assign MR_0 = MR;
    assign out_PA_regFile = PA_regFile;
    assign out_PB_regFile = PB_regFile; 
    assign MA_o = MUXPA_out; // this output is for testing - att.Sofia
    assign B_o = IR[25:21]; // this output is for testing - att.Sofia


wire [31:0] IR, MAR_out, PC_out, nPC_out, nPC_Adder_out, MDR_out;
/// Control Unit Declaration
    ControlUnit CU( IRld, PCld, nPCld, RFld, MA, MB, MC, ME, MF, MPA, 
                    MP, MR, RW, MOV, MDRld, MARld, OpC, Cin, SSE, OP, 
                    activeState, //Outputting active state for testing purposes
                    clk, reset, IR, MOC, Cond, DMOC);

/// Ext. Register Declarations.
    
    wire [31:0] MUXP_out, MUXR_out, MUXE_out;
    
    wire [4:0] MUXC_out, MUXPA_out;

    //reg [31:0] ALU_out = 32'd0;// Left as Reg for testing purposes for now.
    wire [31:0] ALU_out;

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
    Mux_3x1_5b MUXPA(MUXPA_out, IR[20:16], IR[25:21], 5'b0, MPA);

    
//Register File Declarations.
    
    wire [31:0] PA_regFile, PB_regFile;

    //change RegData for Aluout and wtoReg to MUXC_out after testing
    RegisterFile registerFile(PA_regFile, PB_regFile, ALU_out, 
                            MUXPA_out, IR[25:21], MUXC_out, RFld, clk);

// ALU Declarations.
    wire [31:0] MUXA_out;
    wire [31:0] MUXB_out;
    wire [31:0] SE_out;

    wire Z_flag, OvrF_flag;

    Sign_Extender SE(SE_out, IR, SSE);

    Mux_2x1_32b MUXA(MUXA_out, PC_out, PA_regFile, MA);
    Mux_4x1_32b MUXB(MUXB_out, MDR_out, PB_regFile, SE_out, 32'b0, MB);


    // Missing: ALU Sign input, SE case select, TESTING
    ALU ALU(ALU_out, MUXA_out, MUXB_out, OP, Cin, 1'b0, Z_flag, OvrF_flag);

    // always @(*)begin
    //     $monitor(" %b  %b  %b  %b", MF, MUXF_out, MOV, clk);
    //     end
endmodule