module register_1 (
    input logic clk, clk2, reset,
    output logic flag
);



always_comb begin
	if (reset)
		flag = 0;
	if(clk)
    flag =1 ;
	 else if(clk2)
	 flag = 0;
	 else
	 flag = 0;
end


endmodule
