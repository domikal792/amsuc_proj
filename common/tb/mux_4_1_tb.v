`timescale 1ns / 1ps
/// @file mux_4_1_tb.v
///
/// @note Copyright (c) 2022 AMSUC - Dominik Kala i Dawid Jaraczewski

module MUX_4_1_TB;
  parameter BITS_NUM = 2;

  reg [BITS_NUM-1:0] a;
  reg [BITS_NUM-1:0] b;
  reg [BITS_NUM-1:0] c;
  reg [BITS_NUM-1:0] d;
  reg [1:0] sel;

  wire [BITS_NUM-1:0] q;

  MUX_4_1 #(
    .BITS_NUM(BITS_NUM)
  ) mux_4_1 (
    .A(a),
    .B(b),
    .C(c),
    .D(d),
    .SEL(sel),
    .Q(q)
  );

  initial begin
    a = 3;
    b = 2; 
    c = 1;
    d = 0;
    sel = 0;

    repeat (4) begin
      #20 sel = sel + 1;
    end

    #10 $stop;

  end
  
  initial
    $monitor("%t : %d : %b", $time, sel, q);

endmodule
