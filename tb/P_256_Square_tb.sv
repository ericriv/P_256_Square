

module P_256_Square_tb();

	localparam 		Gx = 256'h6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296;
	localparam		P = 256'hffffffff00000001000000000000000000000000ffffffffffffffffffffffff;


	logic 			clk;
	logic			rst_n;
	logic			ena;
	logic	[31:0]	a_din;
	
	wire			rdy;
	wire	[2:0]	a_addr;
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
	
	RAM #(.CHOOSE(1)) my_ram(
	.data_in(d_dout),
	.address_in(a_addr),
	.write_en(d_wren),
	.clk(clk),
	.data_out(a_din));



	initial begin
	clk = 0;
	rst_n = 1;
	ena = 0;
	
	reset();
	compute_square();
	#20 $stop;
	end 
	
	
	always
	#5 clk = ~clk;
	
	
	//=======================//
	//   Task Declarations   //
	//======================//
	
	task automatic reset();
		rst_n = 1;
		@(negedge clk) rst_n = 0;
		repeat(2) @(negedge clk);
		rst_n = 1;
	endtask
	
	task automatic compute_square();
		logic	[512:0]		temp;
		logic	[255:0]		check;
		@(negedge clk);
		ena = 1;
		@(rdy);
		ena  = 0;
		temp = Gx * Gx;
		check = temp % P;
		$display("Square value: %0h", temp);
		$display("Check value: %0h", check);
	endtask
	

endmodule