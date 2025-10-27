

module P_256_Reducer(
input				clk,
input				rst_n,
input				ena,
input	[255:0]		a_high,
input	[255:0]		a_low,
output				rdy,
output	[255:0]		reduce_out
);

	
	//definition of states
	localparam		LOAD 			= 3'b000;
	localparam		FOLD 			= 3'b001;
	localparam		FOLD_WAIT 		= 3'b010;
	localparam		CARRY_PROP 		= 3'b011;
	localparam		CARRY_PROP_WAIT = 3'b100;
	localparam		FINISH			= 3'b101;
	localparam		DONE			= 3'b110;
	
	//wires
	wire		[63:0]	add_sum_1;
	wire		[63:0]	add_sum_2;
	wire		[63:0]	sub_diff_1;
	wire		[63:0]	sub_diff_2;
	
	
	//registers
	reg			[63:0]	accum	[0:15];
	
	reg			[63:0]	add_x_1;
	reg			[63:0]	add_x_2;
	reg			[63:0]	add_y_1;
	reg			[63:0]	add_y_2;
	
	reg			[63:0]	sub_x_1;
	reg			[63:0]	sub_x_2;
	reg			[63:0]	sub_y_1;
	reg			[63:0]	sub_y_2;
	
	reg			[2:0]	state;
	
	reg			[63:0]	carry;
	
	reg					rdy_reg;
	reg			[255:0]	reduced_out_reg;
	
	reg			[4:0] 	i;
	reg			[3:0]	carry_count;
	reg			[3:0]	fold_count;
	
	//instantiations
	CPA #(.WIDTH(64)) my_add_1(.x(add_x_1),
	.y(add_y_1),
	.cin(1'b0),
	.sum(add_sum_1),
	.cout());
	
	CPA #(.WIDTH(64)) my_add_2(.x(add_x_2),
	.y(add_y_2),
	.cin(1'b0),
	.sum(add_sum_2),
	.cout());
	
	Subtractor #(.WIDTH(64)) my_sub_1(.x(sub_x_1),
	.y(sub_y_1),
	.bin(1'b0),
	.diff(sub_diff_1),
	.bout());
	
	Subtractor #(.WIDTH(64)) my_sub_2(.x(sub_x_2),
	.y(sub_y_2),
	.bin(1'b0),
	.diff(sub_diff_2),
	.bout());
	
	
	always @(posedge clk or negedge rst_n) begin
	
		if(!rst_n) begin
			for(i = 0; i < 16; i = i + 1)
				accum[i] <= 64'b0;
			add_x_1 <= 64'b0;
			add_x_2 <= 64'b0;
			add_y_1 <= 64'b0;
			add_y_2 <= 64'b0;
			sub_x_1 <= 64'b0;
			sub_x_2 <= 64'b0;
			sub_y_1 <= 64'b0;
			sub_y_2 <= 64'b0;
			carry <= 64'b0;
			state <= LOAD;
			rdy_reg <= 1'b0;
			reduced_out_reg <= 256'b0;
			carry_count <= 4'b0;
			fold_count <= 4'b0;
		end
		
		else if(ena) begin
			case(state)
			
				LOAD: begin
					accum[0] <= {32'b0, a_low[31:0]};
					accum[1] <= {32'b0, a_low[63:32]};
					accum[2] <= {32'b0, a_low[95:64]};
					accum[3] <= {32'b0, a_low[127:96]};
					accum[4] <= {32'b0, a_low[159:128]};
					accum[5] <= {32'b0, a_low[191:160]};
					accum[6] <= {32'b0, a_low[223:192]};
					accum[7] <= {32'b0, a_low[255:224]};
					
					accum[8] <= {32'b0, a_high[31:0]};
					accum[9] <= {32'b0, a_high[63:32]};
					accum[10] <= {32'b0, a_high[95:64]};
					accum[11] <= {32'b0, a_high[127:96]};
					accum[12] <= {32'b0, a_high[159:128]};
					accum[13] <= {32'b0, a_high[191:160]};
					accum[14] <= {32'b0, a_high[223:192]};
					accum[15] <= {32'b0, a_high[255:224]};
					
					state <= FOLD;
				end
				
				FOLD: begin
					add_x_1 <= accum[fold_count];			//A[i] += A[8+i]
					add_y_1 <= accum[fold_count + 4'd8];
						
					add_x_2 <= accum[fold_count + 4'd7];	//A[i+7] += A[8+i]
					add_y_2 <= accum[fold_count + 4'd8];
						
					sub_x_1 <= accum[fold_count + 4'd6];	//A[i+6] -= A[8+i]
					sub_y_1 <= accum[fold_count + 4'd8];
						
					sub_x_2 <= accum[fold_count + 4'd3];	//A[i+3] -= A[8+i]
					sub_y_2 <= accum[fold_count + 4'd8];
						
					state <= FOLD_WAIT;
				end
				
				FOLD_WAIT: begin
					accum[fold_count] <= add_sum_1;			//A[i] += A[8+i]
					accum[fold_count + 4'd7] <= add_sum_2;	//A[i+7] += A[8+i]
					accum[fold_count + 4'd6] <= sub_diff_1;	//A[i+6] -= A[8+i]
					accum[fold_count + 4'd3] <= sub_diff_2;	//A[i+3] -= A[8+i]
					accum[fold_count + 4'd8] <= 64'b0;		//A[i+8] = 0
					
					fold_count <= fold_count + 4'b1;
					state <= CARRY_PROP;
				end
				
				CARRY_PROP: begin
					add_x_1 <= accum[carry_count];
					add_y_1 <= carry;
					state <= CARRY_PROP_WAIT;
				end
				
				CARRY_PROP_WAIT: begin
					accum[carry_count] <= {32'b0, add_sum_1[31:0]};
					carry <= {32'b0, add_sum_1[63:32]};
					if(carry_count == 4'd15) begin
						carry_count <= 4'b0;
						if(fold_count == 4'd15) begin
							fold_count <= 4'b0;
							state <= FINISH;
						end
						else begin
							fold_count <= fold_count + 4'b1;
							state <= FOLD;
						end
					end
					else begin
						carry_count <= carry_count + 4'b1;
						state <= CARRY_PROP;
					end
				end
				
				FINISH: begin
					reduced_out_reg[31:0] <= accum[0];
					reduced_out_reg[63:32] <= accum[1];
					reduced_out_reg[95:64] <= accum[2];
					reduced_out_reg[127:96] <= accum[3];
					reduced_out_reg[159:128] <= accum[4];
					reduced_out_reg[191:160] <= accum[5];
					reduced_out_reg[223:192] <= accum[6];
					reduced_out_reg[255:224] <= accum[7];
					state <= DONE;
				end
				
				DONE: begin
					rdy_reg <= 1'b1;
					state <= DONE;
				end
			
			endcase
		end
	
	end
	
	//assign statements
	assign rdy = rdy_reg;
	assign reduce_out = reduced_out_reg;
	
	

endmodule
