
module GPFA(x,y,ci,s,p,g);

input x;
input y;
input ci;
output s;
output p;
output g;
 
assign g = x * y; // iff x + y >= r
assign p = x ^ y; // iff x + y = r - 1
assign s = p ^ ci ;  // sum = x ^ y ^ c = p ^ ci
endmodule 

/* delay : 1ns (g,p) : produces g, p signals for each bits  (1 gate levels) */