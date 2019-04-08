
//-------------------- Register -----------------------------------


module Registers(output reg [31:0] out, input [31:0] in, input LE, clk); 
    always @ (posedge clk)
        if(LE) begin
            out <= in;
        end
    endmodule

// ---------------- Decoder ------------------------------------

module Decoder(output reg [31:0] E, input [4:0] select_reg, input Ld); 
    always @ (select_reg, Ld)
        if(Ld == 1) begin
            E <= 32'h00000000;
            case(select_reg)
                5'b00000: E[0] <= 1'b1;
                5'b00001: E[1] <= 1'b1;
                5'b00010: E[2] <= 1'b1;
                5'b00011: E[3] <= 1'b1;
                5'b00100: E[4] <= 1'b1;
                5'b00101: E[5] <= 1'b1;
                5'b00110: E[6] <= 1'b1;
                5'b00111: E[7] <= 1'b1;
                5'b01000: E[8] <= 1'b1;
                5'b01001: E[9] <= 1'b1;
                5'b01010: E[10] <= 1'b1;
                5'b01011: E[11] <= 1'b1;
                5'b01100: E[12] <= 1'b1;
                5'b01101: E[13] <= 1'b1;
                5'b01110: E[14] <= 1'b1;
                5'b01111: E[15] <= 1'b1;
                5'b10000: E[16] <= 1'b1;
                5'b10001: E[17] <= 1'b1;
                5'b10010: E[18] <= 1'b1;
                5'b10011: E[19] <= 1'b1;
                5'b10100: E[20] <= 1'b1;
                5'b10101: E[21] <= 1'b1;
                5'b10110: E[22] <= 1'b1;
                5'b10111: E[23] <= 1'b1;
                5'b11000: E[24] <= 1'b1;
                5'b11001: E[25] <= 1'b1;
                5'b11010: E[26] <= 1'b1;
                5'b11011: E[27] <= 1'b1;
                5'b11100: E[28] <= 1'b1;
                5'b11101: E[29] <= 1'b1;
                5'b11110: E[30] <= 1'b1;
                5'b11111: E[31] <= 1'b1;
            endcase
            end
        else 
            E <= 32'h00000000;
        

    endmodule

// ---------------- Multiplexer ------------------------------------

module Mux_32x32(output reg [31:0] data_out, 
                input [4:0] select_reg, 
                input [31:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10,
                r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, 
                r23, r24, r25, r26, r27, r28, r29, r30, r31 ); 
    always @ (select_reg, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10,
                r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, 
                r23, r24, r25, r26, r27, r28, r29, r30, r31)
        case(select_reg) 
            5'b00000: data_out <= r0;
            5'b00001: data_out <= r1;
            5'b00010: data_out <= r2;
            5'b00011: data_out <= r3;
            5'b00100: data_out <= r4;
            5'b00101: data_out <= r5;
            5'b00110: data_out <= r6;
            5'b00111: data_out <= r7;
            5'b01000: data_out <= r8;
            5'b01001: data_out <= r9;
            5'b01010: data_out <= r10;
            5'b01011: data_out <= r11;
            5'b01100: data_out <= r12;
            5'b01101: data_out <= r13;
            5'b01110: data_out <= r14;
            5'b01111: data_out <= r15;
            5'b10000: data_out <= r16;
            5'b10001: data_out <= r17;
            5'b10010: data_out <= r18;
            5'b10011: data_out <= r19;
            5'b10100: data_out <= r20;
            5'b10101: data_out <= r21;
            5'b10110: data_out <= r22;
            5'b10111: data_out <= r23;
            5'b11000: data_out <= r24;
            5'b11001: data_out <= r25;
            5'b11010: data_out <= r26;
            5'b11011: data_out <= r27;
            5'b11100: data_out <= r28;
            5'b11101: data_out <= r29;
            5'b11110: data_out <= r30;
            5'b11111: data_out <= r31;
        endcase
        
    endmodule

// ---------------- Register File ------------------------------------


module RegisterFile (output [31:0] data_mux_A, data_mux_B, 
                    input[31:0] data, 
                    input[4:0] select_reg_A, select_reg_B, write_reg, 
                    input Ld, Clk);

    wire [31:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, 
                r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27, 
                r28, r29, r30, r31;
    
    wire [31:0] dec_enable_reg;

    Decoder binary_decoder (dec_enable_reg, write_reg, Ld);

     Mux_32x32 mux_A (data_mux_A, select_reg_A, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10,
                r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, 
                r23, r24, r25, r26, r27, r28, r29, r30, r31);
    
    Mux_32x32 mux_B (data_mux_B, select_reg_B, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10,
                r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, 
                r23, r24, r25, r26, r27, r28, r29, r30, r31);

    Registers R0 (r0, 32'h00000000, dec_enable_reg[0], Clk ); //hardcoded to have 0
    Registers R1 (r1, data, dec_enable_reg[1], Clk );
    Registers R2 (r2,  data, dec_enable_reg[2], Clk );
    Registers R3 (r3,  data, dec_enable_reg[3], Clk );
    Registers R4 (r4,  data, dec_enable_reg[4], Clk );
    Registers R5 (r5, data, dec_enable_reg[5], Clk );
    Registers R6 (r6, data, dec_enable_reg[6], Clk );
    Registers R7 (r7, data, dec_enable_reg[7], Clk );
    Registers R8 (r8, data, dec_enable_reg[8], Clk );
    Registers R9 (r9,  data, dec_enable_reg[9], Clk );
    Registers R10 (r10, data, dec_enable_reg[10], Clk );
    Registers R11 (r11, data, dec_enable_reg[11], Clk );
    Registers R12 (r12, data, dec_enable_reg[12], Clk );
    Registers R13 (r13, data, dec_enable_reg[13], Clk );
    Registers R14 (r14, data, dec_enable_reg[14], Clk );
    Registers R15 (r15, data, dec_enable_reg[15], Clk );
    Registers R16 (r16, data, dec_enable_reg[16], Clk );
    Registers R17 (r17, data, dec_enable_reg[17], Clk );
    Registers R18 (r18, data, dec_enable_reg[18], Clk );
    Registers R19 (r19, data, dec_enable_reg[19], Clk );
    Registers R20 (r20, data, dec_enable_reg[20], Clk );
    Registers R21 (r21, data, dec_enable_reg[21], Clk );
    Registers R22 (r22, data, dec_enable_reg[22], Clk );
    Registers R23 (r23, data, dec_enable_reg[23], Clk );
    Registers R24 (r24, data, dec_enable_reg[24], Clk );
    Registers R25 (r25, data, dec_enable_reg[25], Clk );
    Registers R26 (r26, data, dec_enable_reg[26], Clk );
    Registers R27 (r27, data, dec_enable_reg[27], Clk );
    Registers R28 (r28, data, dec_enable_reg[28], Clk );
    Registers R29 (r29, data, dec_enable_reg[29], Clk );
    Registers R30 (r30, data, dec_enable_reg[30], Clk );
    Registers R31 (r31, data, dec_enable_reg[31], Clk );
    
    endmodule

// ---------------- Modulo de Prueba ------------------------------------

module test; 
    wire [31:0] data_mux_A, data_mux_B;      // output from multiplexers
    reg [31:0] data;                        // data to be written to a register
    reg [4:0] select_reg_A, select_reg_B;    // select register on multiplexer A and B
    reg [4:0] write_reg;                     // select which register to write data 
    reg Ld;                                 // load to Decoder
    reg Clk;                                 // clock for registers

    RegisterFile regF (data_mux_A, data_mux_B,  data, select_reg_A, select_reg_B, write_reg, Ld, Clk);

    initial #135 $finish;
    initial begin
        Clk = 1'b0;
        Ld = 1'b1;
        forever #1 Clk = ~Clk;
    end
    initial begin
        write_reg = 5'b00000;   // selection of register to write, from decoder
        repeat (64) #2 write_reg = write_reg + 5'b00001;  //changes register where to store data
    end
    initial begin
        data = 32'd0;  // data to be stored in registers
        repeat (64) #2 data = data + 32'd1;
    end
    initial fork
        #129 $display ("|C|          |Data|      |A|          |out A|");
        #129 write_reg = 5'd0; 
        #129 data = 32'd15;
        #129 select_reg_A = 5'd0;

        join
    initial begin
        select_reg_A = 5'b00000; // select mux A
        repeat (64) #2 select_reg_A = select_reg_A + 5'b00001;
    end
     initial begin
        select_reg_B = 5'b00000;    //select mux B
        repeat (64) #2 select_reg_B = select_reg_B + 5'b00001;
    end

    initial begin 
	// write to reg = señal (decoder) que indica a que registro se va a guardar la data
	// data = la data que se va a guardar en un registro
	// select_reg_mux_A / select_reg_mux_B = señal indica que registro se selecciona del multiplexer A o B, respectivamente
	// out_mux_A / out_mux_B = output del multiplexer correspondiente

        $display (" C         data    select_reg_mux_A     A    select_reg_mux_B        B     Clk");  
        $monitor (" %d    %d         %d     %d      %d         %d          %d    ",  write_reg, data, select_reg_A, data_mux_A, select_reg_B, data_mux_B, Clk);      
    end 

endmodule