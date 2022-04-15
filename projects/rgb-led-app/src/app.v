`timescale 1ns / 1ps
/// @file app.v
///
/// @note Copyright (c) 2022 AMSUC - Dominik Kala i Dawid Jaraczewski

/// Logika aplikacji.
///
/// @param [IN] CLK - Zegar.
/// @param [IN] CLR - Aysnchroniczne wejscie resetujace stan modulu.
/// @param [IN] CE - Aktywacja zegara logiki sterujacej.
/// @param [IN] BTN_FILL_FACTOR_INC - Sygnal z fizycznego przycisku inkrementacji wypełnienia.
/// @param [IN] BTN_FILL_FACTOR_DEC - Sygnal z fizycznego przycisku dekrementacji wypełnienia.
/// @param [IN] BTN_SEL_INC - Sygnal z fizycznego przycisku inkrementacji wybranego kanału.
/// @param [IN] BTN_SEL_DEC - Sygnal z fizycznego przycisku dekrementacji wybranego kanału.
/// @param [OUT] DISP_7SEG_EN - Wektor aktywujący poszczególna cyfrę wyświetlacza.
/// @param [OUT] DISP_7SEG_DATA - Dane do wyświetlenia na wybranej cyfrze wyświetlacza.
/// @param [OUT] RGB_R_CH - Wypełnienie kanału czerwonego.
/// @param [OUT] RGB_G_CH - Wypełnienie kanału zielonego.
/// @param [OUT] RGB_B_CH - Wypełnienie kanału niebieskiego.

module APP (
  input CLK,
  input CLR,
  input CE,
  input BTN_FILL_FACTOR_INC,
  input BTN_FILL_FACTOR_DEC,
  input BTN_SEL_INC,
  input BTN_SEL_DEC,
  output [7:0] DISP_7SEG_DATA,
  output [7:0] DISP_7SEG_EN,
  output RGB_R_CH,
  output RGB_G_CH,
  output RGB_B_CH
);

  parameter FILL_FACTOR_MAX = 255;
  parameter FILL_FACTOR_BITS_NUM = $clog2(FILL_FACTOR_MAX);
  parameter BTN_START_DELAY_MS = 1500; // ms
  parameter BTN_REPEAT_INTVAL_MS = 70; // ms
  
  wire refresh_disp_btn_ceo;
  wire refresh_rgb_ceo;

  wire [FILL_FACTOR_BITS_NUM-1:0] rgb_r_fill_factor;
  wire [FILL_FACTOR_BITS_NUM-1:0] rgb_g_fill_factor;
  wire [FILL_FACTOR_BITS_NUM-1:0] rgb_b_fill_factor;

  wire btn_fill_fact_inc_act;
  wire btn_fill_fact_inc_ceo;
  wire btn_fill_fact_dec_act;
  wire btn_fill_fact_dec_ceo;
  wire btn_sel_inc_act;
  wire btn_sel_inc_ceo;
  wire btn_sel_dec_act;
  wire btn_sel_dec_ceo;

  wire mod_fill_factor_r_inc_ce;
  wire mod_fill_factor_r_dec_ce;
  wire mod_fill_factor_inc_g_ce;
  wire mod_fill_factor_dec_g_ce;
  wire mod_fill_factor_inc_b_ce;
  wire mod_fill_factor_dec_b_ce;
  
  wire [1:0] rgb_selected_color;
  
  wire blink_act_color_ce;
  wire blink_act_color;
  wire blink_act_color_r;
  wire blink_act_color_g;
  wire blink_act_color_b;

  // Preskaler zegara na 1ms.
  DOWN_CNT #(
    .MODULO(17'd100000)
  ) refresh_disp_btn_cnt (
    .CLK(CLK),
    .CLR(CLR),
    .CE(CE),
    .CEO(refresh_disp_btn_ceo)
  );

  // Preskaler zegara na 20us.
  DOWN_CNT #(
    .MODULO(11'd2000)
  ) refresh_rgb_cnt (
    .CLK(CLK),
    .CLR(CLR),
    .CE(CE),
    .CEO(refresh_rgb_ceo)
  );
  
  // Preskaler zegara na 500ms
  DOWN_CNT #(
    .MODULO(26'd50000000)
  ) blink_dp_cnt (
    .CLK(CLK),
    .CLR(CLR),
    .CE(CE),
    .CEO(blink_act_color_ce)
  );
  
  // Licznik generujacy sygnal do mrugania kropkami.
  DOWN_CNT #(
    .MODULO(2'd2)
  ) blink_cnt (
    .CLK(CLK),
    .CLR(CLR),
    .CE(blink_act_color_ce),
    .Q(blink_act_color)
  );

  // Eliminacja drgan przycisku inkrementacji wypełnienia.
  SWITCH_DEBOUNCER #(
    .REPEAT_PRESC_CNT_MODULO(BTN_REPEAT_INTVAL_MS),
    .REPEAT_START_DELAY(BTN_START_DELAY_MS)
  ) btn_fill_fact_inc_debouncer (
    .CLK(CLK),
    .CLR(CLR),
    .CE(refresh_disp_btn_ceo),
    .REP_CE(refresh_disp_btn_ceo),
    .S_IN(BTN_FILL_FACTOR_INC),
    .KEY_EN(btn_fill_fact_inc_act),
    .KEY_UP(btn_fill_fact_inc_ceo)
  );

  // Eliminacja drgan przycisku dekrementacji wypełnienia.
  SWITCH_DEBOUNCER #(
    .REPEAT_PRESC_CNT_MODULO(BTN_REPEAT_INTVAL_MS),
    .REPEAT_START_DELAY(BTN_START_DELAY_MS)
  ) btn_fill_fact_dec_debouncer (
    .CLK(CLK),
    .CLR(CLR),
    .CE(refresh_disp_btn_ceo),
    .REP_CE(refresh_disp_btn_ceo),
    .S_IN(BTN_FILL_FACTOR_DEC),
    .KEY_EN(btn_fill_fact_dec_act),
    .KEY_UP(btn_fill_fact_dec_ceo)
  );
  
  // Eliminacja drgan przycisku inkrementacji wybranego kanału.
  SWITCH_DEBOUNCER #(
    .REPEAT_PRESC_CNT_MODULO(BTN_REPEAT_INTVAL_MS),
    .REPEAT_START_DELAY(BTN_START_DELAY_MS)
  ) btn_sel_inc_debouncer (
    .CLK(CLK),
    .CLR(CLR),
    .CE(refresh_disp_btn_ceo),
    .REP_CE(1'b0),
    .S_IN(BTN_SEL_INC),
    .KEY_EN(btn_sel_inc_act),
    .KEY_UP(btn_sel_inc_ceo)
  );
  
  // Eliminacja drgan przycisku dekrementacji wybranego kanału.
  SWITCH_DEBOUNCER #(
    .REPEAT_PRESC_CNT_MODULO(BTN_REPEAT_INTVAL_MS),
    .REPEAT_START_DELAY(BTN_START_DELAY_MS)
  ) btn_sel_dec_debouncer (
    .CLK(CLK),
    .CLR(CLR),
    .CE(refresh_disp_btn_ceo),
    .REP_CE(1'b0),
    .S_IN(BTN_SEL_DEC),
    .KEY_EN(btn_sel_dec_act),
    .KEY_UP(btn_sel_dec_ceo)
  );
  
  // Moduł inkrementujący/dekrementujący wybrany kanał.
  INC_DEC_REG #(
    .BITS_NUM(2'd2)
  ) rgb_color_sel_reg (
    .CLK(CLK),
    .CLR(CLR),
    .INC_CE(btn_sel_inc_ceo & ~btn_sel_dec_act),
    .DEC_CE(btn_sel_dec_ceo & ~btn_sel_inc_act),
    .Q(rgb_selected_color)
  );

  // Demultiplekser zmiany wypełnienia kanału.
  DEMUX_1_4  #(
    .BITS_NUM(2'd2)
  ) mod_fill_factor_ce_demux (
    .X({btn_fill_fact_inc_ceo & ~btn_fill_fact_dec_act, btn_fill_fact_dec_ceo & ~btn_fill_fact_inc_act}),
    .SEL(rgb_selected_color),
    .Y1({mod_fill_factor_r_inc_ce, mod_fill_factor_r_dec_ce}),
    .Y2({mod_fill_factor_g_inc_ce, mod_fill_factor_g_dec_ce}),
    .Y3({mod_fill_factor_b_inc_ce, mod_fill_factor_b_dec_ce})
  );

  // Moduł inkrementujący/dekrementujący kanał czerwony.
  INC_DEC_REG #(
    .BITS_NUM(FILL_FACTOR_BITS_NUM)
  ) rgb_red_fill_factor_reg (
    .CLK(CLK),
    .CLR(CLR),
    .INC_CE(mod_fill_factor_r_inc_ce),
    .DEC_CE(mod_fill_factor_r_dec_ce),
    .Q(rgb_r_fill_factor)
  );

  // Moduł inkrementujący/dekrementujący kanał zielony.
  INC_DEC_REG #(
    .BITS_NUM(FILL_FACTOR_BITS_NUM)
  ) rgb_green_fill_factor_reg (
    .CLK(CLK),
    .CLR(CLR),
    .INC_CE(mod_fill_factor_g_inc_ce),
    .DEC_CE(mod_fill_factor_g_dec_ce),
    .Q(rgb_g_fill_factor)
  );

  // Moduł inkrementujący/dekrementujący kanał niebieski.
  INC_DEC_REG #(
    .BITS_NUM(FILL_FACTOR_BITS_NUM)
  ) rgb_blue_fill_factor_reg (
    .CLK(CLK),
    .CLR(CLR),
    .INC_CE(mod_fill_factor_b_inc_ce),
    .DEC_CE(mod_fill_factor_b_dec_ce),
    .Q(rgb_b_fill_factor)
  );
  
  // Sterownik PWM diody RGB
  RGB_DRIVER #(
    .ACT_STATE(1'b1),
    .FILL_FACTOR_MAX(FILL_FACTOR_MAX)
  ) rgb_driver (
    .CLK(CLK),
    .CLR(CLR),
    .CE(refresh_rgb_ceo),
    .R_FILL_FACTOR(rgb_r_fill_factor),
    .G_FILL_FACTOR(rgb_g_fill_factor),
    .B_FILL_FACTOR(rgb_b_fill_factor),
    .R(RGB_R_CH),
    .G(RGB_G_CH),
    .B(RGB_B_CH)
  );
  
  // Demultiplekser wypełnienia kanału.
  DEMUX_1_4 blink_act_color_ce_demux (
    .X(blink_act_color),
    .SEL(rgb_selected_color),
    .Y1(blink_act_color_r),
    .Y2(blink_act_color_g),
    .Y3(blink_act_color_b)
  );

  // Instancja sterownika wyswietlacza.
  DISP_7SEG_DRV disp_7seg_drv (
    .CLK(CLK),
    .CLR(CLR),
    .CE(refresh_disp_btn_ceo),
    .E(8'b00111111 & {8{CE}}),
    .DP({2'b0, {2{blink_act_color_r}}, {2{blink_act_color_g}}, {2{blink_act_color_b}}}),
    .IN({8'h00, rgb_r_fill_factor, rgb_g_fill_factor, rgb_b_fill_factor}),
    .EO(DISP_7SEG_EN),
    .Q(DISP_7SEG_DATA)
  );

endmodule
