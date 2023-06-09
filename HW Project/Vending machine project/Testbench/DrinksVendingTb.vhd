
library IEEE;
use IEEE.std_logic_1164.all;

entity DrinksVending_tb is
end entity;

architecture testbench_arch of DrinksVending_tb is
  -- Component declaration for the unit under test
  component DrinksVending
    port (
      Clock, Reset    : in  std_logic;
      euroIn, twentyCent, tee, coffee  : in  std_logic;
      DispenseD, returnAmount : out std_logic
    );
  end component;

  -- Signal declarations
  signal ClockSignal     : std_logic := '0';
  signal ResetSignal     : std_logic := '1';
  signal euroInSignal    : std_logic := '0';
  signal twentyCentSignal: std_logic := '0';
  signal teeSignal       : std_logic := '0';
  signal coffeeSignal    : std_logic := '0';
  signal DispenseDSignal : std_logic;
  signal returnAmountSignal : std_logic;

  -- Constants
  constant CLK_PERIOD : time := 10 ns;

begin
  -- Instantiate the unit under test
  UUT: DrinksVending
    port map (
      Clock => ClockSignal,
      Reset => ResetSignal,
      euroIn => euroInSignal,
      twentyCent => twentyCentSignal,
      tee => teeSignal,
      coffee => coffeeSignal,
      DispenseD => DispenseDSignal,
      returnAmount => returnAmountSignal
    );

  -- Clock process
  ClockProcess: process
  begin
    while now < 500 ns loop  -- Simulate for 500 ns
      ClockSignal <= '0';
      wait for CLK_PERIOD / 2;
      ClockSignal <= '1';
      wait for CLK_PERIOD / 2;
    end loop;
    wait;
  end process;

  -- Stimulus process
  StimulusProcess: process
  begin
    -- Reset
    ResetSignal <= '1';
    wait for 10 ns;
    ResetSignal <= '0';
    wait for 50 ns;

    -- Test case 1: Insert 20 cents, select tea, expect no dispense and return amount
    twentyCentSignal <= '1';
    teeSignal <= '1';
    wait for 20 ns;
    assert (DispenseDSignal = '0' and returnAmountSignal = '0')
      report "Test case 1 failed" severity error;

    -- Test case 2: Insert 20 cents, select coffee, expect dispense and return amount
    twentyCentSignal <= '1';
    teeSignal <= '0';
    coffeeSignal <= '1';
    wait for 20 ns;
    assert (DispenseDSignal = '1' and returnAmountSignal = '1')
      report "Test case 2 failed" severity error;

    -- Test case 3: Insert 20 cents, select tea and coffee, expect dispense and no return amount
    twentyCentSignal <= '1';
    teeSignal <= '1';
    coffeeSignal <= '1';
    wait for 20 ns;
    assert (DispenseDSignal = '1' and returnAmountSignal = '0')
      report "Test case 3 failed" severity error;

    -- End simulation
    wait;
  end process;

end architecture;
