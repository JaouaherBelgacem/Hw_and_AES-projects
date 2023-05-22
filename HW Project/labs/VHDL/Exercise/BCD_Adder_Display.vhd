entity BCD_Adder_Display is
	port(A,B: in bit_vector(3 downto 0);
		F: out bit_vector( 6 downto 0);
		C: out bit);
end BCD_Adder_Display;

architecture behavioral of BCD_Adder_Display is
	signal So: bit_vector(3 downto 0);
	component RCA
		port( A,B: in bit_vector(3 downto 0):
			S: out bit_vector(3 downto 0);
			Co: out bit);
	end component;
	component BCD_Decoder
		port (ABCD: in bit_vector(3 downto 0);
			F: out bit_vector(6 downto 0));
	end component;
begin

U1: RCA port map(A => A, B => B);
U2: RCA port map(A(0),B(0) => '0', A(1),B(1) => C , A(2),B(2) => C, A(3),B(3) => '0');
C <= (S(3) and S(2)) or (S(3) and S(1)) or Co;
U3: BCD_Decoder port map(