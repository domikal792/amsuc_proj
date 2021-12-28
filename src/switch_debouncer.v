`timescale 1ns / 1ps
/// @file switch_debouncer.v
///
/// @note Copyright (c) 2021 AMSUC - Countdown Timer - Kala, Jaraczewski

module SWITCH_DEBOUNCER #(
  parameter BITS_NUM = 4,
  parameter REPEAT_PRESC_CNT_BITS_NUM = 7,
  parameter REPEAT_PRESC_CNT_MODULO = 100,
  parameter REPEAT_START_DELAY = REPEAT_PRESC_CNT_MODULO - 1
) (
  input CLK, 
  input CLR, 
  input CE,
  input REP_EN,
  input S_IN, 
  output KEY_EN, 
  output KEY_UP
);
  reg [BITS_NUM-1:0] P_OUT;
  wire [REPEAT_PRESC_CNT_BITS_NUM-1:0] repeat_presc_cnt_q;
  wire repeat_presc_cnt_ceo;

  DOWN_CNT #(
    .BITS_NUM(REPEAT_PRESC_CNT_BITS_NUM),
    .MODULO(REPEAT_PRESC_CNT_MODULO),
    .INIT_VAL(REPEAT_START_DELAY)
  ) repeat_presc_cnt (
    .CLK(CLK),
    .CLR(~KEY_EN),
    .CE(REP_EN),
    .Q(repeat_presc_cnt_q),
    .CEO(repeat_presc_cnt_ceo)
  );

  always @(posedge CLK) begin
    if (CLR)
      P_OUT <= {BITS_NUM{1'b0}};
    else begin
      if (CE)
        P_OUT <= {P_OUT[BITS_NUM-2:0], S_IN};
    end
  end

  assign KEY_UP = (((&P_OUT[BITS_NUM-2:0]) & ~P_OUT[BITS_NUM-1] & CE) | ((&P_OUT[BITS_NUM-1:0]) & repeat_presc_cnt_ceo));
  assign KEY_EN = (&P_OUT[BITS_NUM-1:0]);

endmodule
