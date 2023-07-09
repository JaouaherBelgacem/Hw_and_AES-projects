library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity tb_vendingMV3_tb is
end tb_vendingMV3_tb;

architecture behave of tb_vendingMV3_tb is

  constant clk_period : time := 10 ns;

  signal Clock : std_logic := '0';
  signal Reset : std_logic := '1';
  signal euroIn : std_logic := '0';
  signal twentyCent : std_logic := '0';
  signal tee : std_logic := '0';
  signal coffee : std_logic := '0';
  signal An0 : std_logic_vector (7 downto 0) := (others => '0');
  signal Display : std_logic_vector (7 downto 0) := (others => '0');
  signal LED_s20 : std_logic := '0';
  signal LED_s40 : std_logic := '0';

begin
  uut: entity work.VendingM
    port map (
      Clock => Clock,
      Reset => Reset,
      euroIn => euroIn,
      twentyCent => twentyCent,
      tee => tee,
      coffee => coffee,
      An0 => An0,
      Display => Display,
      LED_s20 => LED_s20,
      LED_s40 => LED_s40
    );

  clk_process : process
  begin
    Clock <= '0';
    wait for clk_period/2;
    Clock <= '1';
    wait for clk_period/2;
  end process;

  stim_process : process
  begin
    -- Reset
    Reset <= '1';
    wait for clk_period;
    Reset <= '0';
    
    -- Insert 20 cents
    twentyCent <= '1'; 
    wait for clk_period;
    twentyCent <= '0'; 
    wait for clk_period;

    -- Select tee
    tee <= '1'; 
    wait for clk_period;
    tee <= '0'; 
    wait for clk_period;

    -- Insert euro
    euroIn <= '1'; 
    wait for clk_period;
    euroIn <= '0'; 
    wait for clk_period;

    -- Select coffee
    coffee <= '1'; 
    wait for clk_period;
    coffee <= '0'; 
    wait for clk_period;

    wait;
  end process;

end behave;

