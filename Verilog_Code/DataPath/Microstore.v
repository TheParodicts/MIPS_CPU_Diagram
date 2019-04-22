module Microstore(output reg [43:0] currentStateSignals, output reg[6:0] activeState, 
                    input reset, input [6:0] currentState);
always @ (currentState, reset)
    if (reset) begin
        currentStateSignals = 44'b00100110000000000000000000001000000000100001;
        activeState = 7'd0; // For testing purposes.
        end
    else
        begin
            activeState = currentState; // For testing purposes.
            case(currentState)
                7'd0: currentStateSignals = 44'b00100110000000000000000000001000000000100001;
                7'd1: currentStateSignals = 44'b01100000000100000000000000000000000000100011;
                7'd2: currentStateSignals = 44'b00000000000010001000000000000000000000100011;
                7'd3: currentStateSignals = 44'b00000000000010001000000000000000000000100011;
                7'd4: currentStateSignals = 44'b10000000000001100100011000000000001000100111;
                7'd5: currentStateSignals = 44'b10000000000000000000000000000000000000100000;
                7'd6: currentStateSignals = 44'b00011010000000000000000000000000000000100001;
                7'd7: currentStateSignals = 44'b00001110100000010000000000000000000000100011;
                7'd8: currentStateSignals = 44'b00001100001000001000000000000000000000100011;
                7'd9: currentStateSignals = 44'b00000000010000100000000000000000000000100011;
                7'd10: currentStateSignals = 44'b00000000010000100000000000000000010010100101;
                7'd11: currentStateSignals = 44'b00001010000000000000000000111100000000101110;
                7'd12: currentStateSignals = 44'b00100100000000000000000001000100000100100010;
                // Default state is Reset (0) state.
                default: begin
                    currentStateSignals = 44'b00100110000000000000000000001000000000100001;
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
