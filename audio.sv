module audio ( input logic clk, enable,
			input logic [7:0] data_in1, data_in2,
			output logic[7:0] dout
					);



					
 always_comb
 begin
	if(enable)
		dout = data_in1;
	else
		dout = data_in2;
 end




endmodule
