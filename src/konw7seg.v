`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.12.2021 11:36:08
// Design Name: 
// Module Name: konw7seg
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


module konw7seg(IN, OUT);
input [3:0] IN;
output reg [7:0] OUT;

always @(IN) begin
    case(IN)
        4'h0: OUT = 8'b1000000;
        4'h1: OUT = 8'b1111001;
        4'h2: OUT = 8'b0100100;
        4'h3: OUT = 8'b0110000;
        4'h4: OUT = 8'b0011001;
        4'h5: OUT = 8'b0010010;
        4'h6: OUT = 8'b0000010;
        4'h7: OUT = 8'b1111000;
        4'h8: OUT = 8'b0000000;
        4'h9: OUT = 8'b0010000;
        default: OUT = 8'b1000000;
    endcase 
end

endmodule
