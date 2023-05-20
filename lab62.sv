//-------------------------------------------------------------------------
//                                                                       --
//                                                                       --
//      For use with ECE 385 Lab 62                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab62 (

      ///////// Clocks /////////
      input     MAX10_CLK1_50, 

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 

);




logic Reset_h, vssig, blank, sync, VGA_Clk;
 
 //assign LEDR[0] = blank;

//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs;
	logic [1:0] hundreds;
	logic [9:0] drawxsig, drawysig, ballxsig, ballysig, ballsizesig;
	logic [7:0] Red, Blue, Green;
	logic [7:0] keycode;

//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
	
	
//=======================================================
//  Audio coding
//=======================================================	

	logic [1:0] aud_mclk_ctr; 
	logic i2c_serial_scl_in, i2c_serial_sda_in, i2c_serial_scl__oe, i2c_serial_sda_oe;

	assign ARDUINO_IO[3]  = aud_mclk_ctr[1];
	always_ff @(posedge MAX10_CLK1_50)
		begin
			aud_mclk_ctr <= aud_mclk_ctr+1;
	end

	assign i2c_serial_scl_in = ARDUINO_IO[15] ;
	assign ARDUINO_IO[15] = i2c_serial_scl__oe ? 1'b0 : 1'bz;

	assign i2c_serial_sda_in = ARDUINO_IO[14];
	assign ARDUINO_IO[14] = i2c_serial_sda_oe ? 1'b0 : 1'bz;
	
	

	assign ARDUINO_IO[2]= ARDUINO_IO[1];
	assign ARDUINO_IO[1]= sound_out;

	logic SCLK, LRCLK;
	assign LRCLK = ARDUINO_IO[4];
	assign SCLK = ARDUINO_IO[5];
	
	
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	
	//HEX drivers to convert numbers to HEX output
	HexDriver hex_driver4 (hex_num_4, HEX4[6:0]);
	assign HEX4[7] = 1'b1;
	
	HexDriver hex_driver3 (hex_num_3, HEX3[6:0]);
	assign HEX3[7] = 1'b1;
	
	HexDriver hex_driver1 (hex_num_1, HEX1[6:0]);
	assign HEX1[7] = 1'b1;
	
	HexDriver hex_driver0 (hex_num_0, HEX0[6:0]);
	assign HEX0[7] = 1'b1;
	
	//fill in the hundreds digit as well as the negative sign
	assign HEX5 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	assign HEX2 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	
	
	//Assign one button to reset
	assign {Reset_h}=~ (KEY[0]);
	
	


logic  sound_out;	
logic[18:0] nearMiss_counter, perfecthit_counter;
logic [7:0] wavedata_out;

// COUNTERS FOR EACH SPECIFIC AUDIO SAMPLE
logic [16:0] score1, score2, scoreFinal;

	always_ff @(posedge LRCLK)
	begin
		
		if(Reset_h)begin
			nearMiss_counter <= 0;
			score1 <= 0;
			end
		else if((nearMiss_counter < 15'b100010011101110) && miss_flag) begin
			nearMiss_counter <= nearMiss_counter + 1'b1;
			if(nearMiss_counter == 15'b001100000000000)
				score1 <= score1 + 1'b1;
		end
		else
			nearMiss_counter = 0;
	end	

always_ff @(posedge LRCLK)
begin
	
	if(Reset_h)begin
		perfecthit_counter <= 0;
		score2 <= 0;
		end
	else if((perfecthit_counter < 15'b101001101101000) && (perfect_flag || audio_flag)) begin
		perfecthit_counter <= perfecthit_counter + 1'b1;
		if(perfecthit_counter == 15'b000000000000001)
			score2 <= score2 + 4'd10;
	end
	else
		perfecthit_counter= 0;
end		
	

logic [7:0] data_Out, data_Out2, final_output;

logic [31:0] wave_audio;

// AUDIO SAMPLES

nearmiss_ram nearmiss_sound(.read_address(nearMiss_counter), .Clk(MAX10_CLK1_50), .data_Out(data_Out));

PerfectHit_ram perfect(.read_address(perfecthit_counter), .Clk(MAX10_CLK1_50), .data_Out(data_Out2));

assign wave_audio = {1'b0, final_output,23'b00000000000000000000000};


// I2S MODULE

i2s_out audio_out(.CLK(MAX10_CLK1_50), .SCLK(SCLK), .LRCLK(LRCLK), .DIN(wave_audio), .DOUT(sound_out));


audio out_to_FPGA(.enable(miss_flag),.data_in1(data_Out), .data_in2(data_Out2), .dout(final_output));


//=======================================================
//  Game Time coding
//=======================================================
 
logic [32:0] Total_time = 33'b110001001011001000000001000000000; 

logic [32:0] game_clock;
logic timer_done;

 always_ff @(posedge MAX10_CLK1_50)begin
 	if(Reset_h || (StartScreen != 2'b00))begin
		game_clock <= 0;
		timer_done <= 1'b0;
		scoreFinal <= 0;
		end
	else if ((game_clock == Total_time) || timer_done)begin
		timer_done <= 1'b1;
		end
	else begin
	//	timer_done = 1'b0;
		game_clock <= game_clock + 1'b1;
	end

	scoreFinal <= score1 + score2;
	
 end
// LAB 6 MAIN MODULE CONNECTING COMPONENTS

lab62soc u0 (
.clk_clk                           (MAX10_CLK1_50),  //clk.clk
.reset_reset_n                     (1'b1),           //reset.reset_n
.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
.key_external_connection_export    (KEY),            //key_external_connection.export


//Audio
.i2c0_sda_in								(i2c_serial_sda_in),
.i2c0_scl_in								(i2c_serial_scl_in),
.i2c0_sda_oe								(i2c_serial_sda_oe),
.i2c0_scl_oe								(i2c_serial_scl__oe),


//SDRAM
.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
.sdram_wire_ba(DRAM_BA),                             //.ba
.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
.sdram_wire_cke(DRAM_CKE),                           //.cke
.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
.sdram_wire_dq(DRAM_DQ),                             //.dq
.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

//USB SPI	
.spi0_SS_n(SPI0_CS_N),
.spi0_MOSI(SPI0_MOSI),
.spi0_MISO(SPI0_MISO),
.spi0_SCLK(SPI0_SCLK),

//USB GPIO IRQ BUT WE NAMED IT IQR
.usb_rst_export(USB_RST),
.usb_iqr_export(USB_IRQ),
.usb_gpx_export(USB_GPX),

//LEDs and HEX
.hex_digits_export({hex_num_4, hex_num_3, hex_num_1, hex_num_0}),
.leds_export({hundreds, signs,10'b0000000000 /*LEDR*/}),
.keycode_export(keycode)

);


/************************************
		OBJECT TO PUNCH
*************************************
*/

logic miss_flag, perfect_flag, draw_ball;
ball ball_obj(.Reset(Reset_h), .frame_clk(VGA_VS), .BallEN(spawn_enable && !draw_combo), .frame(Joe_EN), .BallX(ballxsig), .BallY(ballysig), .BallS(ballsizesig), .miss_f(miss_flag), .perfect_f(perfect_flag), .keep_on(draw_ball));


/************************************
		VGA CONTROLLER
*************************************
*/

vga_controller vga(.Clk(MAX10_CLK1_50), .Reset(Reset_h), .hs(VGA_HS), .vs(VGA_VS), .pixel_clk(VGA_Clk), .blank(blank), .sync(sync), .DrawX(drawxsig), .DrawY(drawysig));

/************************************
		COLOR MAPPER
*************************************
*/

logic [9:0] JoeX, JoeY;

assign JoeX = 10'b1100100;
assign JoeY = 10'b10100110;

color_mapper cmap(.blank(blank),
 .VGA_Clk(VGA_Clk),
 .BallEN(draw_ball || draw_combo),
 .activate(activate),
 .JoeX(JoeX),
 .JoeY(JoeY),
 .enable(Joe_EN),
 .start(StartScreen),
 .score(scoreFinal),
 .end_screen(timer_done),
 .DrawX(drawxsig),
 .DrawY(drawysig),
 .BallX(ballxsig),
 .BallY(ballysig),
 .BallS(ballsizesig),
 .BallX2(ballxsig2),
 .BallY2(ballysig2),
 .BallS2(ballsizesig2),
 .BG_R(BG_R),
 .BG_G(BG_G),
 .BG_B(BG_B),
 .Red(VGA_R),
 .Green(VGA_G),
 .Blue(VGA_B));

// Main file for all animations and sprite drawings with KARATE JOE

/************************************
		FRAMES WITH CLOCK
*************************************
*/
logic [1:0] HIT3;

always_ff @(posedge MAX10_CLK1_50) begin
	if (Reset_h) begin
		HIT3 <= 2'b0;
	end 
	else begin
		if (J_Press == 1'b1) 
			HIT3 <= HIT3 + 1;
		
	end
end

logic RightPunch_EN;

always_comb begin
	if(HIT3 == 2'b11) begin
		RightPunch_EN = 1'b1;
	end else begin
		RightPunch_EN = 1'b0;
	end
end

logic [2:0] frame_ctr;
logic fps_clk;

logic fps_60;
int fps_60_counter;

always_ff @(posedge MAX10_CLK1_50)
begin
    if(Reset_h)
        fps_60_counter <= 0;
    else if (fps_60_counter == 833333)
    begin
        fps_60 <= 1'b1;
        fps_60_counter <= 0;
    end
    else
    begin
        fps_60 <=1'b0; 
        fps_60_counter <= fps_60_counter +1;
    end
end



always_ff @(posedge MAX10_CLK1_50) begin
	if (Reset_h) begin
		frame_ctr <= 3'b0;
	end else begin
		if ((drawxsig == 10'b1100011111) && (drawysig == 10'b1000001100)) 
			frame_ctr <= frame_ctr + 1;
		
	end
end

always_comb begin
	if(frame_ctr == 3'b111 ) begin
		fps_clk = 1'b1;
	end else begin
		fps_clk = 1'b0;
	end
end


/************************************
		BACKGROUND SYSTEM
*************************************
*/

Background BG_ctrl(.Clk(fps_clk), .Reset(Reset_h), .BG_EN(BG_EN));
logic BG_EN;

logic [3:0] BG_R, BG_G, BG_B;
Background1_example back1(.DrawX(drawxsig), .DrawY(drawysig), .vga_clk(VGA_Clk), .blank(blank), .enable(BG_EN), .red(BG_R), .green(BG_G), .blue(BG_B));


/************************************
		ANIMATION SYSTEM
*************************************
*/

logic J_Press, K_Press;
logic [3:0] Joe_EN;
//logic flag;

always_comb begin
	if(keycode == 8'h04) 
		begin
			J_Press = 1'b1;
			K_Press = 1'b0;
		end
	else if (keycode == 8'h07)
		begin
			K_Press = 1'b1;
			J_Press = 1'b0;
		end
	else
		begin
			K_Press = 1'b0;
			J_Press = 1'b0;
		end
		
end

logic temp;

assign temp = (Joe_EN == 4'h0) && (J_Press || K_Press);

ISDU animate(.Clk(fps_clk || temp),
			 .PunchEN(RightPunch_EN),
			 .J_Press(J_Press),
			 .K_Press(K_Press),
			 .frame(Joe_EN));



logic [1:0] StartScreen;

StartScreen start(.Clk(start_clk || (J_Press && (StartScreen == 2'b01))), .Reset(Reset_h), .J_Press(J_Press), .frame(StartScreen));


logic [6:0] start_ctr;
logic start_clk;

always_ff @(posedge MAX10_CLK1_50) begin
	if (Reset_h) begin
		start_ctr <= 4'b0;
	end else begin
		if ((drawxsig == 10'b1100011111) && (drawysig == 10'b1000001100)) 
			start_ctr <= start_ctr + 1;
		
	end
end

always_comb begin
	if(start_ctr == 7'b1111111 ) begin
		start_clk = 1'b1;
	end else begin
		start_clk = 1'b0;
	end
end


/************************************
		OBJECT SPAWN TIMINGS
*************************************
*/
logic [6:0] spawn_timer;
logic [3:0] combo_counter;
logic spawn_enable, combo_enable;
logic change;

always_ff @(posedge MAX10_CLK1_50) begin
	if (Reset_h) begin
		spawn_timer <= 7'b000000;
		combo_counter <= 4'b0000;
		change <= 1'b0;
	end else begin
		// FIRST 
		if (((drawxsig == 10'b1100011111) && (drawysig == 10'b1000001100)) && !change)
		begin
			spawn_timer <= spawn_timer + 1;
			if(spawn_timer == 7'b1111111) begin
				combo_counter <= combo_counter + 1;
				if(combo_counter == 4'b1111)begin
					combo_enable <= 1'b1;
					change <= 1'b1;
				end
				else
					spawn_enable <= 1'b1;
			end
			else begin
				combo_enable <= 1'b0;
				spawn_enable <= 1'b0;
			end
		end
		
		// SECOND FORM
		else if(((drawxsig == 10'b1100011111) && (drawysig == 10'b1000001100)) && change)begin
			spawn_timer <= spawn_timer + 1;
			if(spawn_timer == 7'b1111111) begin
				combo_counter <= combo_counter + 1;
				if(combo_counter == 4'b1111)begin
					combo_enable <= 1'b1;
					change <= 1'b0;
					end
				else if(spawn_timer[1] == 1'b1)
					spawn_enable <= 1'b1;
			end
			else begin
				combo_enable <= 1'b0;
				spawn_enable <= 1'b0;
			end
		end
	end
end


logic [9:0] ballxsig2, ballysig2, ballsizesig2;
logic draw_combo, activate;	  
logic audio_flag;

combo ball_combo( .Reset(Reset_h), .frame_clk(VGA_VS), .audio_flag1(audio_flag), .BallEN(combo_enable && !draw_ball), .frame(Joe_EN), .BallX(ballxsig2), .BallY(ballysig2), .BallS(ballsizesig2), .keep_on(draw_combo), .activate(activate));

endmodule


