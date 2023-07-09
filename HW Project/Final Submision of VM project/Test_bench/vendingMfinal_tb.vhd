library IEEE;
use IEEE.std_logic_1164.all;

entity vendingM_tb is
end entity;

architecture Behavioral of vendingM_tb is

  component vendingM is
    port (
      Clock, Reset: in std_logic;
      euroIn, twentyCent, tee, coffee: in std_logic;
      drinksChoice: out std_logic_vector(1 downto 0);
      balance, returnAmount: out std_logic_vector(3 downto 0);
      DispenseD: out std_logic
    );
  end component;


  -- Declare necessary signals for test bench
  signal clk, reset, euroIn, twentyCent, tee, coffee: std_logic;
  signal drinksChoice: std_logic_vector(1 downto 0);
  signal balance, returnAmount: std_logic_vector(3 downto 0);
  signal DispenseD: std_logic;


begin

   -- Instantiate the module under test
  uut: vendingM
    port map (
      Clock => clk,
      Reset => reset,
      euroIn => euroIn,
      twentyCent => twentyCent,
      tee => tee,
      coffee => coffee,
      drinksChoice => drinksChoice,
      balance => balance,
      returnAmount => returnAmount,
      DispenseD => DispenseD
    );


  -- Clock process for generating a clock signal
  Stimulus_process: process
  begin
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
  end process;

  -- Stimulus process for applying inputs and observing outputs
  process
  begin
    -- Initialize inputs
    reset <= '1';
    wait for 10 ns;
    reset <= '0';
    wait for 10 ns;

    -- Test case 1: Choose tea (40 cents)
    euroIn <= '1';
    twentyCent <= '0';
    tee <= '1';
    coffee <= '0';
    wait for 20 ns;

    -- Test case 2: Choose coffee (60 cents)
    euroIn <= '1';
    twentyCent <= '0';
    tee <= '0';
    coffee <= '1';
    wait for 20 ns;

    -- Test case 3: Choose tea (40 cents) and coffee (60 cents)
    euroIn <= '1';
    twentyCent <= '0';
    tee <= '1';
    coffee <= '1';
    wait for 20 ns;

    -- Test case 4: Insert 20 cents (no drink chosen)
    euroIn <= '0';
    twentyCent <= '1';
    tee <= '0';
    coffee <= '0';
    wait for 20 ns;

    -- Test case 5: Choose tea (40 cents) with insufficient funds
    euroIn <= '0';
    twentyCent <= '0';
    tee <= '1';
    coffee <= '0';
    wait for 20 ns;

    -- Test case 6: Choose coffee (60 cents) with exact funds
    euroIn <= '1';
    twentyCent <= '1';
    tee <= '0';
    coffee <= '1';
    wait for 20 ns;

    -- Test case 7: Insert 50 cents (no drink chosen)
    euroIn <= '0';
    twentyCent <= '1';
    tee <= '1';
    coffee <= '0';
    wait for 20 ns;

    -- Test case 8: Insert 60 cents and choose coffee (exact funds)
    euroIn <= '0';
    twentyCent <= '1';
    tee <= '0';
    coffee <= '1';
    wait for 20 ns;

    -- Test case 9: Choose tea (40 cents) and receive 20 cents change
    euroIn <= '1';
    twentyCent <= '0';
    tee <= '1';
    coffee <= '0';
    wait for 20 ns;

    -- End the simulation
    wait;
  end process;


end Behavioral;

