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


module  ball ( input Reset, frame_clk, BallEN,
					input [4:0] frame,
              output [9:0]  BallX, BallY, BallS,
              output miss_f, perfect_f, keep_on );
   
   logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
	 
   parameter [9:0] Ball_X_Center= 640;  // Center position on the X axis
   parameter [9:0] Ball_Y_Center= 0;  // Center position on the Y axis
   logic punch_flag;
   logic miss_flag;
   logic keep_moving;

  
   always_ff @ (posedge Reset or posedge frame_clk )
   begin
       if (Reset)  // Asynchronous Reset
       begin 
         Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
         Ball_X_Motion <= 10'd0; //Ball_X_Step;
         Ball_Y_Pos <= Ball_Y_Center;
         Ball_X_Pos <= Ball_X_Center;
         punch_flag <= 1'b0;
         miss_flag <= 1'b0;
         keep_moving <= 1'b0;
       end
      else if(BallEN) begin
        keep_moving <= 1'b1;
      end
      else if(!BallEN && !keep_moving) begin
         Ball_X_Motion <= 10'd0;
         Ball_Y_Motion <= 10'd0;
         Ball_X_Pos <= Ball_X_Center;
         Ball_Y_Pos <= Ball_Y_Center;
         punch_flag <= 1'b0;
         miss_flag <= 1'b0;
       end
      else if((Ball_X_Pos <= 100) || (Ball_X_Pos >= 750) || (Ball_Y_Pos >= 460)) begin
           Ball_X_Pos <= Ball_X_Center;
           Ball_Y_Pos <= Ball_Y_Center;
           Ball_X_Motion <= 0;
           Ball_Y_Motion <= 0;
           punch_flag <= 1'b0;
           miss_flag <= 1'b0;
           keep_moving <= 1'b0;
        end
      else if((((Ball_Y_Pos >= 255) && (Ball_Y_Pos <= 290)) && ((frame == 5'b00001) || (frame == 5'b00100)) || punch_flag) && !miss_flag) begin
               punch_flag <= 1'b1;
               Ball_X_Motion <= 30;
               Ball_Y_Motion <= 0;
               Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
               Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
           end
      else if(((((Ball_Y_Pos >= 230) && (Ball_Y_Pos <= 255)) || ((Ball_Y_Pos >= 290) && (Ball_Y_Pos <= 310))) && ((frame == 5'b00001) || (frame == 5'b00100)) || miss_flag) && !punch_flag) begin
             miss_flag <= 1'b1;
             Ball_X_Motion <= 5;
             Ball_Y_Motion <= 12;
             Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
             Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
       end
      else if(Ball_X_Pos <= 320)begin
               Ball_Y_Motion <= 20;
               Ball_Size <= 26;
               Ball_X_Motion <= -12;
               Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
             Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
             end
      else if(Ball_X_Pos <= 360)begin
             Ball_Y_Motion <= 17;
             Ball_Size <= 30;
             Ball_X_Motion <= -12;
             Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
             Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
           end
      else if(Ball_X_Pos <= 400)begin
               Ball_Y_Motion <= 12;
               Ball_Size <= 37;
               Ball_X_Motion <= -12;
               Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
             Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
             end
      else if(Ball_X_Pos <= 440)begin
             Ball_Y_Motion <= 9;
             Ball_Size <= 42;
             Ball_X_Motion <= -12;
             Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
             Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
           end
      else if(Ball_X_Pos <= 480)begin
               Ball_Y_Motion <= 8;
               Ball_Size <= 46;
               Ball_X_Motion <= -12;
               Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
             Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
             end
      else if(Ball_X_Pos <= 520)begin
               Ball_Y_Motion <= 6;
               Ball_Size <= 49;
               Ball_X_Motion <= -12;
               Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
             Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
           end
      else if(Ball_X_Pos <= 560)begin
             Ball_Y_Motion <= 4;
             Ball_Size <= 52;
             Ball_X_Motion <= -12;
             Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
             Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
           end
      else if(Ball_X_Pos <= 600)begin
             Ball_Y_Motion <= 2;
             Ball_Size <= 54;
             Ball_X_Motion <= -12;
             Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
             Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
           end
      else begin
               Ball_Y_Motion <= 1;
               Ball_Size <= 55;
               Ball_X_Motion <= -12;
               Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
                Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
             end
			
   end

			
   assign BallX = Ball_X_Pos;
  
   assign BallY = Ball_Y_Pos;
  
   assign BallS = Ball_Size;

   assign miss_f = miss_flag;

   assign perfect_f = punch_flag;

   assign keep_on = keep_moving;

endmodule

