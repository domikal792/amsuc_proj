`timescale 1ns / 1ps
/// @file up_counter.v
///
/// @note Copyright (c) 2021 ArmCpp - Kala, Jaraczewski

module UP_CNT #(
  parameter BITS_NUM = 8,
  parameter MODULO = 10
) (
  input CLK,
  input CLR,
  input CE,
  output reg [BITS_NUM-1:0] Q,
  output CEO
);
  always @(posedge CLK or posedge CLR) begin
    if (CLR)
      Q <= {BITS_NUM{1'b0}};
    else begin
      if (CE) begin
        if (Q != MODULO-1)
          Q <= Q + 1;
        else
          Q <= {BITS_NUM{1'b0}};
      end
    end
  end

  assign CEO = CE & (Q == MODULO-1);

endmodule
