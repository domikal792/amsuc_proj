`timescale 1ns / 1ps
/// @file debouncer.v
///
/// @note Copyright (c) 2021 AMSUC - Countdown Timer - Kala, Jaraczewski

module SWITCH_CTRL #(
  parameter BITS_NUM = 4,
  parameter PRESC_BITS_NUM = 7,
  parameter PRESC_MODULO = 100,
  parameter REPEAT_DELAY = 10
) (
  input CLK, 
  input CLR, 
  input CE, 
  input S_IN, 
  output KEY_EN, 
  output KEY_UP
);
  reg [BITS_NUM-1:0] P_PUT;
  wire [PRESC_BITS_NUM-1:0] presc_cnt_q;
  wire presc_cnt_ceo;

  DOWN_CNT #(
    .BITS_NUM(PRESC_BITS_NUM),
    .MODULO(PRESC_MODULO)
  ) presc_cnt (
    .CLK(CLK),
    .CLR(CLR),
    .CE(CE),
    .Q(PRESC_BITS_NUM),
    .CEO(presc_cnt_ceo)
  );

  always @(posedge CLK) begin
    if (CLR)
      P_OUT <= {BITS_NUM{1'b0}};
    else begin
      if (CE)
        P_OUT <= {P_OUT[BITS_NUM-2:0], S_IN};    
    end
  end

  assign KEY_UP = (&P_OUT[BITS_NUM-2:0]) & ~P_OUT[BITS_NUM-1] & CE;	
  assign KEY_EN = (&P_OUT[BITS_NUM-1:0]);

// 	input CLK, CLR, CE, S_IN;
// 	output KEY_EN, KEY_UP;
	
// 	reg [l_bit-1:0] P_OUT;
      
//    always @(posedge CLK)
// 	begin
// 		if(CLR)
// 			P_OUT <= {BITS_NUM{1'b0}};
// 		else
// 			if (CE)
// 				P_OUT <= {P_OUT[BITS_NUM-2:0], S_IN};
// 	end

endmodule


//zadania:
//1 debouncer przelaczny (wykres czasowy 3)
//2 debouncer z repetycja (wykres czasowy 4)
//3 debouncer z repetycja ze zwloka (wykres czasowy 5)
