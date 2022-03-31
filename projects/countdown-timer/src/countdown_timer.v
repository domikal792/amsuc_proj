`timescale 1ns / 1ps
/// @file countdown_timer.v
///
/// @note Copyright (c) 2022 AMSUC - Countdown Timer - Dominik Kala i Dawid Jaraczewski

/// Logika minutnika.
///
/// @tparam MAX_VAL - Maksymalna wartosc minutnika w sekundach.
/// @tparam BTIS_NUM - Liczba bitow potrzebna do realizacji minutnika.
///
/// @param [IN] CLK - Zegar.
/// @param [IN] CLR - Aysnchroniczne wejscie resetujace stan modulu.
/// @param [IN] CE - Aktywacja zegara logiki sterujacej.
/// @param [IN] RUN_CE - Aktywacja zegara minutnika.
/// @param [IN] BTN_RUN - Sygnal przycisku startu.
/// @param [IN] BTN_MIN_INC - Sygnal przycisku inkrementacji minut.
/// @param [IN] BTN_MIN_DEC - Sygnal przycisku dekrementacji minut.
/// @param [IN] BTN_SEC_INC - Sygnal przycisku inkrementacji sekund.
/// @param [IN] BTN_SEC_DEC - Sygnal przycisku dekrementacji sekund.
/// @param [OUT] Q - Rownolegle wyjscie minutnika.
/// @param [OUT] IS_RUNNING - Wyjscie ustawiane podczas pracy minutnika.
module CNTDOWN_TIMER #(
  parameter MAX_VAL = 100*60,
  parameter BITS_NUM = $clog2(MAX_VAL)
) (
  input CLK,
  input CLR,
  input CE,
  input RUN_CE,
  input BTN_RUN,
  input BTN_MIN_INC,
  input BTN_MIN_DEC,
  input BTN_SEC_INC,
  input BTN_SEC_DEC,
  output reg [BITS_NUM-1:0] Q,
  output reg IS_RUNNING
);
  always @(posedge CLK or posedge CLR) begin
    if (CLR) begin
      Q <= {BITS_NUM{1'b0}}; // Asynchroniczne resetowanie minutnika.
      IS_RUNNING <= 1'b0;
    end
    else begin
      if (RUN_CE) begin
        if (IS_RUNNING) begin
          // Logika minutnika - dekrementacja az do 0.
          if (|Q)
            Q <= Q - 1;
          else
            IS_RUNNING <= 1'b0;
        end
      end
        
      // Logika sterujaca.
      if (CE) begin
        if (IS_RUNNING) begin
          // Zatrzymanie minutnika po nacisnieciu przycisku startu podczas pracy.
          if (BTN_RUN)
            IS_RUNNING <= 1'b0;
        end
        else begin
          // Inkrementacja / dekerementacja minut / sekund lub start minutnika.
          if (BTN_RUN)
            IS_RUNNING <= 1'b1;

          if (BTN_MIN_INC)
            Q <= (Q + 6'd60) % MAX_VAL;

          if (BTN_MIN_DEC) begin
              if (Q >= 6'd60)
                Q <= (Q - 6'd60);
              else
                Q <= (MAX_VAL - 6'd60 + Q);
          end

          if (BTN_SEC_INC)
            Q <= (Q + 1'd1) % MAX_VAL;

          if (BTN_SEC_DEC) begin
              if (|Q)
                Q <= (Q - 1'd1);
              else
                Q <= MAX_VAL - 1'd1;
          end
        end
      end
    end
  end
endmodule
