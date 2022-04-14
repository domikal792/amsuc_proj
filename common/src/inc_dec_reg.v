`timescale 1ns / 1ps
/// @file inc_dec_reg.v
///
/// @note Copyright (c) 2022 AMSUC - Dominik Kala i Dawid Jaraczewski

module INC_DEC_REG #(
  parameter BITS_NUM = 8
) (
  input CLK,
  input CLR,
  input CE,
  input INC_EN,
  input DEC_EN,
  output reg [BITS_NUM-1:0] Q
);
  always @(posedge CLK or posedge CLR) begin
    if (CLR)
      Q <= {BITS_NUM{1'b0}};
    else begin
      if (CE) begin
        if (INC_EN && ~DEC_EN)
          Q <= Q + 1;
        else if (~INC_EN && DEC_EN)
          Q <= Q - 1;
        else
          Q <= Q;
      end
    end
  end
endmodule
