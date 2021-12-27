`timescale 1ns / 1ps
/// @file dec_to_7seg.v
///
/// @note Copyright (c) 2021 AMSUC - Countdown Timer - Kala, Jaraczewski

module DEC_TO_7SEG(
    input [3:0] IN, 
    input DP, 
    output reg [7:0] OUT
);
always @(IN) begin
    case(IN)
        4'h0: OUT = {DP, 7'b1000000};
        4'h1: OUT = {DP, 7'b1111001};
        4'h2: OUT = {DP, 7'b0100100};
        4'h3: OUT = {DP, 7'b0110000};
        4'h4: OUT = {DP, 7'b0011001};
        4'h5: OUT = {DP, 7'b0010010};
        4'h6: OUT = {DP, 7'b0000010};
        4'h7: OUT = {DP, 7'b1111000};
        4'h8: OUT = {DP, 7'b0000000};
        4'h9: OUT = {DP, 7'b0010000};
        default: OUT = 8'b11000000;
    endcase 
end

endmodule
