`timescale 1ns / 1ps
/// @file demux_1_4.v
///
/// @note Copyright (c) 2022 AMSUC - Dominik Kala i Dawid Jaraczewski

module DEMUX_1_4 #(
  parameter BITS_NUM = 1
) (
  input [BITS_NUM-1:0] X,
  input [1:0] SEL,
  output reg [BITS_NUM-1:0] Y0,
  output reg [BITS_NUM-1:0] Y1,
  output reg [BITS_NUM-1:0] Y2,
  output reg [BITS_NUM-1:0] Y3
);

  always @(X or SEL)
    case (SEL)
      2'b00   : {Y0, Y1, Y2, Y3} = {X, {3*BITS_NUM{1'b0}}};
      2'b01   : {Y0, Y1, Y2, Y3} = {{BITS_NUM{1'b0}}, X, {2*BITS_NUM{1'b0}}};
      2'b10   : {Y0, Y1, Y2, Y3} = {{2*BITS_NUM{1'b0}}, X, {BITS_NUM{1'b0}}};
      2'b11   : {Y0, Y1, Y2, Y3} = {{3*BITS_NUM{1'b0}}, X};
      default : {Y0, Y1, Y2, Y3} = {4*BITS_NUM{1'b0}};
    endcase
endmodule
