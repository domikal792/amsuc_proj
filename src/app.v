`timescale 1ns / 1ps
/// @file app.v
///
/// @note Copyright (c) 2021 AMSUC - Countdown Timer - Kala, Jaraczewski

module APP(
  input CLK, 
  input CLR, 
  input CE, 
  output [7:0] E, 
  output [7:0] Q
);
  wire [16:0] disp_refresh_cnt_q;
  wire disp_refresh_cnt_ceo;
  wire [26:0] timer_prescaler_cnt_q;
  wire timer_prescaler_cnt_ceo;
  wire [13:0] secs_cnt_q;
  wire secs_cnt_ceo;
  reg [31:0] data;

  DOWN_CNT #(
    .BITS_NUM(17),
    .MODULO(100000)
  ) disp_refresh_cnt (
    .CLK(CLK),
    .CLR(CLR),
    .CE(CE),
    .Q(disp_refresh_cnt_q),
    .CEO(disp_refresh_cnt_ceo)
  );

  DISP_7SEG_DRV disp_7seg_drv (
    .CLK(CLK),
    .CLR(CLR),
    .CE(disp_refresh_cnt_ceo),
    .E(8'b00001111),
    .DP(8'b11111101),
    .IN(data),
    .EO(E),
    .Q(Q)
  );

  DOWN_CNT #(
    .BITS_NUM(27),
    .MODULO(10000000)
  ) timer_prescaler_cnt (
    .CLK(CLK),
    .CLR(CLR),
    .CE(CE),
    .Q(timer_prescaler_cnt_q),
    .CEO(timer_prescaler_cnt_ceo)
  );

  DOWN_CNT #(
    .BITS_NUM(14),
    .MODULO(10000)
  ) secs_cnt (
    .CLK(CLK),
    .CLR(CLR),
    .CE(timer_prescaler_cnt_ceo),
    .Q(secs_cnt_q),
    .CEO(secs_cnt_ceo)
  );

  always @(posedge CLK) begin
      data[3:0] = ((secs_cnt_ceo) % 10);
      data[7:4] = ((secs_cnt_ceo / 10) % 10);
      data[11:8] = ((secs_cnt_ceo / 100) % 10);
      data[15:12] = ((secs_cnt_ceo / 1000) % 10);
  end
endmodule
