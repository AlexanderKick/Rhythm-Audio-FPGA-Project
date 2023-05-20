////-------------------------------------------------------------------------
////    Color_Mapper.sv                                                    --
////    Stephen Kempf                                                      --
////    3-1-06                                                             --
////                                                                       --
////    Modified by David Kesler  07-16-2008                               --
////    Translated by Joe Meng    07-07-2013                               --
////                                                                       --
////    Fall 2014 Distribution                                             --
////                                                                       --
////    For use with ECE 385 Lab 7                                         --
////    University of Illinois ECE Department                              --
////-------------------------------------------------------------------------
//
//
module  color_mapper ( input logic blank, VGA_Clk, BallEN, end_screen, activate,
                       input logic [15:0] score,
                       input logic [9:0] JoeX, JoeY, DrawX, DrawY, BallX, BallY, BallS, BallX2, BallY2, BallS2,
                       input logic [3:0] enable,
                       input logic [1:0] start,
                       input logic [3:0] BG_R, BG_G, BG_B,
                       output logic [3:0]  Red, Green, Blue );
  

   // Start screen variables
   logic [3:0] START_R, START_G, START_B;
	logic [3:0] START2_R, START2_G, START2_B;
   logic [3:0] START3_R, START3_G, START3_B;

   // Idle variables
   logic [3:0] IDLE_R, IDLE_G, IDLE_B;

    // Right punch variables
   logic [3:0] PUNCH1_R, PUNCH1_G, PUNCH1_B;
   logic [3:0] PUNCH2_R, PUNCH2_G, PUNCH2_B;
   logic [3:0] PUNCH3_R, PUNCH3_G, PUNCH3_B;
   logic [3:0] PUNCH4_R, PUNCH4_G, PUNCH4_B;

   // Uppercut variables
   logic [3:0] UPCUT_R, UPCUT_G, UPCUT_B;
   logic [3:0] UPCUT2_R, UPCUT2_G, UPCUT2_B;

   // Jab variables
   logic [3:0] JAB_R, JAB_G, JAB_B;
   logic [3:0] JAB2_R, JAB2_G, JAB2_B;
   logic [3:0] JAB3_R, JAB3_G, JAB3_B;

   // Crouch Variables
   logic [3:0] CR_R, CR_G, CR_B;
   logic [3:0] CR2_R, CR2_G, CR2_B;
   logic [3:0] CR3_R, CR3_G, CR3_B;
   logic [3:0] CR4_R, CR4_G, CR4_B;
   logic [3:0] CR5_R, CR5_G, CR5_B;
   logic [3:0] CR6_R, CR6_G, CR6_B;

   //TryAgain
   logic [3:0] tryagain_R, tryagain_G, tryagain_B;

   // Superb
   logic [3:0] Superb_R, Superb_G, Superb_B;
   
   // OK
   logic [3:0] OKScreen_R, OKScreen_G, OKScreen_B;

   // Final animation colors
   logic [3:0] TEMP_R, TEMP_G, TEMP_B;


    // Right punch animation chain
    RightPunch_example back(.DrawX(new_x), .DrawY(new_y), .vga_clk(VGA_Clk), .blank(blank), .red(PUNCH1_R), .green(PUNCH1_G), .blue(PUNCH1_B));
    RightPunch2_1_example back1(.DrawX(new_x), .DrawY(new_y), .vga_clk(VGA_Clk), .blank(blank), .red(PUNCH2_R), .green(PUNCH2_G), .blue(PUNCH2_B));
    RightPunch3_1_example back2(.DrawX(new_x), .DrawY(new_y), .vga_clk(VGA_Clk), .blank(blank), .red(PUNCH3_R), .green(PUNCH3_G), .blue(PUNCH3_B));
   // RightPunch4_1_example back3(.DrawX(new_x), .DrawY(new_y), .vga_clk(VGA_Clk), .blank(blank), .red(PUNCH4_R), .green(PUNCH4_G), .blue(PUNCH4_B));
	 

	 
    // Idle pose
    StandingPose_example idle(.DrawX(new_x), .DrawY(new_y), .vga_clk(VGA_Clk), .blank(blank), .red(IDLE_R), .green(IDLE_G), .blue(IDLE_B));

    // Jab animation chain
    Punch1_1_example punch1(.DrawX(new_x), .DrawY(new_y), .vga_clk(VGA_Clk), .blank(blank), .red(JAB_R), .green(JAB_G), .blue(JAB_B));
    Punch2_1_example punch2(.DrawX(new_x), .DrawY(new_y), .vga_clk(VGA_Clk), .blank(blank), .red(JAB2_R), .green(JAB2_G), .blue(JAB2_B));
    //Punch3_1_example punch3(.DrawX(new_x), .DrawY(new_y), .vga_clk(VGA_Clk), .blank(blank), .red(JAB3_R), .green(JAB3_G), .blue(JAB3_B));

    // Uppercut animation chain
    //Uppercut_example upper(.DrawX(new_x), .DrawY(new_y), .vga_clk(VGA_Clk), .blank(blank), .red(UPCUT_R), .green(UPCUT_G), .blue(UPCUT_B));
    Uppercut2__example upper2(.DrawX(new_x), .DrawY(new_y), .vga_clk(VGA_Clk), .blank(blank), .red(UPCUT2_R), .green(UPCUT2_G), .blue(UPCUT2_B));

    // Crounch animation chain
	Crouch1_example crouch1(.DrawX(new_x), .DrawY(new_y), .vga_clk(VGA_Clk), .blank(blank), .red(CR_R), .green(CR_G), .blue(CR_B));
	Crouch2__example crouch2(.DrawX(new_x), .DrawY(new_y), .vga_clk(VGA_Clk), .blank(blank), .red(CR2_R), .green(CR2_G), .blue(CR2_B));
	//Crouch3__example crouch3(.DrawX(new_x), .DrawY(new_y), .vga_clk(VGA_Clk), .blank(blank), .red(CR3_R), .green(CR3_G), .blue(CR3_B));
	Crouch4__example crouch4(.DrawX(new_x), .DrawY(new_y), .vga_clk(VGA_Clk), .blank(blank), .red(CR4_R), .green(CR4_G), .blue(CR4_B));
	Crouch5__example crouch5(.DrawX(new_x), .DrawY(new_y), .vga_clk(VGA_Clk), .blank(blank), .red(CR5_R), .green(CR5_G), .blue(CR5_B));
	Crouch6__example crouch6(.DrawX(new_x), .DrawY(new_y), .vga_clk(VGA_Clk), .blank(blank), .red(CR6_R), .green(CR6_G), .blue(CR6_B));

	KarateMan_example karate1(.DrawX(DrawX), .DrawY(DrawY), .vga_clk(VGA_Clk), .blank(blank), .red(START_R), .green(START_G), .blue(START_B));
//	KarateMan2_example karate2(.DrawX(DrawX), .DrawY(DrawY), .vga_clk(VGA_Clk), .blank(blank), .red(START2_R), .green(START2_G), .blue(START2_B));
	KarateMan3_example karate3(.DrawX(DrawX), .DrawY(DrawY), .vga_clk(VGA_Clk), .blank(blank), .red(START3_R), .green(START3_G), .blue(START3_B));

	TryAgain_example tryagain(.DrawX(DrawX), .DrawY(DrawY), .vga_clk(VGA_Clk), .blank(blank), .red(tryagain_R), .green(tryagain_G), .blue(tryagain_B));

	Superb_example superb(.DrawX(DrawX), .DrawY(DrawY), .vga_clk(VGA_Clk), .blank(blank), .red(Superb_R), .green(Superb_G), .blue(Superb_B));

	OKScreen_example OK(.DrawX(DrawX), .DrawY(DrawY), .vga_clk(VGA_Clk), .blank(blank), .red(OKScreen_R), .green(OKScreen_G), .blue(OKScreen_B));

    // Equation we are using to calculate location of drawing
    
    logic Joe_on;
	
    logic [9:0] new_x, new_y;

	assign new_x = DrawX - JoeX;
    assign new_y = DrawY - JoeY;
	
	
   int DistX, DistY, DistBallX2, DistBallY2;
    assign DistX = DrawX - JoeX;
    assign DistY = DrawY - JoeY;
	parameter [9:0] SizeJoeX = 200;       // Leftmost point on the X axis
    parameter [9:0] SizeJoeY = 266;
	  
   always_comb begin
       if ((DistX <= SizeJoeX) && (DistY <= SizeJoeY) && (DistX >= 6) && (DistY >= 3)) 
           Joe_on = 1'b1;
       else 
           Joe_on = 1'b0;
    end 


    // Use enable bits to determine which animation we are printing

    always_comb begin
       if (start == 2'b01) begin
            TEMP_R = START_R;
            TEMP_G = START_G;
            TEMP_B = START_B;
       end
       else if (start == 2'b10) begin
            TEMP_R = START3_R;
            TEMP_G = START3_G;
            TEMP_B = START3_B;
       end
       else if (start == 2'b11) begin
            TEMP_R = START3_R;
            TEMP_G = START3_G;
            TEMP_B = START3_B;
       end
    // Idle
       else if (enable == 4'b0000) begin
           TEMP_R = IDLE_R;
           TEMP_B = IDLE_B;
           TEMP_G = IDLE_G;
		 end
    // Right punch
       else if (enable == 4'b0100) begin
           TEMP_R = PUNCH1_R;
           TEMP_G = PUNCH1_G;
           TEMP_B = PUNCH1_B;
       end
       else if (enable == 4'b0101) begin
           TEMP_R = PUNCH2_R;
           TEMP_G = PUNCH2_G;
           TEMP_B = PUNCH2_B;
	    end
       else if (enable == 4'b0110) begin
           TEMP_R = PUNCH3_R;
           TEMP_G = PUNCH3_G;
           TEMP_B = PUNCH3_B;
       end
       else if (enable == 4'b0111) begin
           TEMP_R = PUNCH3_R;
           TEMP_G = PUNCH3_G;
           TEMP_B = PUNCH3_B;
       end
    // Jab
       else if (enable == 4'b0001) begin
           TEMP_R = JAB_R;
           TEMP_G = JAB_G;
           TEMP_B = JAB_B;
       end
       else if (enable == 4'b0010) begin
           TEMP_R = JAB2_R;
           TEMP_G = JAB2_G;
           TEMP_B = JAB2_B;
       end
       else if (enable == 4'b0011) begin
           TEMP_R = JAB2_R;
           TEMP_G = JAB2_G;
           TEMP_B = JAB2_B;
       end
       else if (enable == 4'b1000) begin
           TEMP_R = CR_R;
           TEMP_G = CR_G;
           TEMP_B = CR_B;
       end
       else if (enable == 4'b1001) begin
           TEMP_R = CR2_R;
           TEMP_G = CR2_G;
           TEMP_B = CR2_B;
       end
       else if (enable == 4'b1010) begin
           TEMP_R = CR2_R;
           TEMP_G = CR2_G;
           TEMP_B = CR2_B;
       end
       else if (enable == 4'b1011) begin
           TEMP_R = CR4_R;
           TEMP_G = CR4_G;
           TEMP_B = CR4_B;
       end
       else if (enable == 4'b1100) begin
           TEMP_R = CR5_R;
           TEMP_G = CR5_G;
           TEMP_B = CR5_B;
       end
       else if (enable == 4'b1101) begin
           TEMP_R = CR6_R;
           TEMP_G = CR6_G;
           TEMP_B = CR6_B;
       end
       else if (enable == 4'b1110) begin
           TEMP_R = UPCUT2_R;
           TEMP_G = UPCUT2_G;
           TEMP_B = UPCUT2_B;
       end
       else if (enable == 4'b1111) begin
           TEMP_R = UPCUT2_R;
           TEMP_G = UPCUT2_G;
           TEMP_B = UPCUT2_B;
       end
       else begin
            TEMP_R = 4'h0;
            TEMP_G = 4'h0;
            TEMP_B = 4'h0;
       end
        
        
    end 


    // BALL LOGIC HERE FOR BALL ON
    logic ball_on, ball_on2;
   int DistBallX, DistBallY ,Size, Size2;
	assign DistBallX = DrawX - BallX;
    assign DistBallY = DrawY - BallY;
    assign Size = BallS;

    assign DistBallX2 = DrawX - BallX2;
    assign DistBallY2 = DrawY - BallY2;
    assign Size2 = BallS2;
	  
    always_comb
    begin:Ball_on_proc
        if ( ( DistBallX*DistBallX + DistBallY*DistBallY) <= (Size * Size) ) 
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
     end 

    always_comb
    begin:combo_on_proc
        if ( ( DistBallX2*DistBallX2 + DistBallY2*DistBallY2) <= (Size2 * Size2) ) 
            ball_on2 = 1'b1;
        else 
            ball_on2 = 1'b0;
     end 


    // Check to see if we are printing green, if so, switch to background
   always_comb
   begin:RGB_Display
       if(end_screen) begin
            if(score >= 8'd250) begin
                 Red = Superb_R;
                 Green = Superb_G;
                 Blue = Superb_B;
            end
            else if(score >= 8'd100) begin
                 Red = OKScreen_R;
                 Green = OKScreen_G;
                 Blue = OKScreen_B;
            end
            else begin
                 Red = tryagain_R;
                 Green = tryagain_G;
                 Blue = tryagain_B;
            end
       end
       else if(start != 2'b00) begin
            Red = TEMP_R;
            Green = TEMP_G;
            Blue = TEMP_B;
       end
       else if((ball_on || ball_on2) && BallEN) begin
            if(ball_on) begin
                Red = 8'h00;
                Green = 8'h55;
                Blue = 8'hff;
            end
            else if(activate)begin
                Red = 8'h00;
                Green = 8'hff;
                Blue = 8'h55;
            end
            else begin
                Red = 8'hff;
                Green = 8'h55;
                Blue = 8'h00;
            end
       end
       else if ((Joe_on == 1'b1) && !((TEMP_R == 4'h2) && (TEMP_G == 4'hB) && (TEMP_B == 4'h4))) 
       begin 
           Red = TEMP_R;
           Green = TEMP_G;
           Blue = TEMP_B;
       end       
       else 
       begin 
           Red = BG_R; 
           Green = BG_G;
           Blue = BG_B;
       end      
   end 

endmodule
