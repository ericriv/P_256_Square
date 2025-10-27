

module P_256_Reducer(
input				clk,
input				rst_n,
input				ena,
input	[255:0]		a_high,
input	[255:0]		a_low,
output				rdy,
output	[255:0]		reduced_out
);

	
	//definition of states
	localparam		LOAD 		= 2'b00;
	localparam		FOLD 		= 2'b01;
	localparam		CARRY_PROP 	= 2'b10;
	localparam		FINISH		= 2'b11;
	
	//wires
	wire		[63:0]	add_sum;
	wire		[63:0]	sub_diff;
	wire				add_cout;
	wire				sub_bout;
	
	
	//registers
	reg			[63:0]	accum	[0:15];
	
	reg			[63:0]	add_x;
	reg			[63:0]	add_y;
	
	reg			[63:0]	sub_x;
	reg			[63:0]	sub_y;
	
	reg			[63:0]	carry;
	
	reg					rdy_reg;
	reg					reduced_out_reg;
	
	reg			[3:0]	counter;
	reg			[4:0] 	i;
	
	//instantiations
	CPA #(.WIDTH(64)) my_add(.x(add_x),
	.y(add_y),
	cin(1'b0),
	.sum(add_sum),
	.cout(add_cout));
	
	Subtractor #(.WIDTH(64)) my_sub(.x(sub_x),
	.y(sub_y),
	.bin(1'b0),
	.diff(sub_diff),
	.bout(sub_bout));
	
	
	always @(posedge clk or negedge rst_n) begin
	
		if(!rst_n) begin
			for(i = 0; i < 16; i = i + 1)
				accum[i] <= 64'b0;
			add_x <= 64'b0;
			add_y <= 64'b0;
			sub_x <= 64'b0;
			sub_y <= 64'b0;
			carry <= 64'b0;
			counter <= 4'b0;
		end
		
		else if(ena) begin
			
		end
	
	end
	
	//assign statements
	assign rdy = rdy_reg;
	assign reduced_out = reduced_out_reg;
	
	

endmodule
