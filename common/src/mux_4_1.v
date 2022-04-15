`timescale 1ns / 1ps
/// @file mux_4_1.v
///
/// @note Copyright (c) 2022 AMSUC - Dominik Kala i Dawid Jaraczewski

/// Multiplekser 4 na 1
///
/// @tparam BITS_NUM - Liczba bitow danych.
///
/// @param [IN] A - Dane wejściowe 1.
/// @param [IN] B - Dane wejściowe 2.
/// @param [IN] C - Dane wejściowe 3.
/// @param [IN] D - Dane wejściowe 4.
/// @param [IN] SEL - Wybór wejścia.
/// @param [OUT] Q - Dane wyjściowe

module MUX_4_1 #(
  parameter BITS_NUM = 1
) (
  input [BITS_NUM-1:0] A,
  input [BITS_NUM-1:0] B,
  input [BITS_NUM-1:0] C,
  input [BITS_NUM-1:0] D,
  input [1:0] SEL,
  output [BITS_NUM-1:0] Q
);

  assign Q = SEL[1] ? (SEL[0] ? D : C) : (SEL[0] ? B : A); 

endmodule
