module SHF_REG(CLK,CLR, CE,Q);
//parameter BITS_NUM = 8;
input CLK, CLR, CE;
//input D;
output reg [3:0] Q;

always @(posedge CLK or posedge CLR)
  if(CLR)
    Q <= 4'd1111;
  else begin
    if (CE)
        Q <= {Q[2:0], ~&Q[2:0]};
  end

endmodule

//zadania:
//1 uzale¿niæ rejestr od CE
//2 napisac tb + symulacja
//3 implementacja
//4 krazaca '1'