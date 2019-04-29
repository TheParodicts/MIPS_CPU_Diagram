`include "RegisterFile.v"

module CP0_Register_Status(output reg [31:0] out, input IE, EXL, NMI, MI); 
    reg [31:0] in;
    always @ (*) begin
        in[0] = IE; 
        in[1] = EXL;
        in[19] = NMI;
        in[10] = MI;
        out <= in;
        end
    endmodule

module CP0_Register_Cause(output reg [31:0] out, input [4:0] Cause_exc, input IP); 
    reg [31:0] in;
    always @ (*) begin
        in[6:2] = Cause_exc; 
        in[10] = IP;
        out <= in;
        end
    endmodule

module Async_Registers(output reg [31:0] out, input [31:0] in, input enable, clk); 
    always @ (*)
        out <= in;
    endmodule

module CoProcessor (output [31:0] data_mux_A, 
                    input[31:0] data, 
                    input[4:0] select_reg_A, select_reg_B, write_reg, 
                    input Ld, Clk );

    reg [31:0] in_stats = 32'd0;
    reg [31:0] in_cause = 32'd0;

    in_stats[0] = IE;
    in_stats[1] = EXL;
    in_stats[10] = IM2;
    in_stats[19] = NMI;

    in_cause[10] = IP2;

    if (Enable) begin
        assign in_stats = in;
        assign in_cause = in; 
    end

    wire [31:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, 
                r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27, 
                r28, r29, r30, r31;
    
    wire [31:0] dec_enable_reg;

    Decoder binary_decoder (dec_enable_reg, write_reg, Enable);

    Mux_32x32 mux_A (in_mux_A, select_reg_A, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10,
                r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, 
                r23, r24, r25, r26, r27, r28, r29, r30, r31);
    
    Mux_32x32 mux_B (in_mux_B, select_reg_B, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10,
                r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, 
                r23, r24, r25, r26, r27, r28, r29, r30, r31);

    Registers R0 (r0, in, dec_enable_reg[0], clk ); 
    // Hacked the enable to match with th so it always outputs 0.

    Registers R1 (r1, in, dec_enable_reg[1], Clk );
    Registers R2 (r2,  in, dec_enable_reg[2], Clk );
    Registers R3 (r3,  in, dec_enable_reg[3], Clk );
    Registers R4 (r4,  in, dec_enable_reg[4], Clk );
    Registers R5 (r5, in, dec_enable_reg[5], Clk );
    Registers R6 (r6, in, dec_enable_reg[6], Clk );
    Registers R7 (r7, in, dec_enable_reg[7], Clk );
    Registers R8 (r8, in, dec_enable_reg[8], Clk );
    Registers R9 (r9,  in, dec_enable_reg[9], Clk );
    Registers R10 (r10, in, dec_enable_reg[10], Clk );
    Registers R11 (r11, in, dec_enable_reg[11], Clk );

    Registers R12 (r12, in_stats, dec_enable_reg[12], clk ); // status register
    Registers R13 (r13, in_cause, dec_enable_reg[13], clk ); // cause register
    Registers R14 (r14, in, dec_enable_reg[14], clk );  // EPC

    Registers R15 (r15, in, dec_enable_reg[15], Clk );
    Registers R16 (r16, in, dec_enable_reg[16], Clk );
    Registers R17 (r17, in, dec_enable_reg[17], Clk );
    Registers R18 (r18, in, dec_enable_reg[18], Clk );
    Registers R19 (r19, in, dec_enable_reg[19], Clk );
    Registers R20 (r20, in, dec_enable_reg[20], Clk );
    Registers R21 (r21, in, dec_enable_reg[21], Clk );
    Registers R22 (r22, in, dec_enable_reg[22], Clk );
    Registers R23 (r23, in, dec_enable_reg[23], Clk );
    Registers R24 (r24, in, dec_enable_reg[24], Clk );
    Registers R25 (r25, in, dec_enable_reg[25], Clk );
    Registers R26 (r26, in, dec_enable_reg[26], Clk );
    Registers R27 (r27, in, dec_enable_reg[27], Clk );
    Registers R28 (r28, in, dec_enable_reg[28], Clk );
    Registers R29 (r29, in, dec_enable_reg[29], Clk );
    Registers R30 (r30, in, dec_enable_reg[30], Clk );
    Registers R31 (r31, in, dec_enable_reg[31], Clk );
    
    always(posedge clk) begin
        if(IE) begin
            if(NMI == 1) begin
                EXL = 1;
                dec_enable_reg[12] = 1'b1;
                dec_enable_reg[13] = 1'b1;
                dec_enable_reg[14] = 1'b1;
                out = 32'd384;
                in_cause[6:2] = 5'b00000;
            end

            else begin
                if(IP2 == 1) begin
                    IP2 = 0; 
                    if (IM2 == 1) begin 
                        EXL = 1'b1;
                        dec_enable_reg[14] = 1'b1;
                    end
                end

            end
        end
    end

    endmodule

// ---------------- Modulo de Prueba ------------------------------------

// module test; 
//     wire [31:0] in_mux_A, in_mux_B;      // output from multiplexers
//     reg [31:0] in;                        // in to be written to a register
//     reg [4:0] select_reg_A, select_reg_B;    // select register on multiplexer A and B
//     reg [4:0] write_reg;                     // select which register to write in 
//     reg Ld;                                 // load to Decoder
//     re;                                 // clock for Registers

//     RegisterFile regF (in_mux_A, in_mux_B,  in, select_reg_A, select_reg_B, write_reg, Ld);

//     initial #135 $finish;
//     initial begin
//        = 1'b0;
//         Ld = 1'b1;
//         forever # =;
//     end
//     initial begin
//         write_reg = 5'b00000;   // selection of register to write, from decoder
//         repeat (64) #2 write_reg = write_reg + 5'b00001;  //changes register where to store in
//     end
//     initial begin
//         in = 32'd0;  // in to be stored in registers
//         repeat (64) #2 in = in + 32'd1;
//     end
//     initial fork
//         #129 $display ("|C|          |in|      |A|          |out A|");
//         #129 write_reg = 5'd0; 
//         #129 in = 32'd15;
//         #129 select_reg_A = 5'd0;

//         join
//     initial begin
//         select_reg_A = 5'b00000; // select mux A
//         repeat (64) #2 select_reg_A = select_reg_A + 5'b00001;
//     end
//      initial begin
//         select_reg_B = 5'b00000;    //select mux B
//         repeat (64) #2 select_reg_B = select_reg_B + 5'b00001;
//     end

//     initial begin 
// 	// write to reg = señal (decoder) que indica a que registro se va a guardar la in
// 	// in = la in que se va a guardar en un registro
// 	// select_reg_mux_A / select_reg_mux_B = señal indica que registro se selecciona del multiplexer A o B, respectivamente
// 	// out_mux_A / out_mux_B = output del multiplexer correspondiente

//         $display (" C         in    select_reg_mux_A     A    select_reg_mux_B        B   ");  
//         $monitor (" %d    %d         %d     %d      %d         %d          %d    ",  write_reg, in, select_reg_A, in_mux_A, select_reg_B, in_mux_B);      
//     end 

// endmodule