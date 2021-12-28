`timescale 1ns / 1ps
/// @file disp_7seg_drv.v
///
/// @note Copyright (c) 2021 AMSUC - Countdown Timer - Kala, Jaraczewski

module DISP_7SEG_DRV(
  input CLK, 
  input CLR, 
  input CE, 
  input [7:0] E,
  input [7:0] DP,
  input [3:0] IN[7:0], 
  output [7:0] EO,
  output [7:0] Q
);
  reg [7:0] zero_hot_q;
  reg [3:0] data;
  reg a_dp;

  RING_CNT #(
    .BITS_NUM(8),
    .ACT_STATE(0)
  ) zero_hot (
    .CLK(CLK),
    .CLR(CLR),
    .CE(CE),
    .Q(zero_hot_q)
  );

  HEX_TO_7SEG hex_to_7seg(
    .IN(data),
    .DP(a_dp),
    .Q(Q)
  );

  always @(posedge CLK) begin
    case (E)
      8'b11111110 : {a_dp, data} = {DP[0], IN[0]};
      8'b11111101 : {a_dp, data} = {DP[1], IN[1]};
      8'b11111011 : {a_dp, data} = {DP[2], IN[2]};
      8'b11110111 : {a_dp, data} = {DP[3], IN[3]};
      8'b11101111 : {a_dp, data} = {DP[4], IN[4]};
      8'b11011111 : {a_dp, data} = {DP[5], IN[5]};
      8'b10111111 : {a_dp, data} = {DP[6], IN[6]};
      8'b01111111 : {a_dp, data} = {DP[7], IN[7]};
      default: {a_dp, data} = {1'b0, 4'b1111};
    endcase
  end

  assign EO = E & zero_hot_q;

endmodule
