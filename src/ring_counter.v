`timescale 1ns / 1ps
/// @file ring_counter.v
///
/// @note Copyright (c) 2021 AMSUC - Countdown Timer - Kala, Jaraczewski

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
          Q <= {Q[BITS_NUM-2:0], ~|Q[BITS_NUM-2:0]};
        else
          Q <= {Q[BITS_NUM-2:0], ~&Q[BITS_NUM-2:0]};
      end
    end
  end
endmodule
