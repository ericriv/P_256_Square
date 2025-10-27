

module P_256_Square_tb();


	logic 			clk;
	logic			rst_n;
	logic			ena;
	logic	[31:0]	a_din;
	
	wire			rdy;
	wire			a_addr;
	wire	[2:0]	d_addr;
	wire			d_wren;
	wire	[31:0]	d_dout;
	
	P_256_Square my_square(
	.clk,
	.rst_n,
	.ena,
	.a_din,
	.rdy,
	.a_addr,
	.d_addr,
	.d_wren,
	.d_dout);



	initial begin
	#20 $stop;
	end 

endmodule