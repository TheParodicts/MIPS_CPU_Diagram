module Microstore(output reg [50:0] currentStateSignals, output reg[6:0] activeState, 
                    input reset, input [6:0] currentState);
always @ (currentState, reset)
    if (reset) begin
        currentStateSignals = 51'b001000001100000000000000000000000001000000000100001;
        activeState = 7'd0; // For testing purposes.
        end
    else
        begin
            activeState = currentState; // For testing purposes.
            case(currentState)
                7'd0: currentStateSignals = 51'b001000001100000000000000000000000001000000000100001;
                7'd1: currentStateSignals = 51'b011000000000000001000000000000000000000000000100011;
                7'd2: currentStateSignals = 51'b000000000000000000100001100011000000000000000100011;
                7'd3: currentStateSignals = 51'b000000000000000000001100100011000000000000000100011;
                7'd4: currentStateSignals = 51'b100000000000000000001100100011000000000001000100111;
                7'd5: currentStateSignals = 51'b000000000000000000000000000000000000000000000100000;
                7'd6: currentStateSignals = 51'b000100010100000100000000000000000000000000000100001;
                7'd7: currentStateSignals = 51'b000000010100101000000010000000000000000000000100011;
                7'd8: currentStateSignals = 51'b000000011000010100000001000000000000000000000100011;
                7'd9: currentStateSignals = 51'b000000000000010000000100000000000000000000000100011;
                7'd10: currentStateSignals = 51'b000000000000010000000100000000000000000010010100101;
                7'd11: currentStateSignals = 51'b000000010100000100000000000000000111100000000101110;
                7'd12: currentStateSignals = 51'b011000001000000000000000000000001000000000100100010;
                7'd13: currentStateSignals = 51'b000000011000010100000001000000000000000000000100011;
                7'd14: currentStateSignals = 51'b000000000000010000001100000000000000000000000100011;
                7'd15: currentStateSignals = 51'b000000000000010000001110000000000000000011110100111;
                7'd16: currentStateSignals = 51'b000100010001001000000000000000000000000000000100001;
                7'd17: currentStateSignals = 51'b000100010100000100000000000000000000100000000100001;
                7'd18: currentStateSignals = 51'b000100011001000100000000000000000000000000000100001;
                7'd19: currentStateSignals = 51'b000100010100000100000000000000000111000000000100001;
                7'd20: currentStateSignals = 51'b000100011001000100000000000000000111000000000100001;
                7'd21: currentStateSignals = 51'b000100010000000100000000000000000110100000000100001;
                7'd22: currentStateSignals = 51'b000100010000000100000000000000000110000000000100001;
                7'd23: currentStateSignals = 51'b000100010100000100000000000000000100000000000100001;
                7'd24: currentStateSignals = 51'b000100011001000100000000000000000100000000000100001;
                7'd25: currentStateSignals = 51'b000100010100000100000000000000000100100000000100001;
                7'd26: currentStateSignals = 51'b000100011001000100000000000000000100100000000100001;
                7'd27: currentStateSignals = 51'b000100010100000100000000000000000101000000000100001;
                7'd28: currentStateSignals = 51'b000100011001000100000000000000000101000000000100001;
                7'd29: currentStateSignals = 51'b000100010100000100000000000000000101100000000100001;
                7'd30: currentStateSignals = 51'b000100001001000000000000000000000001100000000100001;
                7'd31: currentStateSignals = 51'b000100011001000000000000000000011010000000000100001;
                7'd32: currentStateSignals = 51'b000100011001000000000000000000011011100000000100001;
                7'd33: currentStateSignals = 51'b000100011001000000000000000000011010100000000100001;
                7'd34: currentStateSignals = 51'b000000011100000000000000000000000111101001000101101;
                7'd35: currentStateSignals = 51'b000000011100000000000000000000000111101001001101101;
                7'd36: currentStateSignals = 51'b000100011100000100000000000000000000000000000100001;
                7'd37: currentStateSignals = 51'b000000011000000100000000000000000111100011001101111;
                7'd38: currentStateSignals = 51'b000000011000000100000000000000000111000011000101101;
                7'd39: currentStateSignals = 51'b000000011000000100000000000000000111100000001101110;
                7'd40: currentStateSignals = 51'b000000011000000100000000000000000111000011000101101;
                7'd41: currentStateSignals = 51'b000000010100000100000000000000000111100011000101101;
                7'd42: currentStateSignals = 51'b000000011000000100000000000000000111000011001101111;
                7'd43: currentStateSignals = 51'b000000011000000100000000000000000111100011001101101;
                7'd44: currentStateSignals = 51'b011000011100000100000000000000000000000000100100010;
                7'd45: currentStateSignals = 51'b000100111100000000000000000000000000000000000100001;
                7'd46: currentStateSignals = 51'b000100101100000000000000000000000000000000000100001;
                7'd47: currentStateSignals = 51'b000010011100000100000000000000000000000000000100001;
                7'd48: currentStateSignals = 51'b000001011100000100000000000000000000000000000100001;
                7'd49: currentStateSignals = 51'b000011010100000100010000000000000001000000000100001;


                // Default state is 0.
                default: begin
                    currentStateSignals = 51'b001000001100000000000000000000000001000000000100001;
                    activeState = 7'd0; // For testing purposes.
                end
            endcase
        end
endmodule

// module microstore_testbench;
//     reg clk, reset;
//     reg [6:0] state;
//     wire[43:0] StateSignals;

// Outdated; need to update for future testing.
//     Microstore Mstore(state, 1'b0, StateSignals);

//     initial begin
//     clk = 1'b0;
//         repeat(5)
//             begin
//                 #5 clk = 1'b1;
//                 #5 clk = 1'b0;
//             end
//     end

//     initial begin
//         state= 7'd0;
//         #10 state = 7'b0000001;
//         #10 state = 7'd3;
//     end

//     always @ (posedge clk)
//         begin
//             $monitor("State: %d, SS: %b Clk: %b, Time: %d", state, StateSignals, clk, $time);
//         end
// endmodule
