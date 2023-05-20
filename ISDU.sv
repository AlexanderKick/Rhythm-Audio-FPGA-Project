
//------------------------------------------------------------------------------
// Company:          UIUC ECE Dept.
// Engineer:         Stephen Kempf
//
// Create Date:    17:44:03 10/08/06
// Design Name:    ECE 385 Lab 6 Given Code - Incomplete ISDU
// Module Name:    ISDU - Behavioral
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 02-13-2017
//    Spring 2017 Distribution
//------------------------------------------------------------------------------


module ISDU (   input logic         Clk, 
									Reset,
									PunchEN,
									J_Press,
									K_Press,
				  
				// Need Standing still => punch1 => punch2 => punch3
				output logic [3:0] frame
				);

	enum logic [4:0] {  Halted, 
						I_1, 
						P_1, 
						P_2, 
						P_3, 
						H3_1,
						H3_2,
						H3_3,
						H3_4,
						C_1,
						C_2,
						C_3,
						C_4,
						C_5,
						C_6,
						C_7,
						C_8,
						C_9,
						C_10,
						C_11,
						C_12,
						C_13,
						C_14,
						C_15,
						Hold
						}   State, Next_state;   // Internal state logic
						
						

	
	always_ff @ (posedge Clk)
	begin 
		if (Reset)
			State <= Halted;
		else	
			State <= Next_state;
	end

//	always_ff @ (posedge Clk2)
//	begin
//		if (Reset) 
//			State <= Halted;
//		else if((State == Halted) || (State == I_1)) 
//			temp2 <= Next_state;
//	end
//	
//	always_comb
//		begin
//		if((State != Halted) || (State != I_1) )
//			State = temp;
//		else
//			State = temp2;
//		end
  
	always_comb
	begin 
		// Default next state is staying at current state
		Next_state = State;
		
		frame = 4'b0000;
		

		// Any states involving SRAM require more than one clock cycles.
		// Assign next state
		unique case (State)
			Halted : 
				if (K_Press) 
					Next_state = C_1;
				else if(J_Press && PunchEN)
					Next_state = H3_1;
				else if(J_Press)
					Next_state = P_1;
				else
					Next_state = I_1;

			P_1 :
				Next_state = P_2;
			P_2 :
				Next_state = P_3;
			P_3 :
				Next_state = Hold;

			H3_1 :
				Next_state = H3_2;
			H3_2 :
				Next_state = H3_3;
			H3_3 :
				Next_state = H3_4;
			H3_4 :
				Next_state = Hold;

			C_1 :
				//if(K_Press)
					Next_state = C_2;
				// else
				// 	Next_state = FAIL_1;
			C_2 :
				//if(K_Press)
					Next_state = C_3;
				// else
				// 	Next_state = FAIL_1;
			C_3 :
				//if(K_Press)
					Next_state = C_4;
				// else
				// 	Next_state = FAIL_1;
			C_4 :
				//if(K_Press)
					Next_state = C_5;
				// else
				// 	Next_state = FAIL_1;
			C_5 :
				//if(K_Press)
					Next_state = C_6;
				// else
				// 	Next_state = FAIL_1;
			C_6 :
				//if(K_Press)
					Next_state = C_7;
				// else
				// 	Next_state = FAIL_1;
			C_7 :
				//if(K_Press)
					Next_state = C_8;
				//else
					//Next_state = F_1;
			C_8 :
				//if((K_Press)) // Will need to be let go here
					Next_state = C_9;
				// else
				// 	Next_state = FAIL_1;
			C_9 :
				Next_state = C_10;
			C_10 :
				Next_state = C_11;
			C_11 :
				Next_state = C_12;
			C_12 :
				Next_state = C_13;
			C_13 :
				Next_state = C_14;
			C_14 :
				Next_state = C_15;
			C_15 :
				Next_state = Hold;

			I_1 :
				if (K_Press) 
					Next_state = C_1;
				else if(J_Press && PunchEN)
					Next_state = H3_1;
				else if(J_Press)
					Next_state = P_1;
				else
					Next_state = Halted;

			Hold :
				if(J_Press || K_Press)
					Next_state = Hold;
				else
					Next_state = Halted;

			default : ;

		endcase
		
		// Assign control signals based on current state
		case (State)
			Halted: 
				frame = 4'b0000;
			P_1 : 
				frame = 4'b0001;
			P_2 : 
				frame = 4'b0010;
			P_3 : 
				frame = 4'b0011;

			H3_1 :
				frame = 4'b0100;
			H3_2 :
				frame = 4'b0101;
			H3_3 :
				frame = 4'b0110;
			H3_4 :
				frame = 4'b0111;

			C_1 : 
				frame = 4'b0001;
			C_2 : 
				frame = 4'b0010;
			C_3 : 
				frame = 4'b0011;
			C_4 : 
				frame = 4'b0100;
			C_5 : 
				frame = 4'b0101;
			C_6 : 
				frame = 4'b0110;
			C_7 : 
				frame = 4'b0111;
			C_8 : 
				frame = 4'b1000;
			C_9 : 
				frame = 4'b1001;
			C_10 : 
				frame = 4'b1010;
			C_11 :
				frame = 4'b1011;
			C_12 :
				frame = 4'b1100;
			C_13 :
				frame = 4'b1101;
			C_14 :
				frame = 4'b1110;
			C_15 :
				frame = 4'b1111;
			I_1 :
				frame = 4'b0000;
			Hold :
				frame = 4'b0000;

			default : ;
		endcase
	end 

	
endmodule
