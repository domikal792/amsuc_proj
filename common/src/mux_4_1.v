`timescale 1ns / 1ps
/// @file mux_4_1.v
///
/// @note Copyright (c) 2022 AMSUC - Dominik Kala i Dawid Jaraczewski

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
