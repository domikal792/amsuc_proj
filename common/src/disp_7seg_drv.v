`timescale 1ns / 1ps
/// @file disp_7seg_drv.v
///
/// @note Copyright (c) 2022 AMSUC - Countdown Timer - Dominik Kala i Dawid Jaraczewski

/// Sterownik wyswietlacza.
///
/// @param [IN] CLK - Zegar.
/// @param [IN] CLR - Aysnchroniczne wejscie resetujace stan modulu.
/// @param [IN] CE - Aktywacja zegara.
/// @param [IN] E - Wektor aktywacji poszczegolnych wyswietlaczy.
/// @param [IN] DP - Wektor bitow sterujacych kropkami wyswietlaczy.
/// @param [IN] IN - Wektor zawieracjacy dane hex do wyswietlania na poszczegolnym wyswietlaczu, 4bity na pojedyncza cyfre.
/// @param [OUT] EO - Wektor aktywujacy poszczegolna cyfre wyswietlacza.
/// @param [OUT] Q - Dane do wyswietlenia na wybranej cyfrze wyswietlacza.
module DISP_7SEG_DRV(
  input CLK, 
  input CLR, 
  input CE, 
  input [7:0] E,
  input [7:0] DP,
  input [31:0] IN, 
  output [7:0] EO,
  output [7:0] Q
);
  wire [7:0] zero_hot_q;
  reg [3:0] data;
  reg a_dp;

  // Krazace zero uzywane do aktywacji kolejnych cyfr.
  RING_CNT #(
    .BITS_NUM(8),
    .ACT_STATE(0)
  ) zero_hot (
    .CLK(CLK),
    .CLR(CLR),
    .CE(CE),
    .Q(zero_hot_q)
  );

  // Konwerter liczb zapisanych w hex na 7 seg.
  HEX_TO_7SEG hex_to_7seg(
    .IN(data),
    .DP(a_dp),
    .Q(Q)
  );

  // Synchroniczny multiplekser.
  always @(posedge CLK) begin
    case (zero_hot_q)
      8'b11111110 : {a_dp, data} = {~DP[0], IN[3:0]};
      8'b11111101 : {a_dp, data} = {~DP[1], IN[7:4]};
      8'b11111011 : {a_dp, data} = {~DP[2], IN[11:8]};
      8'b11110111 : {a_dp, data} = {~DP[3], IN[15:12]};
      8'b11101111 : {a_dp, data} = {~DP[4], IN[19:16]};
      8'b11011111 : {a_dp, data} = {~DP[5], IN[23:20]};
      8'b10111111 : {a_dp, data} = {~DP[6], IN[27:24]};
      8'b01111111 : {a_dp, data} = {~DP[7], IN[31:28]};
      default: {a_dp, data} = {1'b0, 4'b1111};
    endcase
  end

  // Wypracowanie sygnalu aktuwujacego poszczegolna cyfre wyswietlacza.
  assign EO = ~(E & ~zero_hot_q);

endmodule
