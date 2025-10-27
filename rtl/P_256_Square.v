

module P_256_Square(
input 			clk,
input			rst_n,
input			ena,
input	[31:0]	a_din,
output			rdy,
output			a_addr,
output	[2:0]	d_addr,
output			d_wren,
output	[31:0]	d_dout
);
	
	//definition of states
	localparam		LOAD			= 4'b0000;
	localparam		LOAD_WAIT		= 4'b0001;
	localparam		LOAD_WAIT_2		= 4'b0010;
	localparam		LOAD_WAIT_3		= 4'b0011;
	localparam		MUL				= 4'b0100;
	localparam		MUL_WAIT		= 4'b0101;
	localparam		REDUCE			= 4'b0110;
	localparam		REDUCE_WAIT		= 4'b0111;
	localparam		WRITE			= 4'b1000;
	localparam		WRITE_WAIT		= 4'b1001;

	//wires
	wire 			mul_done;
	wire 			reduce_done;
	
	wire	[255:0]	mul_high;
	wire	[255:0]	mul_low;
	wire	[255:0]	reduce_out;
	
	//register
	reg		[3:0]	state;
	reg				mul_rst_n;
	reg				reduce_rst_n;
	reg		[2:0]	a_addr_reg;
	reg		[2:0]	d_addr_reg;
	reg				d_wren_reg;
	reg		[31:0]	d_dout_reg;
	reg		[255:0]	a_full;
	reg		[255:0]	square_low;
	reg		[255:0] square_high;
	reg		[255:0]	prod_full;
	reg				rdy_reg;
	
	//instantiations
	Rad4_mul_256 squarer(
	.x(a_full), 
	.y(a_full), 
	.clk(clk), 
	.rst_n(mul_rst_n), 
	.done(mul_done), 
	.out_low(mul_low), 
	.out_high(mul_high));
	
	P_256_Reducer reducer(
	);

	
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			state <= LOAD_WAIT;
			mul_rst_n <= 1'b1;
			reduce_rst_n <= 1'b1;
			a_addr_reg <= 3'b0;
			d_addr_reg <= 3'b0;
			d_wren_reg <= 1'b0;
			d_dout_reg <= {32{1'bX}};
			a_full <= {256{1'bX}};
			square_low <= {256{1'bX}};
			square_high <= {256{1'bX}};
			prod_full <= {256{1'bX}};
			rdy_reg <= 1'b0;
		end
		else if(ena) begin
			case(state)
				LOAD_WAIT: begin
					state <= LOAD_WAIT_2;
				end
				
				LOAD_WAIT_2: begin
					state <= LOAD_WAIT_3;
				end
				
				LOAD_WAIT_3: begin
					state <= LOAD;
				end
				
				LOAD: begin
					case(a_addr_reg)
						3'b000: begin
							a_full[31:0] <= a_din;
							ab_addr_reg <= ab_addr_reg + 3'b1;
							state <= LOAD_WAIT;
						end
						3'b001: begin
							a_full[63:32] <= a_din;
							ab_addr_reg <= ab_addr_reg + 3'b1;
							state <= LOAD_WAIT;
						end
						3'b010: begin
							a_full[95:64] <= a_din;
							ab_addr_reg <= ab_addr_reg + 3'b1;
							state <= LOAD_WAIT;
						end
						3'b011: begin
							a_full[127:96] <= a_din;
							ab_addr_reg <= ab_addr_reg + 3'b1;
							state <= LOAD_WAIT;
						end
						3'b100: begin
							a_full[159:128] <= a_din;
							ab_addr_reg <= ab_addr_reg + 3'b1;
							state <= LOAD_WAIT;
						end
						3'b101: begin
							a_full[191:160] <= a_din;
							ab_addr_reg <= ab_addr_reg + 3'b1;
							state <= LOAD_WAIT;
						end
						3'b110: begin
							a_full[223:192] <= a_din;
							ab_addr_reg <= ab_addr_reg + 3'b1;
							state <= LOAD_WAIT;
						end
						3'b111: begin
							a_full[255:224] <= a_din;
							ab_addr_reg <= ab_addr_reg + 3'b1;
							state <= MUL;
						end
					endcase
				end
				
				MUL: begin
					mul_rst_n <= 1'b0;
					state <= MUL_WAIT;
				end
				
				MUL_WAIT: begin
					mul_rst_n <= 1'b1;
					if(mul_done) begin
						square_low <= mul_low;
						square_high <= mul_high;
						state <= REDUCE;
					end
				end
				
				REDUCE: begin
					reduce_rst_n <= 1'b0;
					
				end
				
				default: begin
					state <= state;
				end
			endcase
		end
	end
	
	
	//assign statements
	assign	rdy = rdy_reg;
	assign	a_addr = a_addr_reg;
	assign	d_addr = d_addr_reg;
	assign	d_wren = d_wren_reg;
	assign	d_dout = d_dout_reg;



endmodule