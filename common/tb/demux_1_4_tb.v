`timescale 1ns / 1ps
/// @file demux_1_4_tb.v
///
/// @note Copyright (c) 2022 AMSUC - Dominik Kala i Dawid Jaraczewski

module DEMUX_1_4_TB;
  parameter BITS_NUM = 2;

  wire [BITS_NUM-1:0] a;
  wire [BITS_NUM-1:0] b;
  wire [BITS_NUM-1:0] c;
  wire [BITS_NUM-1:0] d;
  
  reg [1:0] sel;
  reg [BITS_NUM-1:0] x;

  DEMUX_1_4 #(
    .BITS_NUM(BITS_NUM)
  ) mux_4_1 (
    .X(x),
    .SEL(sel),
    .Y0(a),
    .Y1(b),
    .Y2(c),
    .Y3(d)
  );

  initial begin
    x = 2;
    sel = 0;

    repeat (4) begin
      #20 sel = sel + 1;
    end

    #10 $stop;

  end
  
  initial
    $monitor("%t : %d : %b, %b, %b, %b", $time, sel, a, b, c, d);

endmodule
