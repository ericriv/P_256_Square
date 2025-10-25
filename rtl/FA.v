
module FA(

input	x,
input 	y,
input	cin,
output	out,
output	cout);

reg outReg;
reg coutReg;


always @(*) begin
outReg <= (x ^ y) ^ cin;
coutReg <= (x & y) | (x & cin) | (y & cin);
end

assign out = outReg;
assign cout = coutReg;


endmodule
