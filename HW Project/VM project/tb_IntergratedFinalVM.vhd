library IEEE;
use IEEE.std_logic_1164.all;

entity tb_IntergratedFinalVM is
end entity;

architecture Behavioral of tb_IntergratedFinalVM is

    component IntergratedFinalVM
        port (Clock, Reset: in std_logic;
              euroIn, twentyCent, tee, coffee: in std_logic;
              An0, Display: out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;


  -- Declare necessary signals for test bench
    signal Clock, Reset, euroIn, twentyCent, tee, coffee: std_logic;
    signal An0, Display: STD_LOGIC_VECTOR(7 downto 0);

    -- Instantiate the DUT
    signal dut_Clock, dut_Reset: std_logic := '0';
    signal dut_euroIn, dut_twentyCent, dut_tee, dut_coffee: std_logic := '0';
    signal dut_An0, dut_Display: STD_LOGIC_VECTOR(7 downto 0);

begin

   -- Instantiate the module under test
    DUT: IntergratedFinalVM
    port map (
        Clock => dut_Clock,
        Reset => dut_Reset,
        euroIn => dut_euroIn,
        twentyCent => dut_twentyCent,
        tee => dut_tee,
        coffee => dut_coffee,
        An0 => dut_An0,
        Display => dut_Display
    );

  -- Clock process for generating a clock signal
  Stimulus_process: process
  begin
     while now < 1000 ns loop
            dut_Clock <= '0';
            wait for 5 ns;
            dut_Clock <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

  -- Stimulus process for applying inputs and observing outputs
  process
  begin
        -- Initialize inputs
        dut_Reset <= '1';
        euroIn <= '0';
        twentyCent <= '0';
        tee <= '0';
        coffee <= '0';
        wait for 10 ns;
        
        dut_Reset <= '0';
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



    -- End the simulation
    wait;
  end process;


end Behavioral;

