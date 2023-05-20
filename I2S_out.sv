module i2s_out (input CLK, SCLK, LRCLK, 
					input [31:0] DIN, 
					output DOUT);
					
logic [31:0] dataL, dataR;

//wire DOUT to either left sample or right sample depending on value of LRCLK
//always_comb
//begin
//	if (!LRCLK)
//	begin
//	DOUT = dataL[31];
//	end
//	else
//	begin
//	DOUT = dataR[31];
//	end
//	
//end



always_ff @ (posedge SCLK)
begin
	
	//LRCLK low, left sample currently being transmitted on DOUT pin, right sample being loaded
	if (!LRCLK)
		begin
		dataL <= {dataL[30:0], 1'b0};
		dataR <= DIN;
		DOUT <= dataL[31];
		end
	//LRCLK high, right sample currently being transmitted on DOUT pin, left sample being loaded 
	if (LRCLK)
		begin
		dataR <= {dataR[30:0], 1'b0};
		dataL <= DIN;
		DOUT <= dataR[31];
		end
	
end


endmodule
