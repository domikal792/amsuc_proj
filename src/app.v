`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.12.2021 10:40:39
// Design Name: 
// Module Name: app
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module app(CLK, CE, CLR, E, Q);
input CLK, CLR, CE;
output [3:0] E;
output [7:0] Q;
wire [26:0] cnt_q;
wire [13:0] cnt_q2;
wire ceo, ceo2;

CNT #(
    .BITS_NUM(27), 
    .MOD(10000000)
) cnt(CLK, CLR, CE, cnt_q, ceo);

CNT #(
    .BITS_NUM(14), 
    .MOD(10000)
) cnt2(CLK, CLR, ceo, cnt_q2, ceo2);

wyswietlacz wys(CLK, CLR, CE, cnt_q2, E, Q);

endmodule
