module CLA4(A,B,Ci,S,Cout,Pout,Gout);
localparam n = 4; // 4 bit CLA
input [n-1:0] A;
input [n-1:0] B;
input Ci;
output [n-1:0] S;
output Cout; 
output Pout;  // the whole block propagates from Cin to LSB to MSB
output Gout;  // predicte if the whole block generates at MSB 

/* CLA generator wires */
wire [3:0] P;  
wire [3:0] G;  
wire [3:1] C; 
 

GPFA GPFA0(.x(A[0]),.y(B[0]),.ci(Ci),.s(S[0]),.p(P[0]),.g(G[0]));
GPFA GPFA1(.x(A[1]),.y(B[1]),.ci(C[1]),.s(S[1]),.p(P[1]),.g(G[1]));
GPFA GPFA2(.x(A[2]),.y(B[2]),.ci(C[2]),.s(S[2]),.p(P[2]),.g(G[2]));
GPFA GPFA3(.x(A[3]),.y(B[3]),.ci(C[3]),.s(S[3]),.p(P[3]),.g(G[3]));

CLA_generator4 uut0(.P(P), .G(G), .C0(Ci), .C(C), .Pout(Pout), .Gout(Gout), .Cout(Cout)); 

endmodule 

/* delay : 2ns(Pout,Gout) + 2ns (C)  + 1ns (S)  + 2ns(Cout)*/ 
