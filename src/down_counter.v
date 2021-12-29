`timescale 1ns / 1ps
/// @file down_counter.v
///
/// @note Copyright (c) 2021 AMSUC - Countdown Timer - Kala, Jaraczewski

module DOWN_CNT #(
  parameter MODULO = 10,
  parameter INIT_VAL = MODULO - 1,
  parameter BITS_NUM = $clog2(MODULO < INIT_VAL ? INIT_VAL : MODULO)
) (
  input CLK,
  input CLR,
  input CE,
  output reg [BITS_NUM-1:0] Q,
  output CEO
);
  always @(posedge CLK or posedge CLR) begin
    if (CLR)
      Q <= INIT_VAL;
    else begin
      if (CE) begin
        if ((|Q))
          Q <= Q - 1;
        else
          Q <= MODULO - 1;
      end
    end
  end

  assign CEO = CE & (~|Q);

endmodule
