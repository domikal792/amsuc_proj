`timescale 1ns / 1ps
/// @file app.v
///
/// @note Copyright (c) 2021 AMSUC - Countdown Timer - Kala, Jaraczewski

/// Logika aplikacji.
///
/// @param [IN] CLK - Zegar.
/// @param [IN] CLR - Aysnchroniczne wejscie resetujace stan modulu.
/// @param [IN] CE - Aktywacja zegara logiki sterujacej.
/// @param [IN] BTN_START - Sygnal z fizycznego przycisku startu.
/// @param [IN] BTN_MIN_P - Sygnal z fizycznego przycisku inkrementacji minut.
/// @param [IN] BTN_MIN_M - Sygnal z fizycznego przycisku dekrementacji minut.
/// @param [IN] BTN_SEC_P - Sygnal z fizycznego przycisku inkrementacji sekund.
/// @param [IN] BTN_SEC_M - Sygnal z fizycznego przycisku dekrementacji sekund.
/// @param [OUT] E - Wektor aktywujacy poszczegolna cyfre wyswietlacza.
/// @param [OUT] Q - Dane do wyswietlenia na wybranej cyfrze wyswietlacza.
module APP(
  input CLK, 
  input CLR, 
  input CE,
  input BTN_START,
  input BTN_MIN_P,
  input BTN_MIN_M,
  input BTN_SEC_P,
  input BTN_SEC_M,
  output [7:0] E, 
  output [7:0] Q
);
  parameter CNTDOWN_TIMER_MAX_VAL = 60*1000; // 1000 mins
  parameter CNTDOWN_TIMER_BITS_NUM = $clog2(CNTDOWN_TIMER_MAX_VAL);
  parameter BTN_START_DELAY_MS = 1500; // ms
  parameter BTN_REPEAT_INTVAL_MS = 70; // ms
  wire refresh_cnt_ceo;
  wire countdown_timer_presc_cnt_ceo;
  wire [CNTDOWN_TIMER_BITS_NUM-1:0] countdown_timer_secs;
  wire [31:0] disp_data;
  wire btn_start_debouncer_up;
  wire btn_min_inc_debouncer_up;
  wire btn_min_dec_debouncer_up;
  wire btn_sec_inc_debouncer_up;
  wire btn_sec_dec_debouncer_up;
  wire is_running_countdown_timer;
  wire blink;

  // Preskaler zegara na 1ms.
  DOWN_CNT #(
    .MODULO(17'd100000)
  ) refresh_cnt (
    .CLK(CLK),
    .CLR(CLR),
    .CE(CE),
    .CEO(refresh_cnt_ceo)
  );

  // Instancja sterownika wyswietlacza.
  DISP_7SEG_DRV disp_7seg_drv (
    .CLK(CLK),
    .CLR(CLR),
    .CE(refresh_cnt_ceo),
    .E((8'b01110011 & {8{CE}})),
    .DP({8{~is_running_countdown_timer & blink}}),
    .IN(disp_data),
    .EO(E),
    .Q(Q)
  );

  // Preskaler zegara na 1s
  DOWN_CNT #(
    .MODULO(27'd100000000)
  ) countdown_timer_presc_cnt (
    .CLK(CLK),
    .CLR(CLR),
    .CE(CE),
    .CEO(countdown_timer_presc_cnt_ceo)
  );

  // Licznik generujacy sygnal do mrugania kropkami.
  DOWN_CNT #(
    .MODULO(2'd2)
  ) blink_cnt (
    .CLK(CLK),
    .CLR(CLR),
    .CE(countdown_timer_presc_cnt_ceo),
    .Q(blink)
  );

  // Eliminacja drgan przycisku startu.
  SWITCH_DEBOUNCER #(
    .REPEAT_PRESC_CNT_MODULO(BTN_REPEAT_INTVAL_MS),
    .REPEAT_START_DELAY(BTN_START_DELAY_MS)
  ) btn_start_debouncer (
    .CLK(CLK),
    .CLR(CLR),
    .CE(refresh_cnt_ceo),
    .REP_CE(1'b0),
    .S_IN(BTN_START),
    .KEY_UP(btn_start_debouncer_up)
  );

  // Eliminacja drgan przycisku inkrementacji minut.
  SWITCH_DEBOUNCER #(
    .REPEAT_PRESC_CNT_MODULO(BTN_REPEAT_INTVAL_MS),
    .REPEAT_START_DELAY(BTN_START_DELAY_MS)
  ) btn_min_inc_debouncer (
    .CLK(CLK),
    .CLR(CLR),
    .CE(refresh_cnt_ceo),
    .REP_CE(refresh_cnt_ceo),
    .S_IN(BTN_MIN_P),
    .KEY_UP(btn_min_inc_debouncer_up)
  );

  // Eliminacja drgan przycisku dekrementacji minut.
  SWITCH_DEBOUNCER #(
    .REPEAT_PRESC_CNT_MODULO(BTN_REPEAT_INTVAL_MS),
    .REPEAT_START_DELAY(BTN_START_DELAY_MS)
  ) btn_min_dec_debouncer (
    .CLK(CLK),
    .CLR(CLR),
    .CE(refresh_cnt_ceo),
    .REP_CE(refresh_cnt_ceo),
    .S_IN(BTN_MIN_M),
    .KEY_UP(btn_min_dec_debouncer_up)
  );

  // Eliminacja drgan przycisku inkrementacji sekund.
  SWITCH_DEBOUNCER #(
    .REPEAT_PRESC_CNT_MODULO(BTN_REPEAT_INTVAL_MS),
    .REPEAT_START_DELAY(BTN_START_DELAY_MS)
  ) btn_sec_inc_debouncer (
    .CLK(CLK),
    .CLR(CLR),
    .CE(refresh_cnt_ceo),
    .REP_CE(refresh_cnt_ceo),
    .S_IN(BTN_SEC_P),
    .KEY_UP(btn_sec_inc_debouncer_up)
  );

  // Eliminacja drgan przycisku dekrementacji sekund.
  SWITCH_DEBOUNCER #(
    .REPEAT_PRESC_CNT_MODULO(BTN_REPEAT_INTVAL_MS),
    .REPEAT_START_DELAY(BTN_START_DELAY_MS)
  ) btn_sec_dec_debouncer (
    .CLK(CLK),
    .CLR(CLR),
    .CE(refresh_cnt_ceo),
    .REP_CE(refresh_cnt_ceo),
    .S_IN(BTN_SEC_M),
    .KEY_UP(btn_sec_dec_debouncer_up)
  );

  // Konwersja minut na BCD.
  DEC_TO_BCD #(
    .IN_BITS_NUM(CNTDOWN_TIMER_BITS_NUM),
    .OUT_DECADES(3)
  ) dec_to_bcd_mins (
    .CLK(CLK),
    .CLR(CLR),
    .CE(refresh_cnt_ceo),
    .IN(countdown_timer_secs / 6'd60),
    .Q(disp_data[27:16])
  );
  
  // Konwersja sekund na BCD.
  DEC_TO_BCD #(
    .IN_BITS_NUM(CNTDOWN_TIMER_BITS_NUM),
    .OUT_DECADES(2)
  ) dec_to_bcd_secs (
    .CLK(CLK),
    .CLR(CLR),
    .CE(refresh_cnt_ceo),
    .IN(countdown_timer_secs % 6'd60),
    .Q(disp_data[7:0])
  );
  
  // Instanacja modulu sterujacego logika minutnika.
  CNTDOWN_TIMER #(
    .MAX_VAL(CNTDOWN_TIMER_MAX_VAL)
  ) cntdown_timer (
    .CLK(CLK),
    .CLR(CLR),
    .CE(CE),
    .RUN_CE(countdown_timer_presc_cnt_ceo),
    .BTN_RUN(btn_start_debouncer_up),
    .BTN_MIN_INC(btn_min_inc_debouncer_up),
    .BTN_MIN_DEC(btn_min_dec_debouncer_up),
    .BTN_SEC_INC(btn_sec_inc_debouncer_up),
    .BTN_SEC_DEC(btn_sec_dec_debouncer_up),
    .Q(countdown_timer_secs),
    .IS_RUNNING(is_running_countdown_timer)
  );
endmodule
