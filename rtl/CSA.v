
module CSA #(parameter WIDTH = 4) (
input 	[WIDTH-1:0] 	x,
input 	[WIDTH-1:0] 	y,
input 	[WIDTH-1:0] 	z,
output 	[WIDTH-1:0]	sum,
output	[WIDTH-1:0]	carry);

genvar i;
generate for(i = 0; i < WIDTH; i = i + 1)
  begin: FA_loop
    FA adder (
      .x(x[i]),
      .y(y[i]),
      .cin(z[i]),
      .out(sum[i]),
      .cout(carry[i]));
    end
endgenerate


endmodule
