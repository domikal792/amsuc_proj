`timescale 1ns / 1ps
/// @file app.v
///
/// @note Copyright (c) 2021 AMSUC - Countdown Timer - Kala, Jaraczewski

module APP(
  input CLK, 
  input CLR, 
  input CE,
  input BTN_START,
  output [7:0] E, 
  output [7:0] Q
);
  wire [16:0] refresh_cnt_q;
  wire refresh_cnt_ceo;
  // wire [26:0] timer_prescaler_cnt_q;
  // wire timer_prescaler_cnt_ceo;
  wire [13:0] secs_cnt_q;
  wire secs_cnt_ceo;
  reg [31:0] data;
  wire btn_start_debouncer_en;
  wire btn_start_debouncer_up;

  // 1ms
  DOWN_CNT #(
    .BITS_NUM(17),
    .MODULO(17'd100000)
  ) disp_refresh_cnt (
    .CLK(CLK),
    .CLR(CLR),
    .CE(CE),
    .Q(refresh_cnt_q),
    .CEO(refresh_cnt_ceo)
  );

  DISP_7SEG_DRV disp_7seg_drv (
    .CLK(CLK),
    .CLR(CLR),
    .CE(refresh_cnt_ceo),
    .E(8'b00001111),
    .DP(8'b11111101),
    .IN(data),
    .EO(E),
    .Q(Q)
  );

  // DOWN_CNT #(
  //   .BITS_NUM(27),
  //   .MODULO(27'd10000000)
  // ) timer_prescaler_cnt (
  //   .CLK(CLK),
  //   .CLR(CLR),
  //   .CE(CE),
  //   .Q(timer_prescaler_cnt_q),
  //   .CEO(timer_prescaler_cnt_ceo)
  // );

  DOWN_CNT #(
    .BITS_NUM(14),
    .MODULO(14'd10000)
  ) secs_cnt (
    .CLK(CLK),
    .CLR(CLR),
    .CE(btn_start_debouncer_up), // .CE(timer_prescaler_cnt_ceo),
    .Q(secs_cnt_q),
    .CEO(secs_cnt_ceo)
  );

  SWITCH_DEBOUNCER #(
    .REPEAT_PRESC_CNT_BITS_NUM(11),
    .REPEAT_PRESC_CNT_MODULO(125), // 125ms => 8Hz
    .REPEAT_START_DELAY(2000) // 2s
  ) btn_start_debouncer (
    .CLK(CLK),
    .CLR(CLR),
    .CE(refresh_cnt_ceo),
    .REP_EN(refresh_cnt_ceo),
    .S_IN(BTN_START),
    .KEY_EN(btn_start_debouncer_en),
    .KEY_UP(btn_start_debouncer_up)
  );

  always @(posedge CLK) begin
    data[3:0] = ((secs_cnt_q) % 4'd10);
    data[7:4] = ((secs_cnt_q / 13'd10) % 4'd10);
    data[11:8] = ((secs_cnt_q / 13'd100) % 4'd10);
    data[15:12] = ((secs_cnt_q / 13'd1000) % 4'd10);
  end
endmodule
