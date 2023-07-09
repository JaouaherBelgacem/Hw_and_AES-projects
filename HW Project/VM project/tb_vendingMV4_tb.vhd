library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity tb_vendingMV4_tb is
end tb_vendingMV4_tb;

architecture behave of tb_vendingMV4_tb is

  signal Clock: std_logic := '0';
  signal Reset: std_logic := '0';
  signal euroIn, twentyCent, tee, coffee: std_logic := '0';
  signal An0, Display: std_logic_vector(7 downto 0) := (others => '0');
  signal LED_s20, LED_s40: std_logic := '0';

  constant Clock_period : time := 10 ns;

  component VendingM is
    port ( Clock, Reset: in std_logic;
           euroIn, twentyCent, tee, coffee: in std_logic;
           An0,Display: out STD_LOGIC_VECTOR(7 downto 0);
           LED_s20, LED_s40: out std_logic
    );
  end component;

begin
  uut: VendingM port map (
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

  -- Clock process
  Clock_process: process
  begin
    Clock <= '0';
    wait for Clock_period/2;
    Clock <= '1';
    wait for Clock_period/2;
  end process;

  -- Stimulus process
  stim_proc: process
  begin
    -- Hold reset state for 100 ns.
    Reset <= '1';
    euroIn <= '0'; twentyCent <= '0'; tee <= '0'; coffee <= '0'; 
    wait for 100 ns;

    -- Release reset state
    Reset <= '0';
    wait for Clock_period;

    -- Case 1: Insert 20 cent
    twentyCent <= '1'; euroIn <= '0'; tee <= '0'; coffee <= '0';
    wait for Clock_period;

    -- Case 2: Insert another 20 cent
    twentyCent <= '1'; euroIn <= '0'; tee <= '0'; coffee <= '0';
    wait for Clock_period;

    -- Case 3: Select tea
    twentyCent <= '0'; euroIn <= '0'; tee <= '1'; coffee <= '0';
    wait for Clock_period;

    -- Case 4: Insert euro
    twentyCent <= '0'; euroIn <= '1'; tee <= '0'; coffee <= '0';
    wait for Clock_period;

    -- Case 5: Select coffee
    twentyCent <= '0'; euroIn <= '0'; tee <= '0'; coffee <= '1';
    wait for Clock_period;

    -- Finish the test
    assert false
    report "End of test achieved!" severity note;
    wait;
  end process;

end behave;

