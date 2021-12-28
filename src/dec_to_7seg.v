`timescale 1ns / 1ps
/// @file hex_to_7seg.v
///
/// @note Copyright (c) 2021 AMSUC - Countdown Timer - Kala, Jaraczewski

module HEX_TO_7SEG(
  input [3:0] IN, 
  input DP, 
  output reg [7:0] Q
);
  always @(IN) begin
    case(IN)
      4'h0: Q = {DP, 7'b1000000};
      4'h1: Q = {DP, 7'b1111001};
      4'h2: Q = {DP, 7'b0100100};
      4'h3: Q = {DP, 7'b0110000};
      4'h4: Q = {DP, 7'b0011001};
      4'h5: Q = {DP, 7'b0010010};
      4'h6: Q = {DP, 7'b0000010};
      4'h7: Q = {DP, 7'b1111000};
      4'h8: Q = {DP, 7'b0000000};
      4'h9: Q = {DP, 7'b0010000};
      4'hA: Q = {DP, 7'b0001000};
      4'hB: Q = {DP, 7'b0000011};
      4'hC: Q = {DP, 7'b1000110};
      4'hD: Q = {DP, 7'b0100001};
      4'hE: Q = {DP, 7'b0000110};
      4'hF: Q = {DP, 7'b0001110};
      default: Q = 8'b01111111;
    endcase 
  end
endmodule
