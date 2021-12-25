module CNT(CLK,CLR,CE,Q,CEO);
parameter BITS_NUM = 8;
parameter MOD = 10; 
input CLK, CLR, CE;
output reg [BITS_NUM-1:0] Q;
output CEO;

always @(posedge CLK or posedge CLR)
  if(CLR)
    Q <= {BITS_NUM{1'b0}};
  else begin
    if(CE) begin
      if(Q != MOD-1)
        Q <= Q + 1;
      else
        Q <= {BITS_NUM{1'b0}};
    end
  end

assign CEO = CE & (Q == MOD-1);

endmodule

//zadania:
//1 napisac tb + symulacja

//!!! zbadac wplyw CE; jak dziala CEO?

//2 zrealizowac CEO synchronicznie - przy generowaniu stanu Q
//3 dodac opoznienia do przypisania 

//!!! jaka jest roznica pomiedzy realizacja 1 i 2 (ew. 3)

//4 zrealizowac polaczenie kaskadowe dwoch sekcji licznika bcd; przeniesienie ma byc zegarem nastepnej sekcji

//!!! wnioski

//5 realizacja synchroniczna --- specyfika ukladow FPGA; SKEW