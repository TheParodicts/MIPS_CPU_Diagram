
// Copied from presentation, modified by Brian Rodriguez Badillo.
//RAM 512x8bit

module ram512x8 (output reg [31:0] DataOut, output reg MOC, output reg DMOC=1'b0, 
                    input ReadWrite, MOV, input [8:0] Address, 
                    input [31:0] DataIn, input [5:0] OpCode); 
 /*=============================================================================
 DESCRIPTION
 ===============================================================================
 DataOut= outputs 32bits
 DataIn= inputs 32bits
 Address=7bits of address
 ReadWrite= 1=read, 0=write
 OpCode= defines how the RAM will load/store data.
 MOV=memory operation valid (says if readwrite can happen)
                            1=proceed, 0=no op
 MOC=Memory operation complete: tells CPU the memory op is done.
                             1=complete, 0=not complete.
 DMOC=Double Mem Op Complete: signals when the first 32 bits have been passed
                              and when the next 32 bits are ready to be read.
                             1=second bytes ready, 0=first bytes ready
 ===============================================================================
 */

// INTERNAL MEMORY:
// array with 512 cells of 8 bits.
 reg [7:0] Mem[0:511];

 //8-bits of 1's or 0's for sign extension.
 reg [7:0] ones = 8'b11111111;
 reg [7:0] zeroes = 8'b00000000;
 reg [8:0] dwAddress = 7'b1111000;
 reg [8:0] wAddress = 7'b1111100;
 reg [8:0] hwAddress = 7'b1111110;

 /*============================================================================
 RAM LOGIC
 ==============================================================================
 */
 always @ (posedge MOV) // Could cause issues if two sequential instr. come and MOV never goes to low.
    begin 
    MOC=1'b0;//Memory Operation Not Completed
    /*_________________________________________________________________
        READ OPERATIONS
        ===================================================================*/
        if (ReadWrite) //If you have to read.
            case (OpCode) //Check OpCode
                6'b110101: // 64bits (doubleword)
                begin
                    if(!DMOC)//If it's the first most sig 32 bits.
                        begin
                            DataOut[31:24] = Mem[Address];
                            DataOut[23:16] = Mem[Address+1];
                            DataOut[15:8] = Mem[Address+2];
                            DataOut[7:0] = Mem[Address+3];
                            DMOC=1'b1;
                        end
                    else// It's the second 32 bits.
                        begin
                            DataOut[31:24] = Mem[Address+4];
                            DataOut[23:16] = Mem[Address+5];
                            DataOut[15:8] = Mem[Address+6];
                            DataOut[7:0] = Mem[Address+7];
                            DMOC=1'b0;
                        end
                end

                //32bits (word)
                6'b100011:  
                begin
                    DataOut[31:24] = Mem[Address];
                    DataOut[23:16] = Mem[Address+1];
                    DataOut[15:8] = Mem[Address+2];
                    DataOut[7:0] = Mem[Address+3]; 
                end

                    //16bits (halfword unsigned)
                6'b100101: DataOut = {Mem[Address],Mem[Address+1]}; 

                //16 bits (signed halfword)
                6'b100001:
                    begin
                        if(Mem[Address][7])
                            begin //If negative
                                DataOut[31:24] = ones;
                                DataOut[23:16] = ones;
                                DataOut[15:8] = Mem[Address];
                                DataOut[7:0] = Mem[Address+1];
                            end 
                        else
                            begin
                                DataOut[31:24] = zeroes;
                                DataOut[23:16] = zeroes;
                                DataOut[15:8] = Mem[Address];
                                DataOut[7:0] = Mem[Address+1];
                            end
                    end

                //8bits (byte unsigned)
                6'b100100: DataOut = Mem[Address]; 

                //8bits (signed byte)
                6'b100000:
                    begin
                        if(Mem[Address][7])
                            begin //If negative
                                DataOut[31:24] = ones;
                                DataOut[23:16] = ones;
                                DataOut[15:8] = ones;
                                DataOut[7:0] = Mem[Address];
                            end 
                        else
                            begin
                                DataOut[31:24] = zeroes;
                                DataOut[23:16] = zeroes;
                                DataOut[15:8] = zeroes;
                                DataOut[7:0] = Mem[Address];
                            end
                    end
            endcase
        /*______________________________________________________________
            WRITE OPERATIONS
            ==============================================================*/
        else //Write
            case (OpCode)
                // 64bits (doubleword) ADDRESS MUST BE MULTIPLE OF 8.
                6'b111101: 
                    if(!DMOC) //If it's the first most sig 32 bits.
                        begin
                            Mem[(Address & dwAddress)] = DataIn[31:24];
                            Mem[(Address & dwAddress)+1]= DataIn[23:16]; 
                            Mem[(Address & dwAddress)+2] = DataIn[15:8];
                            Mem[(Address & dwAddress)+3]= DataIn[7:0]; 
                            DMOC=1'b1;
                        end
                    else // It's the second 32 bits.
                        begin
                            Mem[(Address & dwAddress)+4] = DataIn[31:24];
                            Mem[(Address & dwAddress)+5]= DataIn[23:16]; 
                            Mem[(Address & dwAddress)+6] = DataIn[15:8];
                            Mem[(Address & dwAddress)+7]= DataIn[7:0]; 
                            DMOC=1'b0;
                        end
                        
                //32bits (word) ADDRESS MUST BE MULTIPLE OF 4
                6'b101011:
                begin
                    Mem[(Address & wAddress)] = DataIn[31:24];
                    Mem[(Address & wAddress)+1]= DataIn[23:16]; 
                    Mem[(Address & wAddress)+2] = DataIn[15:8];
                    Mem[(Address & wAddress)+3]= DataIn[7:0]; 
                end

                //16bits (halfword) ADDRESS MUST BE EVEN.
                6'b101001:
                begin
                    Mem[(Address & hwAddress)] = DataIn[15:8];
                    Mem[(Address & hwAddress)+1]= DataIn[7:0]; 
                end

                //8bits (byte)
                6'b101000: Mem[Address]= DataIn[7:0]; 
            endcase
    #1 MOC =1'b1; //Set MOC as done.
end
endmodule