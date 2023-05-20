 module Background (input logic Clk,
                               Reset,
                   output logic BG_EN);
						 

  enum logic [3:0] {
    BG11,
    BG12,
    BG13,
    BG14,
    BG21,
    BG22,
    BG23,
    BG24
  } State, Next_state;

  		 
  always_ff @ (posedge Clk)
	begin
		if (Reset) 
			State <= BG11;
		else 
			State <= Next_state;
	end
  
	always_comb
	begin 
		// Default next state is staying at current state
		Next_state = State;

    BG_EN = 1'b0;
		
		// Any states involving SRAM require more than one clock cycles.
		// Assign next state
		unique case (State)
			BG11 : 
				Next_state = BG12;
			BG12 :
				Next_state = BG13;
			BG13 :
				Next_state = BG14;
			BG14 :
				Next_state = BG21;

			BG21 :
				Next_state = BG22;
			BG22 :
				Next_state = BG23;
			BG23 :
				Next_state = BG24;
			BG24 :
				Next_state = BG12;
       endcase

       case (State)
			BG11 : 
				BG_EN = 1'b0;
			BG12 :
				BG_EN = 1'b0;
			BG13 :
				BG_EN = 1'b0;
			BG14 :
				BG_EN = 1'b0;
			BG21 :
				BG_EN = 1'b1;
			BG22 :
				BG_EN = 1'b1;
			BG23 :
				BG_EN = 1'b1;
			BG24 :
				BG_EN = 1'b1;
       endcase
   end

endmodule