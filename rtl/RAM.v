//RAM block to hold 256-bits (8, 32-bit words)

module RAM #(parameter CHOOSE = 1)(

input	[31:0]	data_in,
input	[2:0]	address_in,
input			write_en,
input			clk,
output	[31:0]	data_out
);

reg [31:0]	MEMORY	[0:7];
reg	[31:0]	data_out_reg;

//simulation only initalize statement
`ifndef SYNTHESIS

initial begin
	if(CHOOSE == 1) begin
		MEMORY[0] = 32'hd898c296;
		MEMORY[1] = 32'hf4a13945;
		MEMORY[2] = 32'h2deb33a0;
		MEMORY[3] = 32'h77037d81;
		MEMORY[4] = 32'h63a440f2;
		MEMORY[5] = 32'hf8bce6e5;
		MEMORY[6] = 32'he12c4247;
		MEMORY[7] = 32'h6b17d1f2;
	end
	//0x47a2dcf8_7221ed74_a10df3da_be87133f_f4091278_764d0426_e024c340_6a3ca057
	else if(CHOOSE == 2) begin
		MEMORY[0] = 32'h6a3ca057;
		MEMORY[1] = 32'he024c340;
		MEMORY[2] = 32'h764d0426;
		MEMORY[3] = 32'hf4091278;
		MEMORY[4] = 32'hbe87133f;
		MEMORY[5] = 32'ha10df3da;
		MEMORY[6] = 32'h7221ed74;
		MEMORY[7] = 32'h47a2dcf8;
	end
	
	else if(CHOOSE == 3) begin
		MEMORY[0] = 32'h5bc3df7f;
		MEMORY[1] = 32'h20b6c36b;
		MEMORY[2] = 32'h19fae86d;
		MEMORY[3] = 32'h73125bc0;
		MEMORY[4] = 32'hcb34da82;
		MEMORY[5] = 32'hb32a621f;
		MEMORY[6] = 32'h7b1adc2c;
		MEMORY[7] = 32'h25626264;
	end
	
	else begin
		MEMORY[0] = 32'h00000003;
		MEMORY[1] = 32'h00000000;
		MEMORY[2] = 32'hffffffff;
		MEMORY[3] = 32'hfffffffb;
		MEMORY[4] = 32'hfffffffe;
		MEMORY[5] = 32'hffffffff;
		MEMORY[6] = 32'hfffffffd;
		MEMORY[7] = 32'h00000004;
	end
end //initial

`endif


always @(posedge clk) begin
  if(write_en)
    MEMORY[address_in] <= data_in;

  data_out_reg <= MEMORY[address_in];

end

assign data_out = data_out_reg;

endmodule 

