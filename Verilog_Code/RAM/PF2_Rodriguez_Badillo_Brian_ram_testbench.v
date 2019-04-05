 `include "PF1_Rodriguez_Badillo_Brian_ram.v"
 
module RAM_Access; 
    integer fi, fo, code, i; 
    reg [31:0] data; 
    reg MOV, ReadWrite; 
    reg [31:0] DataIn; 
    reg [8:0] Address; 
    reg [5:0] OpCode;
    wire [31:0] DataOut;
    wire MOC, DMOC;
    ram512x8 ram1 (DataOut, MOC, DMOC, ReadWrite, MOV,
                        Address, DataIn, OpCode);   

//Load RAM instantaneously by byte.
    initial begin 
        fi = $fopen("PF1_Rodriguez_Badillo_Brian_ramdata.txt","r"); 
        Address = 7'b0000000;
        OpCode = 6'b101000; 
        while (!$feof(fi)) 
            begin code = $fscanf(fi, "%b", data); 
            ram1.Mem[Address] = data; 
            Address = Address + 1; 
        end 
        $fclose(fi);
     end

//Read RAM after it's been loaded.
    initial begin 
        fo = $fopen("memcontent.txt", "w"); 
        ReadWrite = 1'b1;
        Address = #1 7'b0000000; 
        MOV =1'b0;  

        $fdisplay(fo, "RAM Memory Content Test Module Output\n============================================================================================================");
        //Read by byte unsigned
        $fdisplay(fo, "Reading unsigned bytes\n______________________");
        OpCode = #1 6'b100100;
        repeat (4) begin 
            #5  MOV = 1'b1; 
            #5  MOV = 1'b0; 
            Address = Address + 1; 
        end 

        //Read by halfword unsigned
        $fdisplay(fo, "\nReading unsigned halfwords\n________________________________");
        OpCode = #1 6'b100101;
        repeat (2) begin 
            #5  MOV = 1'b1; 
            #5  MOV = 1'b0; 
            Address = Address + 2; 
        end 

         //Read by word 
        $fdisplay(fo, "\nReading words\n__________________");
        OpCode = #1 6'b100011;
        repeat (1) begin 
            #5  MOV = 1'b1; 
            #5  MOV = 1'b0; 
            Address = Address + 4; 
        end 

         //Read by doubleword 
        $fdisplay(fo, "\nReading double words\n________________________________");
        OpCode = #1 6'b110101;
        repeat (2) begin 
            #5  MOV = 1'b1; 
            #5  MOV = 1'b0;  
        end 
         Address = Address + 8;
       
//Write data to the RAM        
       //Write a byte
       begin
        $fdisplay(fo, "\nWriting a byte\n_______________________");
        #1 ReadWrite = 1'b0;
        #1 DataIn=8'b11111111;
        #1 OpCode=6'b101000;
        #5  MOV = 1'b1; 
        #5  MOV = 1'b0; 
        #1 ReadWrite=1'b1;
        #1 OpCode=6'b100100;
        #5  MOV = 1'b1; 
        #5  MOV = 1'b0;
        Address=Address+1;
        end
    
    
        Address=Address+1;//Address is now 22 (even)
        //Write a halfword
       begin
        $fdisplay(fo, "\nWriting a halfword\n_______________________");
        #1 ReadWrite = 1'b0;
        #1 DataIn=16'b1010101010101010;
        #1 OpCode=6'b101001;
        #5  MOV = 1'b1; 
        #5  MOV = 1'b0; 
        #1 ReadWrite=1'b1;
        #1 OpCode=6'b100101;
        #5  MOV = 1'b1; 
        #5  MOV = 1'b0;
        Address=Address+2;
        end
//Currently, address is 24
        //Write a word
       begin
       
        $fdisplay(fo, "\nWriting a word\n_______________________");
        #1 ReadWrite = 1'b0;
        #1 DataIn=32'b11101110111011101110111011101110;
        #1 OpCode=6'b101011;
        #5  MOV = 1'b1; 
        #5  MOV = 1'b0; 
        #1 ReadWrite=1'b1;
        #1 OpCode=6'b100011;
        #5  MOV = 1'b1; 
        #5  MOV = 1'b0;
        Address=Address+4;
        end

//Currently, Address is 28
        //Write a doubleword
       begin
        Address=Address+4; // Now, Address is 32 (doubleWord aligned)
        $fdisplay(fo, "\nWriting a double word\n_______________________");
        #1 ReadWrite = 1'b0;
        #1 DataIn=32'b11001100110011001100110011001100;
        #1 OpCode= 6'b111101;
        #5  MOV = 1'b1; 
        #5  MOV = 1'b0; 
        #1 DataIn=32'b10001000100010001000100010001000;
        #5  MOV = 1'b1; 
        #5  MOV = 1'b0; 
        #1 ReadWrite=1'b1;
        #1 OpCode=6'b110101;
        #5  MOV = 1'b1; 
        #5  MOV = 1'b0;
        #5  MOV = 1'b1; 
        #5  MOV = 1'b0;
        Address=Address+8;
        end

         //Read by byte signed
        begin
         $fdisplay(fo, "\nReading a signed byte (Mem[1]=10100110 )\n_______________________");
            OpCode = #1 6'b100000;
            Address = 7'b0000001; //Mem[1]=10100110 
            #5  MOV = 1'b1; 
            #5  MOV = 1'b0; 
        end

         //Read by halfword signed
        begin
         $fdisplay(fo, "\nReading a signed halfword (Mem[1]=1010011000101000)\n_______________________");
            OpCode = #1 6'b100001;
            #5  MOV = 1'b1; 
            #5  MOV = 1'b0; 
        end

     $finish; 
    end 

    
    always @ (MOV, MOC) 
    begin
        #1; 
        $fdisplay(fo,"data en %h = %h  %d |ReadWrite= %b|MOV= %b|MOC= %b|DMOC= %b", Address, DataOut, $time,ReadWrite, MOV, MOC, DMOC); 
    end 
endmodule