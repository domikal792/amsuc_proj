`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.12.2021 11:51:28
// Design Name: 
// Module Name: wyswietlacz
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


module wyswietlacz(CLK, CLR, CE, IN, E, Q);
input CLK, CLR, CE;
input [13:0] IN;
output [3:0] E;
output [7:0] Q;

//reg [3:0] en;
reg [3:0] liczba;

krazace_zero kz(CLK, CLR, CE, E);

konw7seg k7s(liczba, Q);

always @(posedge CLK) begin
        case (E)
            4'b1110 : liczba = ((IN / 1000) % 10);
            4'b1101 : liczba = ((IN / 100) % 10);
            4'b1011 : liczba = ((IN / 10) % 10);
            4'b0111 : liczba = (IN % 10);
            default: liczba = 0;
        endcase
    end
endmodule
