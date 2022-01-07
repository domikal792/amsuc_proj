`timescale 1ns / 1ps
/// @file down_counter.v
///
/// @note Copyright (c) 2021 AMSUC - Countdown Timer - Kala, Jaraczewski

/// Licznik liczacy w dol.
///
/// @tparam MODULO - Wartosc modulo licznika.
/// @tparam INIT_VAL - Wartosc inicjalizacyjna, ustawiana po wykryciu narastajacego zbocza na wejsciu 'CLR'.
/// @tparam BTIS_NUM - Liczba bitow potrzebna do realizacji licznika.
///
/// @param [IN] CLK - Zegar.
/// @param [IN] CLR - Aysnchroniczne wejscie resetujace stan modulu.
/// @param [IN] CE - Aktywacja zegara.
/// @param [OUT] Q - Rownolegle wyjscie licznika.
/// @param [OUT] CEO - Wyjscie aktywacyjne zegara.
module DOWN_CNT #(
  parameter MODULO = 10,
  parameter INIT_VAL = MODULO - 1,
  parameter BITS_NUM = $clog2(MODULO < INIT_VAL ? INIT_VAL : MODULO)
) (
  input CLK,
  input CLR,
  input CE,
  output reg [BITS_NUM-1:0] Q,
  output CEO
);
  always @(posedge CLK or posedge CLR) begin
    if (CLR)
      Q <= INIT_VAL;
    else begin
      if (CE) begin
        // Sprawdzenie, czy doliczono do zera.
        if ((|Q))
          Q <= Q - 1;
        else
          Q <= MODULO - 1;
      end
    end
  end

  // Wypracowanie sygnalu wyjsciowego aktywacji zegara.
  assign CEO = CE & (~|Q);

endmodule
