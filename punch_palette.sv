module punch_palette (
	input logic [3:0] index,
	output logic [7:0] red, green, blue
);

localparam [0:15][11:0] palette = {
	{8'h0, 8'h0, 8'h0},
	{8'h7, 8'hA, 8'hD},
	{8'h0, 8'h0, 8'h0},
	{8'h5, 8'h7, 8'h9},
	{8'h0, 8'h3, 8'h1},
	{8'hB, 8'hF, 8'hF},
	{8'h1, 8'h1, 8'h2},
	{8'h2, 8'hD, 8'h6},
	{8'h3, 8'h5, 8'h6},
	{8'h0, 8'h3, 8'h1},
	{8'h0, 8'h5, 8'h2},
	{8'h6, 8'h9, 8'hB},
	{8'h9, 8'hD, 8'hE},
	{8'hC, 8'hF, 8'hF},
	{8'h0, 8'h2, 8'h0},
	{8'h2, 8'h3, 8'h4}
};

assign {red, green, blue} = palette[index];

endmodule
