//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  combo ( input Reset, frame_clk, BallEN, K_Press,
					input [3:0] frame,
              output [9:0]  BallX, BallY, BallS,
              output keep_on, activate, audio_flag1);
   
   logic [9:0] Ball_X_Pos, Ball_Y_Pos, Ball_Size, Ball_Y_Motion;
	 
   parameter [9:0] Ball_X_Center = 260;  // Center position on the X axis
   parameter [9:0] Ball_Y_Center = 288;  // Center position on the Y axis

   logic keep_moving;
   logic pulse;
   logic trigger;
   logic audio_flag;
  
   always_ff @ (posedge Reset or posedge frame_clk )
   begin
       if (Reset)  // Asynchronous Reset
       begin 
         Ball_Y_Pos <= Ball_Y_Center;
         Ball_X_Pos <= Ball_X_Center;
         Ball_Y_Motion <= 10'b0;
         Ball_Size <= 10'b0;
         keep_moving <= 1'b0;
         trigger <= 1'b1;
         audio_flag <= 1'b0;
       end
        else if(BallEN) begin
            keep_moving <= 1'b1;
        end
        else if(!BallEN && !keep_moving) begin
            Ball_Y_Motion <= 10'd0;
            Ball_X_Pos <= Ball_X_Center;
            Ball_Y_Pos <= Ball_Y_Center;
            Ball_Size <= 10'b0;
            trigger <= 1'b0;
            pulse <= 1'b0;
            audio_flag <= 1'b0;
       end
        else if(keep_moving && !pulse) begin
            if(Ball_Size <= 7'd50) begin
                Ball_Size <= Ball_Size + 1'b1;
                Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
			end
            else begin
                pulse <= 1'b1;
                trigger <= 1'b1;
                Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
            end
        end
        else if(!trigger)begin
            if(Ball_Size >= 7'd20)begin
                Ball_Size <= Ball_Size - 1'b1;
                Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
					 end
            else begin
                trigger <= 1'b1;
                Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
            end
        end
        else if((Ball_Y_Pos <= 10)) begin
                keep_moving <= 1'b0;
            end
        else if(trigger && (frame == 4'b1110)) begin
            Ball_Y_Motion <= -20;
            Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
            audio_flag <= 1'b1;
        end
        else if(trigger) begin
            Ball_Size <= 10'd40;
            Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
        end
   end

			
   assign BallX = Ball_X_Pos;
  
   assign BallY = Ball_Y_Pos;
  
   assign BallS = Ball_Size;

   assign keep_on = keep_moving;

   assign activate = trigger;

   assign audio_flag1 = audio_flag;

endmodule

