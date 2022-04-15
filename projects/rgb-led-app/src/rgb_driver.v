`timescale 1ns / 1ps
/// @file rgb_driver.v
///
/// @note Copyright (c) 2022 AMSUC - Dominik Kala i Dawid Jaraczewski

module RGB_DRIVER #(
  parameter ACT_STATE = 1,
  parameter FILL_FACTOR_MAX = 255,
  parameter FILL_FACTOR_BITS_NUM = $clog2(FILL_FACTOR_MAX)
) (
  input CLK,
  input CLR,
  input CE,
  input [FILL_FACTOR_BITS_NUM-1:0] R_FILL_FACTOR,
  input [FILL_FACTOR_BITS_NUM-1:0] G_FILL_FACTOR,
  input [FILL_FACTOR_BITS_NUM-1:0] B_FILL_FACTOR,
  output R,
  output G,
  output B
);
  
  PWM_CHANNEL #(
    .ACT_STATE(ACT_STATE),
    .FILL_FACTOR_MAX(FILL_FACTOR_MAX)
  ) red_pwm_ch (
    .CLK(CLK),
    .CLR(CLR),
    .CE(CE),
    .FILL_FACTOR(R_FILL_FACTOR),
    .Q(R)
  );

  PWM_CHANNEL #(
    .ACT_STATE(ACT_STATE),
    .FILL_FACTOR_MAX(FILL_FACTOR_MAX)
  ) green_pwm_ch (
    .CLK(CLK),
    .CLR(CLR),
    .CE(CE),
    .FILL_FACTOR(G_FILL_FACTOR),
    .Q(G)
  );

  PWM_CHANNEL #(
    .ACT_STATE(ACT_STATE),
    .FILL_FACTOR_MAX(FILL_FACTOR_MAX)
  ) blue_pwm_ch (
    .CLK(CLK),
    .CLR(CLR),
    .CE(CE),
    .FILL_FACTOR(B_FILL_FACTOR),
    .Q(B)
  );

endmodule
