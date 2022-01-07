`timescale 1ns / 1ps
/// @file switch_debouncer.v
///
/// @note Copyright (c) 2021 AMSUC - Countdown Timer - Kala, Jaraczewski

/// Uklad filtrujacy drgania stykow oraz generujacy repetycje po zadanym czasie.
///
/// @tparam BTIS_NUM - Liczba bitow potrzebna do realizacji licznika.
/// @tparam REPEAT_PRESC_CNT_MODULO - Okres repetycji.
/// @tparam REPEAT_START_DELAY - Opoznienie poczatkowe repetycji.
///
/// @param [IN] CLK - Zegar.
/// @param [IN] CLR - Aysnchroniczne wejscie resetujace stan modulu.
/// @param [IN] CE - Aktywacja zegara.
/// @param [IN] REP_CE - Aktywacja zegara dla preskalera generatora repetycji.
/// @param [IN] S_IN - Sygnal wejsciowy z przycisku.
/// @param [OUT] KEY_EN - Przycisk aktywny, 1 - gdy nacisniety, 0 - w przeciwnym przypadku.
/// @param [OUT] KEY_UP - Wyjscie impulsow - impuls po nacisnieciu oraz impulsy z generatora repetycji.
module SWITCH_DEBOUNCER #(
  parameter BITS_NUM = 4,
  parameter REPEAT_PRESC_CNT_MODULO = 100,
  parameter REPEAT_START_DELAY = REPEAT_PRESC_CNT_MODULO - 1
) (
  input CLK, 
  input CLR, 
  input CE,
  input REP_CE,
  input S_IN, 
  output KEY_EN, 
  output KEY_UP
);
  reg [BITS_NUM-1:0] P_OUT;
  wire repeat_presc_cnt_ceo;
  wire key_up_loc;
  wire key_up_repeat;

  // Preskaler generatora repetycji.
  DOWN_CNT #(
    .MODULO(REPEAT_PRESC_CNT_MODULO),
    .INIT_VAL(REPEAT_START_DELAY)
  ) repeat_presc_cnt (
    .CLK(CLK),
    .CLR(key_up_loc), // Resetowanie preskalera po nacisnieciu przycisku
    .CE(REP_CE),
    .CEO(repeat_presc_cnt_ceo)
  );

  always @(posedge CLK) begin
    if (CLR)
      P_OUT <= {BITS_NUM{1'b0}};
    else begin
      if (CE)
        P_OUT <= {P_OUT[BITS_NUM-2:0], S_IN}; // Rejestr przesuwny do filtracji drgania stykow.
    end
  end

  // Detekcja nacisniecia przycisku.
  assign key_up_loc = ((&P_OUT[BITS_NUM-2:0]) & ~P_OUT[BITS_NUM-1] & CE); 

  // Sygnal repetycji.
  assign key_up_repeat = ((&P_OUT[BITS_NUM-1:0]) & repeat_presc_cnt_ceo);

  // Wypracowanie sygnalow wyjsciowych.
  assign KEY_UP = (key_up_loc | key_up_repeat);
  assign KEY_EN = (&P_OUT[BITS_NUM-1:0]);

endmodule
