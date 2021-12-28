`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.12.2021 11:25:45
// Design Name: 
// Module Name: krazace_zero
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

module krazace_zero(CLK, CLR, CE, Q);
parameter BITS_NUM = 27;
parameter MOD = 100000;
input CLK, CLR, CE;
output [3:0] Q;
wire [BITS_NUM-1:0] cnt_q;
wire ceo;

CNT #(
    .BITS_NUM(BITS_NUM), 
    .MOD(MOD)
) cnt(CLK, CLR, CE, cnt_q, ceo);

SHF_REG shfReg(CLK, CLR, ceo, Q);

endmodule
