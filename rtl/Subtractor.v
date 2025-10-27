
module Subtractor #(parameter WIDTH = 32)(
input  [WIDTH-1:0] x,
input  [WIDTH-1:0] y,
input              bin,
output [WIDTH-1:0] diff,
output             bout
);

    wire carry_out;

    
    CPA #(.WIDTH(WIDTH)) adder (
        .x(x),
        .y(~y),
        .cin(~bin),
        .sum(diff),
        .cout(carry_out)
    );
	
    assign bout = ~carry_out;

endmodule
