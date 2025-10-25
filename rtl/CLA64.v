
module CLA64(A,B,Ci,S,Cout,Pout,Gout);

localparam n = 64; // 64 bit CLA

input [n-1:0] A;
input [n-1:0] B;
input Ci;

output [n-1:0] S;

output Cout;
output Pout;  // the whole block propagates from Cin to LSB to MSB
output Gout;  // predicte if the whole block generates at MSB 

/* CLA generator intermediate wires */
wire [3:0] P;  
wire [3:0] G; 
wire [3:1] C; 
 
/* Instantiate 4 CLA_4bit addter to generater corresponding signals */
CLA16 CLA0(.A(A[(n/4)-1:0]),.B(B[(n/4)-1:0]),.Ci(Ci),.S(S[(n/4)-1:0]),.Cout(),.Pout(P[0]),.Gout(G[0])); 
CLA16 CLA1(.A(A[2*(n/4)-1:(n/4)]),.B(B[2*(n/4)-1:(n/4)]),.Ci(C[1]),.S(S[2*(n/4)-1:(n/4)]),.Cout(),.Pout(P[1]),.Gout(G[1]));  
CLA16 CLA2(.A(A[3*(n/4)-1:2*(n/4)]),.B(B[3*(n/4)-1:2*(n/4)]),.Ci(C[2]),.S(S[3*(n/4)-1:2*(n/4)]),.Cout(),.Pout(P[2]),.Gout(G[2]));  
CLA16 CLA3(.A(A[4*(n/4)-1:3*(n/4)]),.B(B[4*(n/4)-1:3*(n/4)]),.Ci(C[3]),.S(S[4*(n/4)-1:3*(n/4)]),.Cout(),.Pout(P[3]),.Gout(G[3]));  

CLA_generator4 uut1(.P(P), .G(G), .C0(Ci), .C(C), .Pout(Pout), .Gout(Gout), .Cout(Cout)); 
 
endmodule 
 
