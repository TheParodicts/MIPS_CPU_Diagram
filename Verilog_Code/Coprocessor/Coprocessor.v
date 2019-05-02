module Coprocessor (
    output[31:0] address,   // Exception handler address
    input reset,    // Reset
    input MI,       // Maskable Interrupt
    input HI,       // Hardware Interrupt
    input trap,     // Trap encountered
    input clk,
    input [31:0] PC // Current PC
);

reg [31:0] Status, Cause, EPC;

/*

Status
31      -   CP0 access
19      -   Non-Maskable Interrupt Exception
15-10   -   IM7-IM2 Hardware Interrupt Enables
9-8     -   IM1-IM0 Software Interrupt Enables
1       -   Exception Level
0       -   Interrupt Enable


Cause
31      -   Branch Delay
15-10   -   IP9-IP2 Interrupt Queue
9-8     -   IP1-IP0 Request Software Interrupt
6-2     -   Exception Code


Exception Program Counter
31-0    -   Address where exception came from

*/

initial begin
    Status  = 32'b0;
    Cause   = 32'b0;
    EPC     = 32'b0;
    address = 32'b0;
end


always @(posedge clk)
    begin
        if (HI == 1'b1)     // Hardware Interrupt
            Status[19]  = 1'b1;

        if (Status[19] == 1'b1) begin // Non-maskable interrupt
            Status[1]   =   1'b1;
            EPC         =   PC;
            address     =   32'd384;
            Cause[6:2]  =   5'b0;
        end
        else begin        
            if (Cause[10] == 1'b1) begin // Queue'd exception
                Cause[10] = 1'b0;
                if (Status[10] == 1'b1) begin
                    Status[1] = 1'b1;
                    EPC = PC;
                    address = 32'd400;
                    Cause[6:2] = 5'b10000;
                end else begin
                    address = 4 + PC;
                end
            end else begin
                Status[1] = 1'b1;
                if (/* Illegal Instruction */) begin
                    EPC = PC;
                    address = 416;
                    Cause[6:2] = 5'b01011;
                end else if (trap == 1'b1) begin
                    EPC = PC;
                    address = 432;
                    Cause[6:2] = 5'b01101;
                end else begin
                    EPC = PC;
                    PC = 432;
                    Cause[6:2] = 5'b01100;
                end
            end
        end
        if (reset = 1'b1) begin // Hard Reset
            Status  = 32'b0;
            Cause   = 32'b0;
            EPC     = 32'b0;
            address = 32'b0;
        end
    end
endmodule
