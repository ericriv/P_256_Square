/* 4-bit lookahead carry generator */
module CLA_generator4(P,G,C0,C,Pout,Gout,Cout);
 
input [3:0] P; 	// Propagation signals 
input [3:0] G;	// Generation signals
input C0;	// the carry in from the LSB 

/* Intermediate carries */
output [3:1] C; // predicting the internal carries within each 4-bit block  
/* Block signal generation */
output Pout;  	// produces g, p signals for 4-bit blocks 
output Gout;  
output Cout;  	// predicts the carry-in signals c4,c8,c12 for the blocks  

assign C[1] = G[0] | C0 & P[0];
assign C[2] = G[1] | G[0] & P[1] | C0 & P[0] & P[1];
assign C[3] = G[2] | G[1] & P[2] | G[0] & P[1] & P[2] | C0 & P[0] & P[1] & P[2];
assign Pout = P[0] & P[1] & P[2] & P[3]; // The block is propagatable only each stage is propagatable.
assign Gout = G[3] | G[2] & P[3] | G[1] & P[2] & P[3] | G[0] & P[1] & P[2] & P[3]; // the block only generate : 1) the MSB generates + 2) the 2nd MSB generates and the MSB propagates + repeat until LSB generates situation

assign Cout = Gout | Pout & C0; // Carry out only happens when the block generates or the block propogate the Cin from the LMB to MSB

endmodule 
 