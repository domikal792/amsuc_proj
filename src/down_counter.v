`timescale 1ns / 1ps
/// @file down_counter.v
///
/// @note Copyright (c) 2021 AMSUC - Countdown Timer - Kala, Jaraczewski

module DOWN_CNT #(
  parameter BITS_NUM = 8, // TODO: Change it to $clog2(MODULO)
  parameter MODULO = 10,
  parameter INIT_VAL = MODULO - 1
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
        if (Q != 0)
          Q <= Q - 1;
        else
          Q <= MODULO - 1;
      end
    end
  end

  assign CEO = CE & (Q == 0);

endmodule
