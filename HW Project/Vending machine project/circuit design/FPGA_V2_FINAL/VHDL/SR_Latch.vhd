entity SR_Latch is
	port (S,R: in bit;
		Q,Q1: inout bit);
end SR_Latch;

architecture behaviour of SR_Latch is
begin
	Q <= S nand Q1;
	Q1 <= R nand Q;
end;