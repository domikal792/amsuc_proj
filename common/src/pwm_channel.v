`timescale 1ns / 1ps
/// @file pwm_channel.v
///
/// @note Copyright (c) 2022 AMSUC - Dominik Kala i Dawid Jaraczewski

/// Kanał PWM
///
/// @tparam ACT_STATE - Stan aktywny 0 lub 1.
/// @tparam FILL_FACTOR_MAX - Maksymalne wypełnienie.
/// @tparam FILL_FACTOR_BITS_NUM - Liczba bitow maksymalnego wypełnienia.
///
/// @param [IN] CLK - Zegar.
/// @param [IN] CLR - Aysnchroniczne wejscie resetujace stan modulu.
/// @param [IN] CE - Aktywacja zegara.
/// @param [IN] FILL_FACTOR - Zadane wypełnienie.
/// @param [OUT] Q - Wyjście.

module PWM_CHANNEL #(
  parameter ACT_STATE = 1,
  parameter FILL_FACTOR_MAX = 255,
  parameter FILL_FACTOR_BITS_NUM = $clog2(FILL_FACTOR_MAX)
) (
  input CLK,
  input CLR,
  input CE,
  input [FILL_FACTOR_BITS_NUM-1:0] FILL_FACTOR,
  output Q
);
  wire [FILL_FACTOR_BITS_NUM-1:0] pwm_cnt_q;

  DOWN_CNT #(
    .MODULO(FILL_FACTOR_MAX),
    .BITS_NUM(FILL_FACTOR_BITS_NUM)
  ) pwm_cnt (
    .CLK(CLK),
    .CLR(CLR),
    .CE(CE),
    .Q(pwm_cnt_q)
  );

  assign Q = ~CLR & (~ACT_STATE ^ (
    (pwm_cnt_q < FILL_FACTOR) | (FILL_FACTOR == FILL_FACTOR_MAX)
  ));

endmodule
