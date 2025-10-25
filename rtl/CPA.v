
module CPA #(parameter WIDTH = 32)(
input 	[WIDTH-1:0] 	x,
input 	[WIDTH-1:0] 	y,
input 			cin,
output	[WIDTH-1:0]	sum,
output 			cout
);

	wire [WIDTH-1:0] carry;

	FA adder0(.x(x[0]), .y(y[0]), .cin(cin), .out(sum[0]), .cout(carry[0]));

	genvar i;
	generate for(i = 1; i < WIDTH; i = i + 1)
	  begin: adders
		FA adderX (
		  .x(x[i]),
		  .y(y[i]),
		  .cin(carry[i-1]),
		  .out(sum[i]),
		  .cout(carry[i])
		);
		end
	endgenerate 

	assign cout = carry[WIDTH-1];

endmodule 