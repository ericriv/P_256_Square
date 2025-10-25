
module Rad4_mul_256 (

input	[255:0]	x,
input	[255:0]	y,
input			clk,
input 			rst_n,
output			done,
output	[255:0]	out_low,
output	[255:0]	out_high);

reg 	[511:0] 	product;
reg 	[511:0] 	outReg;
reg 	[255:0] 	carry_pp;
reg 	[255:0] 	a;
reg 	[255:0] 	choose_a;
reg 	[255:0] 	choose_2a;
reg 				FF;		
reg					done_reg;
reg					fin_stall;

reg		[6:0]		counter;

wire	[255:0]		CSA1Sum;
wire 	[255:0]		CSA1Carry;

wire 	[255:0]		CSA2Sum;
wire 	[255:0]		CSA2Carry;

wire 	[255:0]		finalAdderSum;
wire 				finalAdderCout;

wire	[1:0]		carryAdderSum;
wire				carryAdderCout;


CSA #(.WIDTH(256)) CSA1(.x(product[511:256]), .y(choose_a), .z(choose_2a), .sum(CSA1Sum), .carry(CSA1Carry));
CSA #(.WIDTH(256)) CSA2(.x(carry_pp), .y(CSA1Sum), .z({CSA1Carry[254:0], 1'b0}), .sum(CSA2Sum), .carry(CSA2Carry));

CLA256 finalAdder(.A({1'b0, (product[1] & a[255]), CSA2Sum[255:2]}), .B({1'b0, (CSA1Carry[255] | CSA2Carry[255]), CSA2Carry[254:1]}), .Ci(FF), .S(finalAdderSum), .Cout(finalAdderCout), .Pout(), .Gout());

CPA #(.WIDTH(2)) carryAdder(.x(CSA2Sum[1:0]), .y({CSA2Carry[0], FF}), .cin(1'b0), .sum(carryAdderSum), .cout(carryAdderCout));


always @(posedge clk or negedge rst_n) begin

  if(!rst_n) begin
    product <= {{256{1'b0}}, y};	//initialize the product register with 0's and the multiplier
    carry_pp <= {256{1'b0}};
    a <= x;					//initialize a register with multiplicand
    outReg <= {512{1'b0}};
    FF <= 1'b0;
	done_reg <= 1'b0;
	counter <= 7'b0;
	fin_stall <= 1'b0;
  end //reset

  else begin
    if(counter == 127 && !done_reg) begin
		if(!fin_stall) begin
		  outReg <= {finalAdderSum, carryAdderSum, product[255:2]};
		  FF <= carryAdderCout;
		  fin_stall <= 1'b1;
		end
		else begin
		  outReg <= {finalAdderSum, outReg[255:0]};
		  done_reg <= 1'b1;
		end
	end
	
	else if(!done_reg)begin
		FF <= carryAdderCout; 
		product <= {1'b0, (product[1] & a[255]), CSA2Sum[255:2], carryAdderSum, product[255:2]};
		carry_pp <= {1'b0, (CSA1Carry[255] | CSA2Carry[255]), CSA2Carry[254:1]};
		counter <= counter + 7'b1;
	end
  end //else

end //always

always @(negedge clk or negedge rst_n) begin
    if(!rst_n) begin
      choose_a <= y[0] ? x : {256{1'b0}};
      choose_2a <= y[1] ? (x << 1) : {256{1'b0}};
    end
    else if(!fin_stall && !done_reg)begin
      choose_a <= product[0] ? a : {256{1'b0}};
      choose_2a <= product[1] ? (a << 1) : {256{1'b0}};
    end
end



assign out_low = outReg[255:0];
assign out_high = outReg[511:256];
assign done = done_reg;

endmodule 
