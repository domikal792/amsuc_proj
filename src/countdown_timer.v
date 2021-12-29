`timescale 1ns / 1ps
/// @file countdown_timer.v
///
/// @note Copyright (c) 2021 AMSUC - Countdown Timer - Kala, Jaraczewski

module CNTDOWN_TIMER #(
  parameter MAX_VAL = 100*60,
  parameter BITS_NUM = $clog2(MAX_VAL)
) (
  input CLK,
  input CLR,
  input CE,
  input RUN_CE,
  input BTN_RUN,
  input BTN_MIN_INC,
  input BTN_MIN_DEC,
  input BTN_SEC_INC,
  input BTN_SEC_DEC,
  output reg [BITS_NUM-1:0] Q,
  output reg IS_RUNNING
);
  always @(posedge CLK or posedge CLR) begin
    if (CLR) begin
      Q <= {BITS_NUM{1'b0}};
      IS_RUNNING <= 1'b0;
    end
    else begin
      if (RUN_CE) begin
        if (IS_RUNNING) begin
          if (|Q)
            Q <= Q - 1;
          else
            IS_RUNNING <= 1'b0;
        end
      end
        
      if (CE) begin
        if (IS_RUNNING) begin
          // Timer is running, we can just stop it.
          if (BTN_RUN)
            IS_RUNNING <= 1'b0;
        end
        else begin
          // Modify value or start timer.
          if (BTN_RUN)
            IS_RUNNING <= 1'b1;

          if (BTN_MIN_INC)
            Q <= (Q + 6'd60) % MAX_VAL;

          if (BTN_MIN_DEC) begin
              if (Q >= 6'd60)
                Q <= (Q - 6'd60);
              else
                Q <= (MAX_VAL - 6'd60 + Q);
          end

          if (BTN_SEC_INC)
            Q <= (Q + 1'd1) % MAX_VAL;

          if (BTN_SEC_DEC) begin
              if (|Q)
                Q <= (Q - 1'd1);
              else
                Q <= MAX_VAL - 1'd1;
          end
        end
      end
    end
  end
endmodule
