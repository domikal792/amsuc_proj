`timescale 1ns / 1ps
/// @file inc_dec_reg_tb.v
///
/// @note Copyright (c) 2022 AMSUC - Dominik Kala i Dawid Jaraczewski

// TODO: Fix this sim since INC_DEC_REG module has changed

module INC_DEC_REG_TB;
  parameter BITS_NUM = 3;

  reg clk;
  reg clr;
  reg ce;
  reg inc_en;
  reg dec_en;

  wire [BITS_NUM-1:0] q;

  INC_DEC_REG #(
    .BITS_NUM(BITS_NUM)
  ) pwm_channel (
    .CLK(clk),
    .CLR(clr),
    .CE(ce),
    .INC_EN(inc_en),
    .DEC_EN(dec_en),
    .Q(q)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial
  begin
    clr = 1'b0;
    ce = 1'b0;
    inc_en = 1'b0;
    dec_en = 1'b0;

    #10 clr = 1'b1;
    ce = 1'b1;
    #10 clr = 1'b0;

    #10 inc_en = 1'b1;
    #50 dec_en = 1'b1;
    #10 inc_en = 1'b0;
    #50 dec_en = 1'b0;

    #20 $stop;
  end

  initial
    $monitor($time, " Output q = %d",  q);

endmodule
