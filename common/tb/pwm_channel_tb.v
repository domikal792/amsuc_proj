`timescale 1ns / 1ps
/// @file pwm_channel_tb.v
///
/// @note Copyright (c) 2022 AMSUC - Dominik Kala i Dawid Jaraczewski

module PWM_CHANNEL_TB;
  parameter FILL_FACTOR_MAX = 7;
  parameter ACT_STATE = 1;
  parameter FILL_FACTOR = 3;

  reg [$clog2(FILL_FACTOR_MAX)-1:0] fill_factor;
  reg clk;
  reg clr;
  reg ce;

  wire q;

  PWM_CHANNEL #(
    .ACT_STATE(ACT_STATE),
    .FILL_FACTOR_MAX(FILL_FACTOR_MAX)
  ) pwm_channel (
    .CLK(clk),
    .CLR(clr),
    .CE(ce),
    .FILL_FACTOR(fill_factor),
    .Q(q)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial
  begin
    clr = 1'b0;
    ce = 1'b0;
    fill_factor = FILL_FACTOR;
    #10 clr = 1'b1;
    ce = 1'b1;
    #10 clr = 1'b0;
    #200 $stop;
  end

  initial
    $monitor($time, " Output q = %d",  q);

endmodule
