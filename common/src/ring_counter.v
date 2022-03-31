`timescale 1ns / 1ps
/// @file ring_counter.v
///
/// @note Copyright (c) 2022 AMSUC - Countdown Timer - Dominik Kala i Dawid Jaraczewski

/// Licznik kołowy - krazaca jedynka badz krazace zero.
///
/// @tparam BITS_NUM - Liczba bitow licznika.
/// @tparam ACT_STATE - Aktywny stan, 0 lub 1.
///
/// @param [IN] CLK - Zegar.
/// @param [IN] CLR - Aysnchroniczne wejscie resetujace stan modulu.
/// @param [IN] CE - Aktywacja zegara.
/// @param [OUT] Q - Rownolegle wyjscie licznika.
module RING_CNT #(
  parameter BITS_NUM = 8,
  parameter ACT_STATE = 1'b1
) (
  input CLK,
  input CLR,
  input CE,
  output reg [BITS_NUM-1:0] Q
);    
  always @(posedge CLK or posedge CLR) begin
    if (CLR)
      Q <= {BITS_NUM{~ACT_STATE}};
    else begin
      if (CE) begin
        if (ACT_STATE)
          Q <= {Q[BITS_NUM-2:0], ~|Q[BITS_NUM-2:0]}; // Krazaca jedynka z samokorekcja.
        else
          Q <= {Q[BITS_NUM-2:0], ~&Q[BITS_NUM-2:0]}; // Krazace zero z samokorekcja.
      end
    end
  end
endmodule
