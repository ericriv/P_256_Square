
module CLA16(A,B,Ci,S,Cout,Pout,Gout);

localparam n = 16; // 16 bit CLA

input [n-1:0] A;
input [n-1:0] B;
input Ci;

output [n-1:0] S; // Computes the sum bits  

output Cout; 
output Pout;  // the whole block propagates from Cin to LSB to MSB
output Gout;  // predicte if the whole block generates at MSB 

/* CLA generator wires */
wire [3:0] P;  
wire [3:0] G;  
wire [3:1] C;  

/* Instantiate 4 CLA_4bit addter to generater corresponding signals */
CLA4 CLA0(.A(A[(n/4)-1:0]),.B(B[(n/4)-1:0]),.Ci(Ci),.S(S[(n/4)-1:0]),.Cout(),.Pout(P[0]),.Gout(G[0])); 
CLA4 CLA1(.A(A[2*(n/4)-1:(n/4)]),.B(B[2*(n/4)-1:(n/4)]),.Ci(C[1]),.S(S[2*(n/4)-1:(n/4)]),.Cout(),.Pout(P[1]),.Gout(G[1]));  
CLA4 CLA2(.A(A[3*(n/4)-1:2*(n/4)]),.B(B[3*(n/4)-1:2*(n/4)]),.Ci(C[2]),.S(S[3*(n/4)-1:2*(n/4)]),.Cout(),.Pout(P[2]),.Gout(G[2]));  
CLA4 CLA3(.A(A[4*(n/4)-1:3*(n/4)]),.B(B[4*(n/4)-1:3*(n/4)]),.Ci(C[3]),.S(S[4*(n/4)-1:3*(n/4)]),.Cout(),.Pout(P[3]),.Gout(G[3]));  

CLA_generator4 uut1(.P(P), .G(G), .C0(Ci), .C(C), .Pout(Pout), .Gout(Gout), .Cout(Cout));
 
endmodule 
  