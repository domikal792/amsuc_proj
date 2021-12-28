module SWITCH_CTRL(CLK, CLR, CE, S_IN, KEY_EN, KEY_UP);
	parameter l_bit = 4;
	input CLK, CLR, CE, S_IN;
	output KEY_EN, KEY_UP;
	
	reg [l_bit-1:0] P_OUT;
      
   always @(posedge CLK)
	begin
		if(CLR)
			P_OUT <= {l_bit{1'b0}};
		else
			if (CE)
				P_OUT <= {P_OUT[l_bit-2:0],S_IN};
	end
				
	assign KEY_UP = (&P_OUT[l_bit-2:0]) & ~P_OUT[l_bit-1] & CE;	
	assign KEY_EN = (&P_OUT[l_bit-1:0]);
endmodule


//zadania:
//1 debouncer przelaczny (wykres czasowy 3)
//2 debouncer z repetycja (wykres czasowy 4)
//3 debouncer z repetycja ze zwloka (wykres czasowy 5)
