`timescale 1ns / 1ps
/// @file dec_to_bcd.v
///
/// @note Copyright (c) 2021 AMSUC - Countdown Timer - Kala, Jaraczewski

/// Konwerter liczb dziesietnych na BCD.
///
/// @tparam IN_BITS_NUM - Liczba bitow wejsciowej liczby.
/// @tparam OUT_DECADES - Liczba dekad BCD.
/// @tparam OUT_BITS_NUM - Liczba bitow danych wyjsciowych.
///
/// @param [IN] CLK - Zegar.
/// @param [IN] CLR - Aysnchroniczne wejscie resetujace stan modulu.
/// @param [IN] CE - Aktywacja zegara.
/// @param [OUT] IN - Liczba dziesietna.
/// @param [OUT] Q - Liczba zapisana w systemie BCD.
module DEC_TO_BCD #(
  parameter IN_BITS_NUM = 4,
  parameter OUT_DECADES = 1,
  parameter OUT_BITS_NUM = OUT_DECADES * 4
) (
  input CLK,
  input CLR, 
  input CE,
  input [IN_BITS_NUM-1:0] IN,
  output reg [OUT_BITS_NUM:0] Q
);
  always @(posedge CLK or posedge CLR) begin
    if (CLR)
      Q <= {OUT_BITS_NUM{1'b0}};
    else begin
      if (CE) begin
        if (OUT_DECADES > 0)
          Q[3:0] <= (IN % 4'd10);
        
        if (OUT_DECADES > 1)
          Q[7:4] <= ((IN / 4'd10) % 4'd10);

        if (OUT_DECADES > 2)
          Q[11:8] <= ((IN / 7'd100) % 4'd10);

        if (OUT_DECADES > 3)
          Q[15:12] <= ((IN / 10'd1000) % 4'd10);

        if (OUT_DECADES > 4)
          Q[19:16] <= ((IN / 14'd10000) % 4'd10);

        if (OUT_DECADES > 5)
          Q[23:20] <= ((IN / 17'd100000) % 4'd10);

        if (OUT_DECADES > 6)
          Q[27:24] <= ((IN / 20'd1000000) % 4'd10);

        if (OUT_DECADES > 7)
          Q[31:28] <= ((IN / 24'd10000000) % 4'd10);
      end
    end
  end
endmodule
