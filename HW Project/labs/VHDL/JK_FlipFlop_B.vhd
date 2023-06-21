entity JK_FlipFlop_B is 
	port(JK: in bit_vector(1 downto 0);
		Clk: in bit;
		Q, Q1: out bit);
end entity;

architecture behaviour of JK_FlipFLop_B is
begin
	with (JK) select Q <=
	'1' when ("10"),
	'0' when ("01"),
	--'1' when ("01"),
	--Q <= '0' when ("01");
	--Q1<='0' when others,
	'0' when others;
	with (JK) select Q1 <=
	'0' when "10",
	'1' when "01",
	'0' when others;
end behaviour;